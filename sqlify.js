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
        
        if( field.name === 'modDefinition' ) {
            //SPECIAL CASE FOR MOD DEFINITION - SPLIT INTO THREE COLUMNS
            retStr += prefix+'`modSetId` VARCHAR(128) COLLATE utf8_bin NULL,'+suffix;
            retStr += prefix+'`modQuality` INT(32) COLLATE utf8_bin NULL,'+suffix;
            retStr += prefix+'`modSlot` INT(32) COLLATE utf8_bin NULL,'+suffix;

            fks += fks.length === 0 ? 'FOREIGN KEY (`modSetId`) REFERENCES `ModSet`(`modSetId`)' : ', '+suffix+'FOREIGN KEY (`modSetId`) REFERENCES `ModSet`(`modSetId`)';
            
        } else if( field.name === 'modStatDefinition' ) {
            //SPECIAL CASE FOR MOD STAT DEFINITION - SPLIT INTO FOUR COLUMNS
            retStr += prefix+'`modStatType` INT(32) COLLATE utf8_bin NULL,'+suffix;
            retStr += prefix+'`modSomething` INT(32) COLLATE utf8_bin NULL,'+suffix;
            retStr += prefix+'`modSomethingTwo` INT(32) COLLATE utf8_bin NULL,'+suffix;
            retStr += prefix+'`modSomethingThree` INT(32) COLLATE utf8_bin NULL,'+suffix;

        } else if( field.name === 'modStatDetails' ) {
            //SPECIAL CASE FOR MOD STAT DETAILS - SPLIT INTO FOUR COLUMNS
            retStr += prefix+'`statId` INT(32) COLLATE utf8_bin NULL,'+suffix;
            retStr += prefix+'`statValue` BIGINT COLLATE utf8_bin NULL,'+suffix;

            fks += fks.length === 0 ? 'FOREIGN KEY (`statId`) REFERENCES `Stat`(`statId`)' : ', '+suffix+'FOREIGN KEY (`statId`) REFERENCES `Stat`(`statId`)';

        } else {
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
            
            let isFK = !!template.tables[field.name.charAt(0).toUpperCase()+field.name.substr(1,field.name.length-3)];
            let isTextKey = field.name.includes('Key');
            
            //IF FIELD IS FKEY, ADD TO LIST
            if( !!field.fkey ) {
                fks += fks.length === 0 ? 'FOREIGN KEY (`'+field.name+'`) REFERENCES '+field.fkey : ', '+suffix+'FOREIGN KEY (`'+field.name+'`) REFERENCES '+field.fkey;
            } else if( isFK && !field.pkey ) { 
                fks += fks.length === 0 ? 'FOREIGN KEY (`'+field.name+'`) REFERENCES `'+field.name.charAt(0).toUpperCase()+field.name.substr(1,field.name.length-3)+'`(`'+field.name+'`)' : ', '+suffix+'FOREIGN KEY (`'+field.name+'`) REFERENCES `'+field.name.charAt(0).toUpperCase()+field.name.substr(1,field.name.length-3)+'`(`'+field.name+'`)';            
            } else if( isTextKey && !field.pkey ) {
                //fks += fks.length === 0 ? 'FOREIGN KEY (`'+field.name+'`) REFERENCES `Localization`(`textKey`)' : ', '+suffix+'FOREIGN KEY (`'+field.name+'`) REFERENCES `Localization`(`textKey`)';
            }
        
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
            
            if( field.name === 'modDefinition' ) {
                //SPECIAL CASE FOR MOD DEFINITION - SPLIT INTO THREE COLUMNS
                fields += fields.length === 0 ? prefix+'`modSetId`' : ','+prefix+'`modSetId`';
                fields += fields.length === 0 ? prefix+'`modQuality`' : ','+prefix+'`modQuality`';
                fields += fields.length === 0 ? prefix+'`modSlot`' : ','+prefix+'`modSlot`';                
                
                values += values.length === 0 ? prefix+'`modSetId`=VALUES(`modSetId`)' : ','+prefix+'`modSetId`=VALUES(`modSetId`)';
                values += values.length === 0 ? prefix+'`modSetId`=VALUES(`modQuality`)' : ','+prefix+'`modQuality`=VALUES(`modQuality`)';
                values += values.length === 0 ? prefix+'`modSetId`=VALUES(`modSlot`)' : ','+prefix+'`modSlot`=VALUES(`modSlot`)';
                
            } else if( field.name === 'modStatDefinition' ) {
                //SPECIAL CASE FOR MOD STAT DEFINITION - SPLIT INTO FOUR COLUMNS
                fields += fields.length === 0 ? prefix+'`modStatType`' : ','+prefix+'`modStatType`';
                fields += fields.length === 0 ? prefix+'`modSomething`' : ','+prefix+'`modSomething`';
                fields += fields.length === 0 ? prefix+'`modSomethingTwo`' : ','+prefix+'`modSomethingTwo`';                
                fields += fields.length === 0 ? prefix+'`modSomethingThree`' : ','+prefix+'`modSomethingThree`';                
                
                values += values.length === 0 ? prefix+'`modStatType`=VALUES(`modStatType`)' : ','+prefix+'`modStatType`=VALUES(`modStatType`)';
                values += values.length === 0 ? prefix+'`modSomething`=VALUES(`modSomething`)' : ','+prefix+'`modSomething`=VALUES(`modSomething`)';
                values += values.length === 0 ? prefix+'`modSomethingTwo`=VALUES(`modSomethingTwo`)' : ','+prefix+'`modSomethingTwo`=VALUES(`modSomethingTwo`)';
                values += values.length === 0 ? prefix+'`modSomethingThree`=VALUES(`modSomethingThree`)' : ','+prefix+'`modSomethingThree`=VALUES(`modSomethingThree`)';
                
            } else {
                fields += fields.length === 0 ? prefix+'`'+field.name+'`' : ','+prefix+'`'+field.name+'`';        
                
                if( !field.pkey ) {
                    values += values.length === 0 ? prefix+'`'+field.name+'`=VALUES(`'+field.name+'`)' : ','+prefix+'`'+field.name+'`=VALUES(`'+field.name+'`)';                
                } else {
                    pks.push(field);
                }
            }            
        } else {
            
            if( field.name === 'modStatDetails' ) {
                //SPECIAL CASE FOR MOD STAT DETAILS - SPLIT INTO FOUR COLUMNS
                fields += fields.length === 0 ? prefix+'`statId`' : ','+prefix+'`statId`';                
                fields += fields.length === 0 ? prefix+'`statValue`' : ','+prefix+'`statValue`';                
                
                values += values.length === 0 ? prefix+'`statId`=VALUES(`statId`)' : ','+prefix+'`statId`=VALUES(`statId`)';
                values += values.length === 0 ? prefix+'`statValue`=VALUES(`statValue`)' : ','+prefix+'`statValue`=VALUES(`statValue`)';
                
            }
 
        }
                
    }
    //CLOSE INSERT STATEMENT
    retStr += suffix+fields+prefix+suffix+') VALUES ?';
    
    if( pks.length > 0 ) {
        retStr += suffix+' ON DUPLICATE KEY UPDATE'+suffix+values;
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
    output += '         let result = null;\n';
    output += '         let ofkey = !!fkey ? Object.assign({},fkey) : null;\n';
    output += '         fkey = null;\n\n';         
    output += '         let payload = {};\n';
    output += '             payload["verbose"] = true;\n\n';
        
    //Prepare data for insert
    output += '         collection[depth] = collection[depth] || {};\n';
    output += '         collection[depth][key] = collection[depth][key] || [];\n\n';
    output += '         for( let i = 0; i < data.length; ++i ) {\n\n';
    output += '             let inner = [];\n\n';
    
    //IF FOREIGN KEY WAS PASSED, SET IT BEFORE PUSHING OBJECT
    output += '             if( !!ofkey ) {\n';
    output += '                 let fk = Object.keys(ofkey)[0];\n';
    output += '                 data[i][fk] = ofkey[fk];\n';
    output += '             }\n\n';    

    let required = [];

    for( let f in obj.fields ) { 
        let field = obj.fields[f];
        if( field.type === "INT" || field.type === "BIGINT" || field.type === "VARCHAR" || field.type === "BOOLEAN" || field.type === "TIMESTAMP" || field.type === "TEXT" ) {
            if( field.name === 'lastUpdated' ) { 
                output += `             inner.push(moment(Date.now()).format('YYYY-MM-DD HH:mm:ss'));\n\n`; 
            } else {
                if( field.type === "TEXT" ) {
                    output += `             if( !data[i].${field.name}Map ) {\n`;
                    output += `                 inner.push(await JSON.stringify(data[i].${field.name}));\n`;
                    output += `             } else {\n`;
                    output += `                 inner.push(await JSON.stringify(data[i].${field.name}Map));\n`;
                    output += `             }\n\n`;
                } else {
                    if( field.name === 'modDefinition' ) {
                        output += `             let [ modSetId, modQuality, modSlot ] = data[i].${field.name}.split('');\n`; 
                        output += `             inner.push(modSetId);\n`;
                        output += `             inner.push(modQuality);\n`;
                        output += `             inner.push(modSlot);\n\n`;
                    } else if( field.name === 'modStatDefinition' ) {
                        output += `             let [ modStatType, modSomething, modSomethingTwo, modSomethingThree ] = data[i].${field.name}.split('');\n`; 
                        output += `             inner.push(modStatType);\n`;
                        output += `             inner.push(modSomething);\n`;
                        output += `             inner.push(modSomethingTwo);\n`;
                        output += `             inner.push(modSomethingThree);\n\n`;
                    } else if( field.name === 'modStatDetails' ) {
                        output += `             inner.push(data[i].${field.name}.statId);\n`;
                        output += `             inner.push(data[i].${field.name}.statValue);\n\n`;

                    } else {
                        output += `             inner.push(data[i].${field.name});\n\n`;
                    }
                }
                                
                if( field.pkey ) {                    
                    output += `             //Cascade this table's primary key to child's foreign key\n`;
                    output += `             fkey = {};\n`;
                    output += `             fkey["${field.name}"] = data[i].${field.name};\n\n`;
                }

                if( !field.pkey && field.name === 'playerUnitModId' ) {                    
                    output += `             //Cascade playerUnitModId key to stats\n`;
                    output += `             fkey = {};\n`;
                    output += `             fkey["${field.name}"] = data[i].${field.name};\n\n`;
                }
                
            }
        } else if( f !== 'undefined' ) {
            
            if( field.name === 'modStatDetails' ) {
                output += `             inner.push(data[i].${field.name}.statId);\n`;
                output += `             inner.push(data[i].${field.name}.statValue);\n\n`;

            } else {
                if( !required.includes(field.type) ) {
                    //output += `             console.log('${field.type}');\n`;
                    output += `             const Sql${field.type} = require('./sql.${field.type}.js');\n\n`;
                    required.push(field.type);
                }
                output += `             if( typeof data[i].${field.name} !== "undefined" ) {\n`;            
                output += `                 collection = await new Sql${field.type}(payload).bubble(data[i].${field.name}, collection, '${field.type}', depth+1, fkey);\n`;
                output += `             }\n\n`;
            }
            
        }
        
    }
        
    output += '             collection[depth][key].push(inner);\n\n';
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
                if( fname.includes('undefined') || fname.includes('unknown') || fname.includes('empty') ) { continue; }
                
                //TRANSPOSE NAME FROM UNDERSCORES TO CAMEL-HUMP NOTATION
                let tmpname = fname.split(/_/g);
                for( let n = 1; n < tmpname.length; ++n ) {
                    tmpname[n] = tmpname[n].charAt(0).toUpperCase() + tmpname[n].slice(1);                    
                }
                fname = tmpname.join('');
                
                if( fname === '' ) {
                    
                } else {

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
                    
                    let fcomp = fname.charAt(0).toUpperCase()+fname.substr(1,fname.length-3);
                    field.pkey = tname === fcomp ? true : false;
                    field.condition = tname === fcomp ? "NOT NULL" : "NULL";
                    
                    //IF FIELD IS A PRIMARY KEY, TRACK IT
                    if( field.pkey ) { pks.push(fname); }                
                    
                    //IF FIELD TYPE IS ANOTHER TABLE, ADD REFERENCE
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
                
                if( t === 'GameData' ) { continue; }
                
                let field = template.tables[t].fields[f];
                if( field.ref ) {
                    //IF ref EXISTS, MAP ALL THE PRIMARY AND FOREIGN KEYS
                    field.ref.ptable.keys = template.tables[t].pks;
                    field.ref.ftable.keys = template.tables[field.ref.ftable.name] ? template.tables[field.ref.ftable.name].pks : [];
                }
                 
                if( field.ref && field.ref.ptable.name.length > 0 ) {
                    
                    let newField = Object.assign({},template.tables[t].fields[field.ref.ptable.keys[0]]);
                    if( !newField.name ) { continue; }
                    
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