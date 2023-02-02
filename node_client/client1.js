#!/usr/bin/env node
var WebSocketClient = require('websocket').client;

var client = new WebSocketClient();

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

    //发送鉴权信息
    var allow = JSON.stringify({
            id:1,
            pk:"xxxxx",
            sk:"yyyyy"
        
    });
    connection.sendUTF(allow);
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
    sendNumber();
});

// function(requestUrl, protocols, origin, headers, extraRequestOptions) 
// client.connect('ws://ankemao.com:8082/', 'echo-protocol',JSON.stringify({
// client.connect('ws://127.0.0.1:8082/', 'echo-protocol',JSON.stringify({
//     id:1,
//     pk:"xxxxx",
//     sk:"yyyyy"

// }));

client.connect('ws://ankemao.com:8082/', 'echo-protocol');

