#!/usr/bin/env node
var WebSocketClient = require('websocket').client;
var md5 = require('md5');
var client = new WebSocketClient();

const sk = 'ssssssskkkkkkkkksssssssssskkkkkkkkk';

client.on('connectFailed', function(error) {
    console.log('Connect Error: ' + error.toString());
});

client.on('connect', function(connection) {
    console.log('WebSocket Client Connected');
    connection.on('error', function(error) {
        console.log("Connection Error: " + error.toString());
    });
    connection.on('close', function() {
        console.log('echo-protocol Connection Closed');
    });
    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            console.log("Received: '" + message.utf8Data + "'");
        }
        if (message.type === 'binary') {
            console.log(' Binary Message: ' + message.binaryData);
            console.log(message.binaryData);
        }
    });
    let allowJson ={
        id:1,
        randstr:'randstrrandstr',
        serials:10,
        oper_count:1,
   
        
    };
    let str = ''+allowJson['id']+sk+allowJson['randstr']+allowJson['serials']+allowJson['oper_count'];
    allowJson['md5'] = md5(str)
    //发送鉴权信息
    var allow = JSON.stringify(allowJson);
    connection.sendBytes(Buffer.from(allow));
    function sendNumber() {
        if (connection.connected) {
            var number = Math.round(Math.random() * 0xFFFFFF);
            let data = "client2"+number.toString()
            // connection.sendUTF(number.toString());
            console.log("send:::"+data);
            connection.sendBytes(Buffer.from(data));
            setTimeout(sendNumber, 3000);
        }
    }
    setTimeout(sendNumber,10000);
});


client.connect('ws://127.0.0.1:8082/', 'echo-protocol');

