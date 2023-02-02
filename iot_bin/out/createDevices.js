"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const common_1 = require("./common");
const conf_1 = require("./conf");
const uuid_1 = require("uuid");
var { program } = require('commander');
program
    .name('mt-create')
    .argument('<count>', 'user to login');
program.parse();
let model = program.args[0];
let count = Number(program.args[1]);
//23 2A 00 FF 
// UID(7B) ID(7B) SK(14B)
//2A 23
for (let i = 0; i < count; i++) {
    let _id = (0, uuid_1.v4)();
    let id = Math.floor(Math.random() * 72057594037927935);
    let uid = Math.floor(Math.random() * 72057594037927935);
    let ser1 = Math.floor(Math.random() * 72057594037927935);
    let ser2 = Math.floor(Math.random() * 72057594037927935);
    let serStr = ser1.toString(16) + ser2.toString(16);
    let command = '232a00ff';
    command = command
        + uid.toString(16)
        + id.toString(16)
        + ser1.toString(16)
        + ser2.toString(16)
        + '2a23';
    console.log(command);
    //insert uni
    common_1.ossDatabases.createDocument(conf_1.config.OSS_UNIQUE_DEVICE_COLLETION_ID, _id, {
        uid: uid,
        id: id,
        sk: serStr,
        product_mode: model
    });
    _id = (0, uuid_1.v4)();
    //insert device
    common_1.ossDatabases.createDocument(conf_1.config.OSS_DEVICE_COLLETION_ID, _id, {
        uid: uid,
        id: id,
        sk: serStr,
        status: 0
    });
}
//# sourceMappingURL=createDevices.js.map