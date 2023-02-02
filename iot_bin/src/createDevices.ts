import {ossDatabases} from './common';
import { config } from './conf';
import { v4 as uuidv4 } from 'uuid';

var { program } = require('commander');

program
    .name('mt-create')
    .argument('<count>', 'user to login')
program.parse();

let model = program.args[0];
let name = program.args[1];
let count = Number(program.args[2]);

console.log('model: ' + model);


//23 2A 00 FF 
// UID(7B) ID(7B) SK(14B)
//2A 23
for(let i=0;i<count;i++){
    let _id = uuidv4();
    let id = Math.floor(Math.random() * 72057594037927935);


    let uid = Math.floor(Math.random() * 72057594037927935);
    let ser1 = Math.floor(Math.random() * 72057594037927935);
    let ser2 = Math.floor(Math.random() * 72057594037927935);
    let serStr = ser1.toString(16)+ser2.toString(16);
    let command = '232a00ff';
    command = command
        +uid.toString(16)
        +id.toString(16)
        +ser1.toString(16)
        +ser2.toString(16)
        +'2a23' ;
    
    console.log(command);
    //insert uni
    ossDatabases.createDocument(
    config.OSS_UNIQUE_DEVICE_COLLETION_ID, 
    _id, 
    {
        uid:uid,
        id:id,
        sk:serStr,
        product_mode:model,
        name:name,

    });

    _id = uuidv4();
    //insert device
    ossDatabases.createDocument(
        config.OSS_DEVICE_COLLETION_ID, 
        _id, 
        {
            uid:uid,
            id:id,
            sk:serStr,
            status:0,

    
        });


}


