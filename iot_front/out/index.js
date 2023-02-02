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
const websocket_1 = require("websocket");
const conf_1 = require("./conf");
const http_1 = __importDefault(require("http"));
const url_1 = __importDefault(require("url"));
const kafkajs_1 = require("kafkajs");
const js_base64_1 = __importDefault(require("js-base64"));
const auth_1 = require("./hook/auth");
var log4js = require("log4js");
var logger = log4js.getLogger("iot_font");
logger.level = conf_1.config.log_level;
//全局client 缓存
const userMap = new Map();
const deviceMap = new Map();
//未授权client
var noAllowMap = {};
var server = http_1.default.createServer(function (request, response) {
    //白名单校验
    var _a;
    let isWhiteList = conf_1.config.http_ip_whitelist.includes(request.socket.remoteAddress || '');
    if (!isWhiteList) {
        console.log((new Date()) + ' Received request for ' + request.url);
        response.writeHead(404);
        response.end();
    }
    else {
        var data = url_1.default.parse(request.url || '', true).query;
        //id 是否存在
        if (typeof data.userId === 'string') {
            if (userMap.get(data.userId) == null) {
                response.writeHead(200);
                let res = {
                    reCode: 1,
                    reDesc: "device not found"
                };
                response.end(JSON.stringify(res));
                return;
            }
            else {
                if (typeof data.data === 'string') {
                    let nu8s = js_base64_1.default.toUint8Array(data.data);
                    (_a = userMap.get(data.userId)) === null || _a === void 0 ? void 0 : _a.sendBytes(Buffer.from(nu8s));
                    response.end(JSON.stringify({
                        reCode: 0,
                        reDesc: "success"
                    }));
                }
            }
        }
    }
});
const kafka = new kafkajs_1.Kafka({
    clientId: conf_1.config.kafkaClientId,
    brokers: ['localhost:9092'],
});
const producer = kafka.producer();
server.listen(conf_1.config.listen_port, function () {
    return __awaiter(this, void 0, void 0, function* () {
        logger.info(' Server is listening on port ' + conf_1.config.listen_port);
        yield producer.connect();
    });
});
const wsServer = new websocket_1.server({
    httpServer: server,
    // You should not use autoAcceptConnections for production
    // applications, as it defeats all standard cross-origin protection
    // facilities built into the protocol and the browser.  You should
    // *always* verify the connection's origin and decide whether or not
    // to accept it.
    autoAcceptConnections: false
});
function originIsAllowed(_origin, onAuthPassed) {
    // put logic here to detect whether the specified origin is allowed.
    return (0, auth_1.auth)(_origin, onAuthPassed);
}
//////redis////
//////redis end////
// const reviceDeviceMessage = async (message: IBinaryMessage) => {
// }
// const reviceUserMessage = async (message: IUtf8Message) => {
// }
const reviceServiceMessage = (message) => __awaiter(void 0, void 0, void 0, function* () {
    var _a, _b;
    const dataStr = message.utf8Data;
    if (dataStr != null) {
        const data = JSON.parse(dataStr);
        const id = data.id;
        const type = data.type;
        if (type == 'device') {
            if (deviceMap.get(id) != null) {
                (_a = deviceMap.get(id)) === null || _a === void 0 ? void 0 : _a.sendBytes(Buffer.from(data.data.data));
            }
            else {
                logger.warn("device(" + id + ") not found");
            }
        }
        else if (type == 'user') {
            if (userMap.get(id) != null) {
                (_b = userMap.get(id)) === null || _b === void 0 ? void 0 : _b.sendBytes(Buffer.from(data.data.data));
            }
            else {
                logger.warn("user(" + id + ") not found");
            }
        }
    }
});
wsServer.on('request', function (request) {
    if (request.requestedProtocols == null
        || request.requestedProtocols.length == 0
        || request.requestedProtocols[0] != 'echo-protocol') {
        console.log((new Date()) + ' Peer  is reject');
        request.reject();
        return;
    }
    console.log((new Date()) + ' Peer  is accept');
    var connection = request.accept('echo-protocol');
    var isAllow = false;
    // var authInfo = JSON.parse(request.origin) ;
    var id = '';
    var type = '';
    const onAuthPassed = (type2, id2) => {
        id = id2;
        type = type2;
        logger.info("auth passed:" + type2 + "-" + id2);
        if (type == 'user') {
            userMap.set(id, connection);
        }
        else if (type == 'device') {
            deviceMap.set(id, connection);
        }
    };
    connection.on('message', function (message) {
        return __awaiter(this, void 0, void 0, function* () {
            if (message.type === 'utf8') {
                logger.info('Received Message(' + connection.remoteAddress + '): ' + message.utf8Data);
                if (!isAllow) {
                    if (!(yield originIsAllowed(message, onAuthPassed))) {
                        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' is no allow');
                        connection.close();
                    }
                    else {
                        console.log(message);
                        let deviceInfo = JSON.parse(message.utf8Data);
                        isAllow = true;
                        userMap.set(deviceInfo.id, connection);
                        // clientMap[deviceInfo.id] =  connection ;
                    }
                    return;
                }
                if (type == 'service') {
                    reviceServiceMessage(message);
                }
            }
            else if (message.type === 'binary') {
                logger.info('Received Message(' + connection.remoteAddress + '|' + type + '|' + id + '): ' + JSON.stringify(message.binaryData.toJSON()));
                if (!isAllow) {
                    //兼容bin 校验
                    let allow = yield originIsAllowed(message, onAuthPassed);
                    if (!allow) {
                        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' is no allow');
                        connection.close();
                    }
                    else {
                        let deviceInfo = message.binaryData.toJSON();
                        deviceInfo.type = 'LOGIN';
                        deviceInfo.login_ip = connection.remoteAddress;
                        producer.send({
                            topic: 'm2m',
                            messages: [
                                { value: JSON.stringify(deviceInfo)
                                }
                            ],
                        });
                        //向kafka 发送 登入消息
                        isAllow = true;
                        // clientMap[deviceInfo.id] =  connection ;
                    }
                    return;
                }
                //   var requestData = Uint8Array.from(message.binaryData) ;
                let m2mDataJson = {
                    data: message.binaryData.toJSON()
                };
                m2mDataJson['id'] = id;
                m2mDataJson['type'] = type;
                producer.send({
                    topic: 'm2m',
                    messages: [
                        { value: JSON.stringify(m2mDataJson)
                        }
                    ],
                });
            }
        });
    });
    connection.on('ping', function () {
        // console.log("ping........");
    });
    connection.on('close', function (reasonCode, description) {
        logger.info(id + " is closed");
        (0, auth_1.logout)(id, type);
        if (type == 'user') {
            userMap.delete(id);
        }
        else if (type == 'device') {
            deviceMap.delete(id);
        }
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});
//# sourceMappingURL=index.js.map