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
        
        flags = !!args[1] ? args[1].split('') : 't';
        
        let contents = await fs.readFileSync( infile );
        contents = contents.toString();
                
        await parse( contents );
          
        await output();        
             
    } catch(e) {
        console.error(e);
    }
    
}


async function outputTable(obj, name, prefix, suffix) {
    
    prefix = prefix || '';
    suffix = suffix || '';
    
    let fks = '';
    let pks = [];
    let retStr = '';
    
    //APPEND TABLE CREATE STATEMENT  
    retStr += 'CREATE TABLE IF NOT EXISTS `'+name+'` ('+suffix;
    for( let f in obj.fields ) { 
        let field = obj.fields[f]; 
        
        //APPEND EACH FIELD
        if( field.type === "INT" || field.type === "BIGINT" || field.type === "VARCHAR" ) { 
            retStr += prefix+'`'+field.name+'` '+field.type+'('+field.size+') '+field.collation+' '+field.condition+','+suffix;
        } else if( field.type === "BOOLEAN" || field.type === "TIMESTAMP" || field.type === "TEXT" ) {
            retStr += prefix+'`'+field.name+'` '+field.type+' '+field.collation+' '+field.condition+','+suffix;
        }
        
        //IF FIELD IS PKEY, ADD TO LIST
        if( field.pkey ) {
            pks.push('`'+field.name+'`');
        }
        
        //IF FIELD IS FKEY, ADD TO LIST
        if( !!field.fkey ) {
            fks += fks.length === 0 ? 'FOREIGN KEY (`'+field.name+'`) REFERENCES '+field.fkey : ', '+suffix+'FOREIGN KEY (`'+field.name+'`) REFERENCES '+field.fkey;
        }        
        
    }
    
    //IF PKEY LIST HAS CONTENTS, APPEND PRIMARY KEYS
    if( pks.length > 0 ) {
        retStr += prefix+'PRIMARY KEY('+pks.join(', ')+')';
    } else {
        retStr = retStr.substr(0, retStr.length-suffix.length-1);
    }
    
    if( fks.length > 0 ) {
        retStr += ','+suffix+prefix+fks+suffix;
    } else {
        retStr += suffix;
    }
    
    //CLOSE TABLE CREATE STATEMENT
    retStr += ' )';
    
    //APPEND TABLE SETTINGS
    for( let s in obj.settings ) {
        retStr += prefix+s.toUpperCase()+'='+obj.settings[s];            
    }
    
    //CLOSE SQL TRANSACTION
    retStr += flags.includes('i') ? ';'+suffix : ';'+suffix+suffix;
    
    return retStr;

}

async function outputInsert(obj, name, prefix, suffix) {

    prefix = prefix || '';
    suffix = suffix || '';
    
    let pks = [];
    let retStr = '';
    let values = '';
    let fields = '';
    let auto = false;
        
    //APPEND INSERT STATEMENT  
    retStr += 'INSERT INTO `'+name+'` (';
    for( let f in obj.fields ) { 
        let field = obj.fields[f]; 
        
        //APPEND EACH FIELD
        if( field.type === "INT" || field.type === "BIGINT" || field.type === "VARCHAR" || field.type === "BOOLEAN" || field.type === "TIMESTAMP" || field.type === "TEXT" ) { 
            
            fields += fields.length === 0 ? prefix+'`'+field.name+'`' : ','+prefix+'`'+field.name+'`';        
            
            if( !field.pkey ) {
                values += values.length === 0 ? prefix+'`'+field.name+'`=VALUES(`'+field.name+'`)' : ','+prefix+'`'+field.name+'`=VALUES(`'+field.name+'`)';                
            } else {
                pks.push(field);
            }
            
        }
        
        
    }
    //CLOSE INSERT STATEMENT
    retStr += suffix+fields+prefix+suffix+') VALUES ? ';
    
    if( pks.length > 0 ) {
        retStr += suffix+'ON DUPLICATE KEY UPDATE'+suffix+values;
    } 
    
    //CLOSE SQL TRANSACTION
    retStr += ';'+suffix+suffix;
    
    return retStr;
    
}

async function outputClass(obj, name, prefix, suffix) {
    
    //Verify output folder
    await verifyFolder('./sql.classes/');
    
    let table = await outputTable(obj,name,prefix,suffix);
    let insert = await outputInsert(obj,name,prefix,suffix);
    
    //init class and constructor
    let output = 'const Sql = require(\'../sql.js\');\n';
    output += `const moment = require('moment');\n\n`;
    output += `class Sql${name} extends Sql {\n\n`;
    output += '  constructor(settings) {\n\n';
    output += '    super(settings);\n';
    output += `    this.table = "${table}";\n`;
    output += `    this.insert = "${insert}";\n\n`;
    output += '  }\n\n';
    
    //init bubble()
    output += '  async bubble(data, collection, key, depth, fkey) {\n\n';
    output += '     try {\n\n';
    output += `         if( !data ) { throw new Error(' ! No data passed to Sql${name}.bubble'); }\n`;
    output += `         if( !collection ) { throw new Error(' ! No collection passed to Sql${name}.bubble'); }\n`;
    output += '         depth = depth || 0;\n';
    output += '         data = Array.isArray(data) ? data : [ data ];\n\n';
    output += '         let result = null;\n\n';

    //Prepare data for insert
    output += '         collection[depth] = collection[depth] || {};\n';
    output += '         collection[depth][key] = collection[depth][key] || [];\n\n';
    output += '         for( let i = 0; i < data.length; ++i ) {\n\n';
    output += '             let inner = [];\n\n';
    output += '             data[i].id = data[i].id || ++collection.idCount;\n\n';
    
    //IF FOREIGN KEY WAS PASSED, SET IT BEFORE PUSHING OBJECT
    output += '             if( fkey ) {\n';
    output += '                 let fk = Object.keys(fkey)[0];\n';
    output += '                 data[i][fk] = fkey[fk];\n';
    output += '             }\n\n';    

    for( let f in obj.fields ) { 
        let field = obj.fields[f];
        if( field.type === "INT" || field.type === "BIGINT" || field.type === "VARCHAR" || field.type === "BOOLEAN" || field.type === "TIMESTAMP" || field.type === "TEXT" ) {
            if( field.name === 'lastUpdated' ) { 
                output += `             inner.push(moment(Date.now()).format('YYYY-MM-DD HH:mm:ss'));\n\n`; 
            } else {
                if( field.type === "TEXT" ) {
                    output += `             inner.push(JSON.stringify(data[i].${field.name}));\n\n`;
                } else {
                    output += `             inner.push(data[i].${field.name});\n\n`;
                }
            }
        }
    }
        
    output += '             collection[depth][key].push(inner);\n';
    output += '         }\n\n';

    output += '         for( let i = 0; i < data.length; ++i ) {\n\n';
    output += '             let payload = {"verbose":true};\n\n';
        
    let required = [];

    //console.log( obj.fields );
    
    for( let f in obj.fields ) { 
        let field = obj.fields[f];
        if( f!== 'undefined' && field.type !== "INT" && field.type !== "BIGINT" && field.type !== "VARCHAR" && field.type !== "BOOLEAN" && field.type !== "TIMESTAMP" && field.type !== "TEXT" ) {
            
            if( !required.includes(field.type) ) {
                //output += `             console.log('${field.type}');\n`;
                output += `             const Sql${field.type} = require('./sql.${field.type}.js');\n\n`;
                required.push(field.type);
            }
            output += `             if( typeof data[i].${field.name} !== "undefined" && data[i].${field.name}.length > 0 ) {\n`;            
            output += `                 collection = await new Sql${field.type}(payload).bubble(data[i].${field.name}, collection, '${field.type}', depth+1, fkey);\n`;
            output += `             }\n\n`;
            
        }
    }
    
    output += '         }\n\n';
    output += '         return collection;\n\n';
    
    output += '     } catch(e) {\n';
    output += '         this.end();\n         throw e;\n     }\n\n';
    output += '  }\n\n';
    
    
    //init run()
    output += '  async save(arr) {\n\n';
    output += '     try {\n\n';
    output += `         if( !arr ) { throw new Error(' ! No data passed to Sql${name}.save'); }\n`;
    output += '         let result = null;\n\n';
    
    //Insert table if not exists
    output += '         result = await this.insertTable( this.table );\n\n';
    output += '         result = await this.insertSQL( this.insert, arr );\n\n';
    output += '         if( result && !!this.verbose ) { console.info(` + ${arr.length} '+name+'(s) inserted`); }\n\n';

    output += '         return result;\n\n';
    output += '     } catch(e) {\n';
    output += '         this.end();\n         throw e;\n     }\n\n';
    output += '  }\n\n';
    
    //Close class and export module
    output += `}\n\nmodule.exports = Sql${name};`
    
    await fs.writeFileSync('./sql.classes/sql.'+name+'.js', output, 'utf8');
    
}

async function verifyFolder( folder ) {
    
    try {
    
        if( !folder ) { throw new Error(` ! No folder location passed to Rpc.verifyFolder`); }
        
        /** Check if folder exists - if not, create **/
        if( !fs.existsSync(folder) ) {
            
            console.info(`Creating new directory ${folder}...`);
            
            try {
            
               /** Attempt to execute the mkdir command and hide stdio error **/
               var execFileSync = require('child_process').execFileSync;
               
               // Execute: sh -c mkdir -p ${folder} 
               await execFileSync('sh', ['-c', `mkdir -p ${folder}`]);

               console.info(` + Created folder ${folder}`);
               return true;  
                                 
            } catch(e) {
               throw new Error(` ! Could not mkdir ${folder}`);
            }
            
        } else { 
           return true;
        }
                
    } catch(e) {
        throw e;
    }
    
}

async function output() {
    
    let fileObj = Object.assign({}, template.tables);
    if( fileObj.enums ) { delete fileObj.enums; }
    
    let suffix = flags.includes('p') ? '\n' : '';
    let prefix = flags.includes('p') ? '  ' : ' ';
    
    let filecontent = ""; 
    for( let k in fileObj ) {
        
        if( flags.includes('t') ) { filecontent += await outputTable(fileObj[k], k, prefix, suffix) +'\n'; }
        if( flags.includes('i') ) { filecontent += await outputInsert(fileObj[k], k, prefix, suffix) +'\n'; }
        
        if( flags.includes('c') ) {
            
            filecontent = await outputClass(fileObj[k], k, prefix, suffix);
            
        }
        
    }    
    
    if( !flags.includes('c') ) {
        //OUTPUT FORMATTED CONTENTS TO OUTFILE.sql
        await fs.writeFileSync('./'+outfile+'.sql', filecontent, 'utf8');
        await fs.writeFileSync('./'+outfile+'.json', JSON.stringify(template,""," "), 'utf8');    
    }
    
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
                if( tname.includes('Get') || tname.includes('Rpc') || tname.includes('Auth') ) { continue; }
                
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
                if( tname.includes('Get') || tname.includes('Rpc') || tname.includes('Auth') ) { continue; }
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
                field.name = !repeated ? fname : fname+'List';
                if( ftype.includes("map") ) {
                    fname = fname.split(/\s+/g)[1];
                    ftype = fname.split(/\s+/g)[0];
                    field.name = !repeated ? fname : fname.replace('List','')+'List';
                    field.type = "TEXT";
                    field.size = 0;                
                } else if( ftype.includes("int32") || template.enums.includes(ftype) ) {
                    if( repeated ) {
                        field.type = "TEXT";
                        field.size = 0;
                    } else {
                        field.type = "INT";
                        field.size = 32;
                    }
                } else if( ftype.includes("int64") ) {
                    if( repeated ) {
                        field.type = "TEXT";
                        field.size = 0;
                    } else {
                        field.type = "BIGINT";
                        field.size = 64;
                    }
                } else if( ftype === "string" ) {
                    if( repeated ) {
                        field.type = "TEXT";
                        field.size = 0;
                    } else {
                        field.type = "VARCHAR";
                        field.size = 128;
                    }
                } else if( ftype === "bool" ) {
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
                field.pkey = fname === tname.toLowerCase()+'Id' ? true : false;
                field.condition = fname === tname.toLowerCase()+'Id' ? "NOT NULL" : "NULL";
                
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
                if( field.ref && t !== 'GameData' ) {
                    
                    let newField = Object.assign({},template.tables[t].fields[field.ref.ptable.keys[0]]);
                    
                    //newField.name       = field.ref.ptable.keys[0];

                    //if( t === 'Player' ) {
                    //    console.log( template.tables[t].fields[field.ref.ptable.keys[0]] );
                    //}
                        
                    //newField.type       = template.tables[t].fields[newField.name].type;
                    //newField.size       = template.tables[t].fields[newField.name].size;
                    //newField.collation  = template.tables[t].fields[newField.name].collation;
                    newField.pkey       = false;
                    newField.fkey       = '`'+field.ref.ptable.name+'`(`'+newField.name+'`)';
                    newField.condition  = 'NULL';
                    
                    template.tables[field.ref.ftable.name].fields[newField.name] = Object.assign({},newField);

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
    console.info('$ node sqlify <infile> -[flags]');
    console.info('---------------------------------------');
    console.info('Build table-create script:');
    console.info('$ node sqlify <infile> -t');
    console.info('---------------------------------------');
    console.info('Build table-insert script:');
    console.info('$ node sqlify <infile> -i');
    console.info('---------------------------------------');
    console.info('Pretty print...kinda [good for debug]:');
    console.info('$ node sqlify <infile> -p');    
    return;
    
}

let args = process.argv.slice(2);

run( args );