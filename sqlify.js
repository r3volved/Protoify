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
        //contents = JSON.parse(contents);
        
        await parse( contents.toString() );
        
        if( flags.includes('o') ) {
            outfile.end();
        }
        
    } catch(e) {
        console.error(e.message);
    }
    
}

async function output( txt ) {
    
    if( flags.includes('o') ) { outfile.write(`${txt}\n`); } 
    console.info( txt );
        
}

async function parse( data ) {

    try {
    
        let oopen = false; 
        
        data = data.split(/\n/);
        for( let i = 0; i < data.length; ++i ) {
        
            if( data[i].trim().match('syntax = \"proto3\"') ) { continue; }     
            if( data[i].trim().match(/message\s\w+\s*\{/gi) ) {
                let tableName = data[i].trim().replace(/message\s+(\w+)\s*\{/gi,'$1')
                await output( 'CREATE TABLE IF NOT EXISTS `'+tableName+'` (' );
                oopen = true;
                continue;                
            }
            
            if( oopen ) {
            
                if( data[i].trim().match('}') ) { 
                    oopen = false;    
                    
                    await output(' '.repeat(2)+'`lastUpdated` TIMESTAMP NULL,');
                    await output(' '.repeat(2)+'PRIMARY KEY (``)');
                    await output(') ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;');
                    await output('/*');
                    await output('------------------------------------------------------');
                    await output('*/');                    
                    continue; 
                }
                
                let ftype = data[i].replace(/["repeated"\s]*(\w+)\s\w+\s=.*/g,'$1').trim();
                let fname = data[i].replace(/["repeated"\s]*\w+\s(\w+)\s=.*/g,'$1').trim();
                
                ftype = ftype === "string" ? "varchar(128)" : ftype;
                ftype = ftype === "int32" ? "int(32)" : ftype;
                ftype = ftype === "int64" ? "int(64)" : ftype;
                
                await output(' '.repeat(2)+'`'+fname+'` '+ftype+' COLLATE utf8_bin NULL,');                
                                
            }             
            
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