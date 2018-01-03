const fs = require('fs');
let infile = '';
let outfile = '';

let outdata = "";
let outstream = '';
let flags = [];

async function run( args ) {
    
    try {
        
        if( args[0] === ('-h') ) {
            return usage();
        }
        
        if( args.length === 1 ) {
            
            /** Model the json */
            
            let infile = args[0];
            if( !infile || infile.length === 0 || !fs.existsSync(infile) ) { throw new Error('File does not exist'); }
                
            let contents = await fs.readFileSync( infile );

            await parse( contents );
            await output( infile );
            return true;
        
        } else if( args.length > 1 ) {
            
            if( args[1] === '-c' ) {
                
                let oldfile = args[0];
                if( !oldfile || oldfile.length === 0 || !fs.existsSync(oldfile) ) { throw new Error('File 1 does not exist'); }
                
                let newfile = args[2];
                if( !newfile || newfile.length === 0 || !fs.existsSync(newfile) ) { throw new Error('File 2 does not exist'); }

                let oldcontent = await fs.readFileSync( oldfile );
                oldcontent = oldcontent.toString();
                
                let newcontent = await fs.readFileSync( newfile );
                newcontent = newcontent.toString();
                
                let result = await compare( oldcontent, newcontent );
                console.log( `${result ? 'same' : 'not the same'}` );
                return result;
                
            } else {                
                console.log('unknown flag');
                return usage();
            }

        }
             
    } catch(e) {
        console.error(e.message);
        return false;
    }
    
}

async function compare( o, n ) {
    
    try {
        
        o = o.split('\n');
        n = n.split('\n');
        
        if( o.length !== n.length ) { return false; }
        //if( )
        
        return true;
             
    } catch(e) {
        throw e;
    }
    
}

async function output( filename ) {
    
    outfile = filename+'.jm';                
    console.log( outdata );  
    
    await fs.writeFileSync(outfile, outdata, 'utf8');            
    console.log('Complete');
    return true;
    
}

async function parseArray( jdata, indepth ) {

    try {
        
        let depth = indepth || 0;
        let prefix = depth+":";
        
        for( let k = 0; k < jdata.length; ++k ) {

            if( typeof jdata[k] === "object" ) {
                if( Array.isArray(jdata[k]) ) {
                    outdata += prefix + 'array';
                    if( !jdata[k].every((obj) => { return typeof obj === typeof jdata[k][0] }) ) {
                        outdata += ' (mixed)\n';
                    } else { 
                        outdata += ' ('+typeof jdata[k][0]+')\n';
                    }
                    await parseArray(jdata[k], depth+1);
                } else {
                    outdata += prefix + 'object\n';
                    await parseObject(jdata[k], depth+1);
                }
            } else {
                outdata += prefix + typeof jdata[k] + '\n';    

                if( jdata.every((obj) => { return typeof obj === typeof jdata[k] }) ) {
                    return true;
                }
                
            }

        }
        
        return true;
        
    } catch(e) {
        throw e;
    }
    
}

async function parseObject( jdata, indepth ) {
    
    try {
        
        let depth = indepth || 0;
        let prefix = depth+":";
        
        for( let k in jdata ) {
            
            if( typeof jdata[k] === "object" ) {
                if( k.includes('map') ) {
                    outdata += prefix + 'map\n';
                    await parseMap(jdata[k], depth+1);
                } else if( Array.isArray(jdata[k]) ) {
                    outdata += prefix + 'array';
                    if( !jdata[k].every((obj) => { return typeof obj === typeof jdata[k][0] }) ) {
                        outdata += ' (mixed)\n';
                    } else { 
                        outdata += ' ('+typeof jdata[k][0]+')\n';
                    }
                    await parseArray(jdata[k], depth+1);
                } else {
                    outdata += prefix + 'object\n';
                    await parseObject(jdata[k], depth+1);
                }
            } else {
                outdata += prefix + typeof jdata[k] + '\n';    
            }
            
        }
        
        return true;
        
    } catch(e) {
        throw e;
    }
    
}

async function parseMap( jdata, indepth ) {

    try {
        
        let depth = indepth || 0;
        let prefix = depth+":";
        
        for( let k in jdata ) {
            
            for( let m in jdata[k] ) {
                
                if( typeof jdata[k][m] === "object" ) {
                    if( Array.isArray(jdata[k][m]) ) {
                        outdata += prefix + 'array';
                        if( !jdata[k][m].every((obj) => { return typeof obj === typeof jdata[k][m][0] }) ) {
                            outdata += ' (mixed)\n';
                        } else { 
                            outdata += ' ('+typeof jdata[k][m][0]+')\n';
                        }
                        await parseArray(jdata[k][m], depth+1);
                    } else {
                        outdata += prefix + 'object\n';
                        await parseObject(jdata[k][m], depth+1);
                    }
                } else {
                    outdata += prefix + typeof jdata[k][m] + '\n';    
                }
                
                
            }
            
            break;
        }
        
    } catch(e) {
        throw e;
    }
    
}

async function parse( data ) {

    try {
    
        jdata = JSON.parse( data );

        let prefix = "0:";
        
        switch( typeof jdata ) {
            case "undefined":
                throw new Error("unknown datatype");
                break;
            case "object":
                if( Array.isArray(jdata) ) {
                    outdata += prefix + 'array';
                    if( !jdata.every((obj) => { return typeof obj === typeof jdata[0] }) ) {
                        outdata += ' (mixed)\n';
                    } else { 
                        outdata += ' ('+typeof jdata[0]+')\n';
                    }
                    await parseArray(jdata, 1);
                    break;
                } 
                outdata += prefix + 'object\n';
                await parseObject(jdata, 1);
                break;
            default:
                outdata += prefix + typeof jdata + '\n';
                
        }
        
        return true;
        
        
    } catch(e) {
        throw e;
    }

}

async function usage() {
    
    console.info('\nJSON Model of a given file - Help:');
    console.info('$ node jmodel -h');
    console.info('---------------------------------------');
    console.info('Create jmodel:');
    console.info('$ node jmodel <infile>');
    console.info('---------------------------------------');
    console.info('Compare jmodels:');
    console.info('$ node jmodel <oldfile.jm> -c <newfile.jm>');
    return true;
    
}

let args = process.argv.slice(2);

run( args );