const fs = require('fs');
let infile = '';
let outfile = '';
let outstream = '';
let template = '';
let ti = 0;
let limit = 100;
let flags = [];
let outdata = "";

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
            
        }
                
        let contents = await fs.readFileSync( infile );
        contents = contents.toString();
        
        await parse( contents );
                        
    } catch(e) {
        console.error(e.message);
    }
    
}

async function output( txt ) {
    
    if( flags.includes('o') ) { outstream.write(`${txt}\n`); } 
    outdata += `${txt}\n`;
    
    console.info( txt );
        
}

async function getEnums( data ) {
    
    try {
        let enums = [];
        for( let i = 0; i < data.length; ++i ) {
            if( data[i].trim().match(/enum\s\w+\s*\{/gi) ) {
                let ename = data[i].trim().replace(/enum\s(\w+)\s*\{/gi, '$1');
                enums.push(ename);
                continue;
            }
        }  
        return enums;
    } catch(e) {
        throw e;
    }
    
}

async function getTables( data ) {
    
    try {
        let tables = [];
        for( let i = 0; i < data.length; ++i ) {
            if( data[i].trim().match(/message\s\w+\s*\{/gi) ) {
                let tname = data[i].trim().replace(/message\s+(\w+)\s*\{/gi,'$1')
                if( tname.includes('Get') || tname.includes('Rpc') ) { continue; }
                tables.push(tname);
                continue;
            }
        }  
        return tables;
    } catch(e) {
        throw e;
    }
    
}

async function getKeys( data, tables ) {
    
    try {        
        let keys = new Map();
        let oopen = false;
        let table = '';
        let fields = [];
        
        for( let i = 0; i < data.length; ++i ) {
            
            if( data[i].trim() === "" || data[i].trim().startsWith('//') || data[i].trim().match('syntax = \"proto3\"') ) { continue; }     
            if( data[i].trim().match(/message\s\w+\s*\{/gi) ) {
                let tableName = data[i].trim().replace(/message\s+(\w+)\s*\{/gi,'$1')
                if( !tables.includes(tableName) ) { continue; }

                table = tableName;
                oopen = true;
                continue;
            }
            
            if( oopen ) {
            
                if( data[i].trim().match('}') ) { 

                    keys.set(table, fields);
                    oopen = false;    
                    fields = [];
                    continue; 
                    
                }
                
                let fname = data[i].replace(/["repeated"\s]*\w+\s(\w+)\s=.*/g,'$1').trim();
                if( fname.includes('unknown_') || fname.includes('empty_') ) { continue; }
                
                let tmpname = fname.split(/_/g);
                for( let n = 1; n < tmpname.length; ++n ) {
                    tmpname[n] = tmpname[n].charAt(0).toUpperCase() + tmpname[n].slice(1);                    
                }
                fname = tmpname.join('');
                keys.push(fname);
                                
            }
            
        }
        return keys;
    } catch(e) {
        throw e;
    }
    
}

async function getPKeys( data, tables ) {
    
    try {        
        let keys = new Map();
        let oopen = false;
        let table = '';
        let fields = [];
        
        for( let i = 0; i < data.length; ++i ) {
            
            if( data[i].trim() === "" || data[i].trim().startsWith('//') || data[i].trim().match('syntax = \"proto3\"') ) { continue; }     
            if( data[i].trim().match(/message\s\w+\s*\{/gi) ) {
                let tableName = data[i].trim().replace(/message\s+(\w+)\s*\{/gi,'$1')
                if( !tables.includes(tableName) ) { continue; }

                table = tableName;
                oopen = true;
                continue;
            }
            
            if( oopen ) {
            
                if( data[i].trim().match('}') ) { 

                    keys.set(table, fields);
                    oopen = false;    
                    fields = [];
                    continue; 
                    
                }
                
                let fname = data[i].replace(/["repeated"\s]*\w+\s(\w+)\s=.*/g,'$1').trim();
                if( fname.includes('unknown_') || fname.includes('empty_') ) { continue; }
                
                let tmpname = fname.split(/_/g);
                for( let n = 1; n < tmpname.length; ++n ) {
                    tmpname[n] = tmpname[n].charAt(0).toUpperCase() + tmpname[n].slice(1);                    
                }
                fname = tmpname.join('');
                
                if( fname.includes("Id") || fname === "id" ) {
                    keys.push(fname);
                }
                
            }
            
        }
        return keys;
    } catch(e) {
        throw e;
    }
    
}

async function parse( data ) {

    try {
    
        data = data.split(/\n/);

        let enums = await getEnums( data );
        let tables = await getTables( data );
        
        let keys = await getKeys( data, tables );
        let pkeys = await getPKeys( data, tables );

        if( flags.includes('o') ) {
            outstream = fs.createWriteStream('./'+outfile+'.sql');
        }            
        
        let oopen = false; 
        
        for( let i = 0; i < data.length; ++i ) {
        
            if( data[i].trim() === "" || data[i].trim().startsWith('//') || data[i].trim().match('syntax = \"proto3\"') ) { continue; }     
            
            if( data[i].trim().match(/message\s\w+\s*\{/gi) ) {
                let tableName = data[i].trim().replace(/message\s+(\w+)\s*\{/gi,'$1')
                if( !tables.includes(tableName) ) { continue; }
                await output( 'CREATE TABLE IF NOT EXISTS `'+tableName+'` (' );
                oopen = true;
                continue;                
            }
            
            if( oopen ) {
            
                if( data[i].trim().match('}') ) { 

                    oopen = false;    
                    
                    await output(' '.repeat(2)+'`lastUpdated` TIMESTAMP NULL,');                    
                    if( pkey.length > 0 ) {
                        await output(' '.repeat(2)+'PRIMARY KEY (`'+pkey.join(', ')+'`)');
                    } else {
                        await output(' '.repeat(2)+'PRIMARY KEY (`'+keys.join(', ')+'`)');
                    }
                    pkey = [];
                    keys = [];
                    
                    await output(') ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;');
                    await output('/*');
                    await output(' * ------------------------------------------------------');
                    await output(' */');                    
                    continue; 
                    
                }
                
                let ftype = data[i].replace(/["repeated"\s]*(\w+)\s\w+\s=.*/g,'$1').trim();
                let fname = data[i].replace(/["repeated"\s]*\w+\s(\w+)\s=.*/g,'$1').trim();
                
                if( fname.includes('unknown_') || fname.includes('empty_') ) { continue; }
                
                let tmpname = fname.split(/_/g);
                for( let n = 1; n < tmpname.length; ++n ) {
                    tmpname[n] = tmpname[n].charAt(0).toUpperCase() + tmpname[n].slice(1);                    
                }
                fname = tmpname.join('');
                if( fname.includes("Id") || fname === "id" ) {
                    pkey.push(fname);
                } else {
                    keys.push(fname);
                }
                                
                ftype = ftype === "string" ? "varchar(128)" : ftype;
                ftype = ftype.includes("int32") ? "int(32)" : ftype;
                ftype = enums.includes(ftype) ? "int(32)" : ftype; //turn enums into int 
                ftype = ftype.includes("int64") ? "int(64)" : ftype;
                                
                await output(' '.repeat(2)+'`'+fname+'` '+ftype+' COLLATE utf8_bin NULL,');                
                                
            }
            
        }
        
        console.log( enums.length );

        console.log(enums.join('\n'));
        
        if( flags.includes('o') ) {
            await outstream.end();
        }

        
        
    } catch(e) {
        throw e;
    }

}

async function usage() {
    
    console.info('\nObject to proto decoder Help:');
    console.info('$ node sqlify -h');
    console.info('---------------------------------------');
    console.info('Usage:');
    console.info('$ node sqlify <infile> [flags] [outfile]');
    console.info('---------------------------------------');
    console.info('Flags:');    
    console.info('  -o\tOutput to file');
    console.info('---------------------------------------');
    console.info('Outfile:');
    console.info('Optional outfile ./location/name');
    return;
    
}

let args = process.argv.slice(2);

run( args );