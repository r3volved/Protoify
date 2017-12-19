const fs = require('fs');
let infile = '';
let outfile = '';

let template = {};
let outdata = "";
let outstream = '';
let flags = [];



async function run( args ) {
    
    try {
        
        if( args[0] === ('-h') ) {
            return usage();
        }
        
        infile = args[0];
        if( !infile || infile.length === 0 || !fs.existsSync(infile) ) { throw new Error('File does not exist'); }
        outfile = infile.replace(/\.\/(\w+)\.proto/,'$1');                
                
        let contents = await fs.readFileSync( infile );
        contents = contents.toString();
                
        await parse( contents );
          
        await output();        
             
    } catch(e) {
        console.error(e.message);
    }
    
}

async function output() {
    
    let fileObj = Object.assign({}, template.tables);
    if( fileObj.enums ) { delete fileObj.enums; }
    
    let filecontent = ""; 
    for( let k in fileObj ) {
        
        let pks = [];
        
        //APPEND TABLE CREATE STATEMENT  
        filecontent += 'CREATE TABLE IF NOT EXISTS `'+k+'` (\n';
        for( let f in fileObj[k].fields ) { 
            let field = fileObj[k].fields[f]; 
            
            //APPEND EACH FIELD
            if( field.type === "INT" || field.type === "VARCHAR" ) { 
                filecontent += '  `'+field.name+'` '+field.type+'('+field.size+') '+field.collation+' '+field.condition+',\n';
            } else if( field.type === "BOOLEAN" || field.type === "TIMESTAMP" ) {
                filecontent += '  `'+field.name+'` '+field.type+' '+field.collation+' '+field.condition+',\n';
            }
            
            //IF FIELD IS PKEY, ADD TO LIST
            if( field.pkey ) {
                pks.push('`'+field.name+'`');
            }
            
        }
        
        //IF PKEY LIST HAS CONTENTS, APPEND PRIMARY KEYS
        if( pks.length > 0 ) {
            filecontent += '  PRIMARY KEY('+pks.join(', ')+')\n';
        } else {
            filecontent = filecontent.substr(0, filecontent.length-2)+'\n';
        }
        
        //CLOSE TABLE CREATE STATEMENT
        filecontent += ')';
        
        //APPEND TABLE SETTINGS
        for( let s in fileObj[k].settings ) {
            filecontent += ' '+s.toUpperCase()+'='+fileObj[k].settings[s];            
        }
        
        //CLOSE SQL TRANSACTION
        filecontent += ';\n\n'; 
       
    }    
    
    //OUTPUT FORMATTED CONTENTS TO OUTFILE.sql
    await fs.writeFileSync('./'+outfile+'.sql', filecontent, 'utf8');
    await fs.writeFileSync('./'+outfile+'.tmp', JSON.stringify(template,""," "), 'utf8');    
        
    console.log('Complete');
    
}

/** Collect enums and table names */
async function getContainers( data ) {
    
    try {
        template.tables = {};        
        template.enums = [];
        template.tnames = [];
        
        for( let i = 0; i < data.length; ++i ) {
            if( data[i].trim().match(/enum\s\w+\s*\{/gi) ) {
                let ename = data[i].trim().replace(/enum\s(\w+)\s*\{/gi, '$1');
                template.enums.push(ename);                
                continue;
            }
            if( data[i].trim().match(/message\s\w+\s*\{/gi) ) {
                let tname = data[i].trim().replace(/message\s+(\w+)\s*\{/gi,'$1')
                if( tname.includes('Get') || tname.includes('Rpc') ) { continue; }
                
                let table = {};
                table = {"fields":{}, "settings":{"engine":"InnoDB","charset":"utf8","collate":"utf8_bin"}}                
                template.tables[tname] = table;
                template.tnames.push(tname);
                continue;
            }
        }  
        
        return true;
    } catch(e) {
        throw e;
    }
    
}

/** Collect field info */
async function getFields( data ) {
    
    try {    
        
        let oopen = false;
        let tname = '';
        let pks = [];
        
        //PARSE ALL ROWS IN DATA
        for( let i = 0; i < data.length; ++i ) {
            
            //SKIP BLANKS, COMMENTS AND SYNTAX HEADER
            if( data[i].trim() === "" || data[i].trim().startsWith('//') || data[i].trim().match('syntax = \"proto3\"') ) { continue; }             
            
            //MATCH MESSAGE NAME AND CREATE TABLE
            if( data[i].trim().match(/message\s\w+\s*\{/gi) ) {
                tname = data[i].trim().replace(/message\s+(\w+)\s*\{/gi,'$1')
                if( tname.includes('Get') || tname.includes('Rpc') ) { continue; }
                oopen = true;
                continue;
            }
            
            //IF COLLECTING MESSAGE
            if( oopen ) {
            
                if( data[i].trim().match('}') ) { 
                    
                    //STOP COLLECTING MESSAGE
                    oopen = false;
                    
                    //APPEND LAST UPDATED FIELD
                    let field = {};
                    field = {"name":"lastUpdated","type":"TIMESTAMP","size":32,"collation":"COLLATE utf8_bin","pkey":false,"condition":"NULL"};
                    template.tables[tname].fields.lastUpdated = field;                   
                    
                    //IF NO PRIMARY KEYS, ADD 'id' FIELD
                    if( pks.length === 0 ) {
		                field = {};                
	                    field.name = 'id';
	                    field.type = "INT";
	                    field.size = "32";
	                    field.collation = "COLLATE utf8_bin";
	                    field.pkey = true;
	                    field.condition = "NOT NULL";
		                template.tables[tname].fields.id = field;
		                pks.push('id');           
		            }
		            
		            //MAP PRIMARY KEYS TO TABLE
		            template.tables[tname].pks = pks;
                    pks = [];
                    continue;   
                 
                }

                //FLAG FOR REPEATING DATA
                let repeated = data[i].includes('repeated');
                
                //GET FIELD NAME AND TYPE
                let ftype = data[i].replace(/["repeated"\s]*(\w+)\s\w+\s=.*/g,'$1').trim();
                let fname = data[i].replace(/["repeated"\s]*\w+\s(\w+)\s=.*/g,'$1').trim();
                if( fname.includes('unknown_') || fname.includes('empty_') ) { continue; }
                
                //TRANSPOSE NAME TO CAMEL-HUMP NOTATION
                let tmpname = fname.split(/_/g);
                for( let n = 1; n < tmpname.length; ++n ) {
                    tmpname[n] = tmpname[n].charAt(0).toUpperCase() + tmpname[n].slice(1);                    
                }
                fname = tmpname.join('');
                
                //CREATE A FIELD OBJECT
                let field = {};                
                field.name = fname;
                if( ftype.includes("int32") || template.enums.includes(ftype) ) {
                    field.type = "INT";
                    field.size = 32;
                } else if( ftype.includes("int64") ) {
                    field.type = "INT";
                    field.size = 64;                
                } else if( ftype === "string" ) {
                    field.type = "VARCHAR";
                    field.size = 128;                
                } else if( ftype === "boolean" ) {
                    field.type = "BOOLEAN";
                    field.size = 0;                
                } else if( template.tnames.includes(ftype) ) {
                    field.type = ftype;
                    field.size = 0;                
                } else {
                    field.type = "ERROR";
                    field.size = 0;
                    continue;
                }                               
                field.collation = "COLLATE utf8_bin";
                field.pkey = fname.match(/^id$|Id$/gm) ? true : false;
                field.condition = "NULL";
                
                //IF FIELD IS A PRIMARY KEY, TRACK IT
                if( field.pkey ) { pks.push(fname); }                
                
                //IF FIELD TYPE IS ANOTHER TABLE, ADD REFERENCE FOR NORMALIZATION
                if( template.tnames.includes(ftype) ) {
                    let pTable = tname;
                    let fTable = field.type;           
                    field.ref = {};
                    field.ref.ptable = { "name":pTable, "keys":[] };
                    field.ref.ftable = { "name":fTable, "keys":[] };
                } 
                
                //ADD FIELD TO TABLE
                template.tables[tname].fields[fname] = field;                
                                
            }
                        
        }  
        
        return true;
    } catch(e) {
        throw e;
    }
    
}


async function getReferenceKeys( data ) { 

    try {
    
        //PARSE EACH FIELD IN EACH TABLE
        for( let t in template.tables ) {
            for( let f in template.tables[t].fields ) {
                
                let field = template.tables[t].fields[f];
                if( field.ref ) {
                    //IF ref EXISTS, MAP ALL THE PRIMARY AND FOREIGN KEYS
                    field.ref.ptable.keys = template.tables[t].pks;
                    field.ref.ftable.keys = template.tables[field.ref.ftable.name] ? template.tables[field.ref.ftable.name].pks : [];
                }
                 
            }
        }               

        return true;
        
    } catch(e) {
        throw e;
    }
    
}


async function addNormalization( data ) { 

    try {
    
        let newTables = [];
        
        //PARSE EACH FIELD IN EACH TABLE        
        for( let t in template.tables ) {            
            for( let f in template.tables[t].fields ) {
                
                let field = template.tables[t].fields[f];
                if( field.ref ) {
                    
                    //CREATE NEW JOINED-TABLE
                    let newTableName = field.ref.ptable.name+"_"+field.ref.ftable.name;
                    
                    if( !template.tables[newTableName] ) { 
                        
                        template.tables[newTableName] = {"fields":{}, "settings":{"engine":"InnoDB","charset":"utf8","collate":"utf8_bin"}};
                        
                        for( let f in field.ref.ptable.keys ) { 
                            let match = template.tables[field.ref.ptable.name].fields[field.ref.ptable.keys[f]];
                            let newName = field.ref.ptable.name+'_'+match.name;
                            template.tables[newTableName].fields[newName] = {"name":newName,"type":match.type,"size":match.size,"collation":match.collation,"pkey":match.pkey,"condition":match.condition};
                        }
                        for( let f in field.ref.ftable.keys ) { 
                            let match = template.tables[field.ref.ftable.name].fields[field.ref.ftable.keys[f]];
                            let newName = field.ref.ftable.name+'_'+match.name;
                            template.tables[newTableName].fields[newName] = {"name":newName,"type":match.type,"size":match.size,"collation":match.collation,"pkey":match.pkey,"condition":match.condition};
                        }
                    
	                    template.tables[newTableName].fields.lastUpdated = {"name":"lastUpdated","type":"TIMESTAMP","size":32,"collation":"COLLATE utf8_bin","pkey":false,"condition":"NULL"};
	                    
                    }

                }
                
            }            
        }               

        return true;
        
    } catch(e) {
        throw e;
    }
    
}


async function parse( data ) {

    try {
    
        data = data.split(/\n/);

        await getContainers( data );
        await getFields( data );
        await getReferenceKeys( data );
        await addNormalization( data );
        
    } catch(e) {
        throw e;
    }

}

async function usage() {
    
    console.info('\nProtobuf definitions to SQL tables - Help:');
    console.info('$ node sqlify -h');
    console.info('---------------------------------------');
    console.info('Usage:');
    console.info('$ node sqlify <infile>');
    return;
    
}

let args = process.argv.slice(2);

run( args );