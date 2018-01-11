const fs = require('fs');

let isFound = [];


async function run() {
    
    try {
	    const infile = process.argv[2];    
	    const  inprotos = fs.readFileSync(infile);
	    
	    let lines = inprotos.toString().split(/\n/g);
	    
	    let outfile = fs.createWriteStream('./protocol.proto');
	    
	    outfile.write('syntax = \"proto3\";\n\n'); 
	    
	    let oopen = false; 
	    let name = null;
	    let isEnum = false;
	    
	    for( let i = 0; i < lines.length; ++i ) { 
	    
	        if( lines[i].trim() === "" || lines[i].startsWith('syntax') || lines[i].startsWith('package') || lines[i].startsWith('/*') || lines[i].startsWith('//') ) { continue; }
	        
	        let pcs = lines[i].split(/\s+/g);
	                
	        if( lines[i].startsWith('message') || lines[i].startsWith('enum') ) {
	        
	            name = lines[i].split(/\s+/g)[1];
	            if( isFound.includes(name) ) { continue; }
	            
	            isEnum = lines[i].startsWith('enum');
	            isFound.push(name);
	            oopen = true;
	            
	        }
	        
	        if( oopen ) {
	            
	            let item = lines[i];	            
	            if( item.trim().startsWith('ZERO') && !!name ) {
	               item = `   NO_${name.toUpperCase()} = 0;`;
	            } 

                if( lines[i].trim() !== '}' && !isEnum && !item.trim().startsWith('repeated') && !lines[i].startsWith('message') && !lines[i].startsWith('enum') ) {
	            //   item = '   optional '+item.trim();
	            }
	                        
	            if( lines[i].trim() === '}' ) { oopen = false; }
	            
	            outfile.write( item+'\n' );
	                        
	        } 
	                
	    }
	    
	    outfile.end();  
	    
    } catch(e) {
        console.error(e);
	}
	
} 

run();