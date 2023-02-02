"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.logout = exports.auth = void 0;
const node_appwrite_1 = require("node-appwrite");
const md5_1 = __importDefault(require("md5"));
const conf_1 = require("../conf");
const redis_1 = require("redis");
const client = new node_appwrite_1.Client();
client
    .setEndpoint(conf_1.config.APPWRITE_URL) // Your API Endpoint
    .setProject(conf_1.config.APPWRITE_PROJECT_ID) // Your project ID
    .setKey(conf_1.config.API_SECRET_KEY);
const users = new node_appwrite_1.Users(client);
const databases = new node_appwrite_1.Databases(client, conf_1.config.OSS_DATABASE_ID);
const redisClient = (0, redis_1.createClient)({ url: 'redis://localhost:6379' });
redisClient.on('error', (err) => console.log('Redis Client Error', err));
redisClient.connect();
// const setRedisValue = async (key:string,value:string) => {
//     return new Promise((resolve, reject) => {
//         redisClient.set(key, value);
//     });
// }
const device_auth = (origin, onAuthFinish) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    const dataBuffer = origin.binaryData;
    console.log("dataBuffer=========");
    if (dataBuffer != null) {
        //  let hexStr = dataBuffer.toString('hex').match(/../g);
        console.log((_a = dataBuffer.toString('hex').match(/../g)) === null || _a === void 0 ? void 0 : _a.join(' '));
    }
    // dataStr = dataBuffer.toString() ;
    //databuffer to uint8array
    const dataUint8Array = new Uint8Array(dataBuffer);
    if (dataUint8Array.length != 65) {
        console.log("dataUint8Array.length != 65, return false");
        return false;
    }
    //status [0]
    const status = dataUint8Array[0];
    //uid 8byte
    const uid = dataUint8Array.slice(1, 9);
    //uid to hex string
    const uidStr = uid.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');
    //id 8byte
    const id = dataUint8Array.slice(9, 17);
    //id to hex string
    const idStr = id.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');
    //serials 4byte
    const serials = dataUint8Array.slice(17, 21);
    //serials to numeric
    const serialsNum = serials.reduce((num, byte) => num * 256 + byte, 0);
    //oper_count 4byte
    const oper_count = dataUint8Array.slice(21, 25);
    //oper_count to numeric
    const oper_countNum = oper_count.reduce((num, byte) => num * 256 + byte, 0);
    //random 8byte
    const randstr = dataUint8Array.slice(25, 33);
    //sk 16byte
    const sk = dataUint8Array.slice(33, 49);
    //md5 16byte
    const md5value = dataUint8Array.slice(49, 65);
    //md5 to hex string
    const md5Str = md5value.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');
    //get device info from oss
    const list = yield databases.listDocuments(conf_1.config.OSS_UNIQUE_DEVICES_COLLECTION_ID, [
        node_appwrite_1.Query.equal('uid', uidStr)
    ]);
    if (list.documents.length == 0) {
        console.log("list.documents.length==0, return false");
        return false;
    }
    const device = list.documents[0];
    const device_sk = device.sk;
    const device_status = device.status;
    if (device_status !== 0) {
        console.log("device_status!==0, return false");
        return false;
    }
    //device sk hex string to uint8array
    const device_skUint8Array = new Uint8Array(device_sk.match(/.{1,2}/g).map(byte => parseInt(byte, 16)));
    //complate sk
    let nbuffer = dataUint8Array.slice(0, 49);
    //set sk
    nbuffer.set(device_skUint8Array, 33);
    //calculate md5
    const newMd5 = (0, md5_1.default)(nbuffer);
    //newUint8Array to hex string
    // const newMd5Str = newMd5.match(/.{1,2}/g)!.map(byte => parseInt(byte, 16)).reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');
    // console.log(dataBuffer.toString('hex').match(/../g)?.join(' '));
    // console.log("nbuffer:::"+Buffer.from(nbuffer).toString('hex').match(/../g)?.join(' '));
    // console.log("esp md5:::"+md5Str);
    // console.log("cal md5:::"+newMd5);
    if (newMd5 != md5Str) {
        console.log("newMd5!=md5Str, return false");
        return false;
    }
    if (status == 1) {
        //set new device id
        const update = yield databases.updateDocument(conf_1.config.OSS_UNIQUE_DEVICES_COLLECTION_ID, device.$id, {
            device_id: idStr
        });
    }
    //get device bind user
    const list2 = yield databases.listDocuments(conf_1.config.OSS_USER_DEVICE_COLLECTION_ID, [
        node_appwrite_1.Query.equal('device_id', idStr)
    ]);
    for (const doc2 of list2.documents) {
        //save to redis
        const key = "device_" + idStr;
        let doc3 = doc2;
        const value = doc3.owner_user_id;
        redisClient.set(key, value);
    }
    onAuthFinish('device', idStr);
    return true;
});
const app_auth = (origin, onAuthFinish) => __awaiter(void 0, void 0, void 0, function* () {
    const dataStr = origin.utf8Data;
    console.log("dataStr=========");
    console.log(dataStr);
    if (dataStr != null) {
        const data = JSON.parse(dataStr);
        const user_id = data.user_id;
        //user normal check
        if (data.user_id != null && '' !== data.user_id) {
            //user
            let user_id = data.user_id;
            let session_id = data.session_id;
            const list = yield users.getSessions(user_id);
            for (var i = 0; i < list.sessions.length; i++) {
                const session = list.sessions[i];
                if (session.$id == session_id) {
                    //get user devie list from oss
                    const list = yield databases.listDocuments(conf_1.config.OSS_USER_DEVICE_COLLECTION_ID, [
                        node_appwrite_1.Query.equal('owner_user_id', user_id)
                    ]);
                    for (var j = 0; j < list.documents.length; j++) {
                        var docs = list.documents[j];
                    }
                    //get user device list from appwrite
                    const list2 = yield databases.listDocuments(conf_1.config.OSS_USER_DEVICE_COLLECTION_ID, [
                        node_appwrite_1.Query.equal('owner_user_id', user_id)
                    ]);
                    //save to redis
                    var deviceList = [];
                    for (var j = 0; j < list2.documents.length; j++) {
                        var docs = list2.documents[j];
                        var device_id = docs.device_id;
                        deviceList.push(device_id);
                    }
                    const key = "user_" + user_id;
                    const value = JSON.stringify(deviceList);
                    redisClient.set(key, value);
                    onAuthFinish('user', user_id);
                    return true;
                }
            }
        }
    }
    return false;
});
const service_auth = (origin, onAuthFinish) => __awaiter(void 0, void 0, void 0, function* () {
    const dataStr = origin.utf8Data;
    console.log("dataStr=========");
    console.log(dataStr);
    if (dataStr != null) {
        const data = JSON.parse(dataStr);
        const auth = data.auth;
        if (auth == 'iotTaskAuth_111213181930') {
            onAuthFinish('service', 'iotTaskAuth_111213181930');
            return true;
        }
    }
    return false;
});
/**
 * 登入校验
 * @param {*} origin
 * @returns
 */
const auth = (origin, onAuthFinish) => __awaiter(void 0, void 0, void 0, function* () {
    if (origin.type == 'utf8') {
        const dataStr = origin.utf8Data;
        if (dataStr != null) {
            const data = JSON.parse(dataStr);
            if (data.type == 'service') {
                return yield service_auth(origin, onAuthFinish);
            }
            else {
                return yield app_auth(origin, onAuthFinish);
            }
        }
    }
    //esp connect
    if (origin.type == 'binary') {
        return device_auth(origin, onAuthFinish);
    }
    return false;
});
exports.auth = auth;
const logout = (id, type) => __awaiter(void 0, void 0, void 0, function* () {
    if (type == 'DEVICE') {
        //delete redis device info
        yield redisClient.del("device_" + id);
    }
    if (type == 'user') {
        //delete redis user info
        yield redisClient.del("user_" + id);
    }
    return true;
});
exports.logout = logout;
//# sourceMappingURL=auth.js.map