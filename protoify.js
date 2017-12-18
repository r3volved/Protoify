const fs = require('fs');
let infile = '';
let outfile = '';
let template = '';
let ti = 0;
let limit = 100;
let flags = [];

async function run( args ) {
    
    try {
        
        if( args[0] === ('-h') ) {
            return usage();
        }
        
        infile = args[0];
        if( !infile || infile.length === 0 || !fs.existsSync(infile) ) { throw new Error('File does not exist'); }
                
        if( args[1] && args[1].split('')[0] === '-' ) {
            
            flags = args[1].split('');
            outfile = args[2];
            
            if( flags.includes('t') ) {
                if( fs.existsSync(outfile) ) { 
                    template = await fs.readFileSync(outfile);
                    template = template.toString().split(/\n/gm);
                }
            }
            
            if( flags.includes('l') ) {
               limit = args[3] || args[2];
            }
            
            if( flags.includes('o') ) {
                outfile = fs.createWriteStream('./'+outfile);
            }            
            
        }
                
        let contents = await fs.readFileSync( infile );
        contents = JSON.parse(contents);
        
        await parse( contents );
        
        if( flags.includes('o') ) {
            outfile.end();
        }
        
    } catch(e) {
        console.error(e.message);
    }
    
}

async function usage() {
    
    console.info('\nObject to proto decoder Help:');
    console.info('$ node protoify -h');
    console.info('---------------------------------------');
    console.info('Usage:');
    console.info('$ node protoify <infile> [flags] [outfile]');
    console.info('---------------------------------------');
    console.info('Flags:');    
    console.info('  -o\tOutput to file');
    console.info('  -n\tAdd name (unknown) to definitions');
    console.info('  -v\tAdd values to definitions (value comments help decypher key names)');
    console.info('  -d\tAdd depth to definitions (appends depth to each line for debuging)');
    console.info('  -t\tPreload outfile and keep existing names');
    console.info('---------------------------------------');
    console.info('Outfile:');
    console.info('Optional outfile ./location/name');
    return;
    
}

async function output( txt ) {
    
    if( flags.includes('t') ) { 
        let fieldname = template[ti].split(/=/)[0].trim().split(/\s/);
        fieldname = fieldname[fieldname.length-1].trim();
        txt = txt.replace(/unknown/gi,fieldname); 
        ++ti;
    }
    if( !flags.includes('d') ) { txt = txt.slice(4); }
    if( !flags.includes('v') ) { txt = txt.split('//')[0]; }
    if( flags.includes('o') ) { outfile.write(`${txt}\n`); } 
    console.info( txt );
        
}


async function parse( json ) {
    
    try {
        
        let depth = 0;

        let outdepth = depth < 10 ? ' '+depth.toString() : depth;
        let prefix = '['+(outdepth)+']'+' '.repeat(depth);
    
        let count = 0;    
        let name = flags.includes('n') ? 'unknown' : '';
        
        if( typeof json === "undefined" ) {
            await output(`${prefix}//null ${name} = ${count};`);
        } else if( Array.isArray(json) ) { 
            await parseArray( json, depth, count, name );
        } else if( typeof json === "object" ) {
            await parseObject( json, depth, count, name );
        } else if( typeof json === "number" ) { 
            if( json < 1000 ) {
                await output(`${prefix}int32 ${name} = ${count};`);
            } else {
                await output(`${prefix}int64 ${name} = ${count};`);
            }
        } else {
            await output(`${prefix}${typeof(json)} ${name} = ${count};`);
        }

    } catch(e) {
        throw e;
    }
}

async function parseArray( a, depth, count, name ) {
    
    try {
    
        if( flags.includes('l') && depth > limit ) { return; }
        
        let outdepth = depth < 10 ? ' '+depth.toString() : depth;
        let prefix = '['+(outdepth)+']'+' '.repeat(depth);
    
        count = count || 0;    
        
        for( let i = 0; i < a.length; ++i ) {
            
            if( typeof a[i] === "undefined" || a[i] === null ) {
                await output(`${prefix}//null ${name} = ${count}; //${a[i]}`);
            } else if( Array.isArray(a[i]) ) { 
                let type = typeof(a[i]) === 'object' ? 'Object' : typeof(a[i]);                        
                await output(`${prefix}repeated ${type} ${name} = ${count};`);
                await parseArray( a[i], depth+1, 0, name );
            } else if( typeof a[i] === "object" ) {
                await output(`${prefix}Object ${name} = ${count};`);                
                await parseObject( a[i], depth+1, 0, name );
            } else if( typeof a[i] === "number" ) { 
                if( a[i] < 1000 ) {
                    await output(`${prefix}int32 ${name} = ${count}; //${a[i]}`);
                } else {
                    await output(`${prefix}int64 ${name} = ${count}; //${a[i]}`);
                }
            } else {
                await output(`${prefix}${typeof(a[i])} ${name} = ${count}; //${a[i]}`);
            }
            
            if( a.every( val => typeof a[i] === 'object' && typeof val === typeof a[i] ) ) { break; }
            ++count;
        
        }

    } catch(e) {
        throw e;
    }

}

async function parseObject( o, depth, count, name ) {
    
    try {
        
        if( flags.includes('l') && depth > limit ) { return; }
        
        let outdepth = depth < 10 ? ' '+depth.toString() : depth;
        let prefix = '['+(outdepth)+']'+' '.repeat(depth);

        count = count || 0;
        
        for( let k in o ) {
               
            name = isNaN(k) ? k : 'unknown'+k ; 
            
            if( typeof o[k] === "undefined" || o[k] === null ) {
                await output(`${prefix}//null ${name} = ${count}; //${o[k]}`);
            } else if( k.match(/map/gi) ) {
                let mapped = [];
                for( let mk in o[k] ) {
                    for( let mkv in o[k][mk] ) {
                        mapped.push(typeof(o[k][mk][mkv]));
                    }
                    break;
                }
                await output(`${prefix}map<${mapped.join(',')}> ${name} = ${count};`);
            } else if( Array.isArray(o[k]) ) { 
                let type = typeof(o[k]) === 'object' ? 'Object' : typeof(o[k]);                        
                await output(`${prefix}repeated ${type} ${name} = ${count};`);
                //await parseArray( o[k], depth+1, count, name );
                await parseObject( o[k], depth+1, count, name );                    
            } else if( typeof o[k] === "object" ) {
                await output(`${prefix}Object ${name} = ${count};`);
                await parseObject( o[k], depth+1, count, name );
            } else if( typeof o[k] === "number" ) { 
                if( o[k] < 1000 ) {
                    await output(`${prefix}int32 ${name} = ${count}; //${o[k]}`);
                } else {
                    await output(`${prefix}int64 ${name} = ${count}; //${o[k]}`);
                }
            } else {
                await output(`${prefix}${typeof(o[k])} ${name} = ${count}; //${o[k]}`);
            }
            
            ++count;
                
        }   
        
        return;

    } catch(e) {
        throw e;
    }
   
}

let args = process.argv.slice(2);

run( args );