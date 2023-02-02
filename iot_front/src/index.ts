
import {connection, IBinaryMessage, IUtf8Message, server as WebSocketServer} from 'websocket';
import {config} from './conf';
import http from 'http';
import url from 'url';
import {Kafka} from 'kafkajs';
import Base64 from 'js-base64' ;
import {v4 as uuidv4} from 'uuid' ;
import { auth,logout } from './hook/auth';



var log4js = require("log4js");
var logger = log4js.getLogger("iot_font");
logger.level = config.log_level;



//全局client 缓存
const userMap = new Map<string, connection>();
const deviceMap = new Map<string, connection>();

//未授权client
var noAllowMap={};


var server = http.createServer(function(request, response) {
    
    //白名单校验
    
    let isWhiteList = config.http_ip_whitelist.includes(request.socket.remoteAddress||'');
    if(!isWhiteList){
        console.log((new Date()) + ' Received request for ' + request.url);
        response.writeHead(404);
        response.end();
    }else{
      var data = url.parse(request.url||'',true).query ;
      
      
      //id 是否存在
      if( typeof data.userId === 'string'){
        if(userMap.get(data.userId)==null){
          response.writeHead(200);
          let res = {
              reCode:1,
              reDesc:"device not found"
          }
          response.end(JSON.stringify(res));  

          return ;
        }else{
          if( typeof data.data === 'string'){
            let nu8s = Base64.toUint8Array(data.data);

            userMap.get(data.userId)?.sendBytes(Buffer.from(nu8s));
            response.end(JSON.stringify({
              reCode:0,
              reDesc:"success"
            }));
          }
        } 
        }

           
      }
    });

const kafka = new Kafka({
    clientId: config.kafkaClientId,
    brokers: ['localhost:9092'],
});

const producer = kafka.producer() ;


server.listen(config.listen_port, async function() {
    logger.info( ' Server is listening on port '+config.listen_port);
    await producer.connect();
});

const wsServer = new WebSocketServer({
    httpServer: server,
    // You should not use autoAcceptConnections for production
    // applications, as it defeats all standard cross-origin protection
    // facilities built into the protocol and the browser.  You should
    // *always* verify the connection's origin and decide whether or not
    // to accept it.
    autoAcceptConnections: false
});





function originIsAllowed(_origin: IUtf8Message | IBinaryMessage,onAuthPassed : Function) {
    // put logic here to detect whether the specified origin is allowed.

    return auth(_origin,onAuthPassed) ;

}

//////redis////


//////redis end////
// const reviceDeviceMessage = async (message: IBinaryMessage) => {

// }

// const reviceUserMessage = async (message: IUtf8Message) => {
// }

const reviceServiceMessage = async (message: IUtf8Message) => {
    const dataStr = message.utf8Data;
    if(dataStr!=null){
        const data = JSON.parse(dataStr);
        const id = data.id;
        const type = data.type;
        if(type=='device'){
            if(deviceMap.get(id)!=null){
                deviceMap.get(id)?.sendBytes(Buffer.from(data.data.data));
            }else{
                logger.warn("device("+id+") not found");
            }
        }else if(type=='user'){
            if(userMap.get(id)!=null){
                userMap.get(id)?.sendBytes(Buffer.from(data.data.data));
            }else {
                logger.warn("user("+id+") not found");
            }
        }
    }
}




  
wsServer.on('request', function(request) {

      if(request.requestedProtocols==null 
        || request.requestedProtocols.length==0 
        ||request.requestedProtocols[0]!='echo-protocol'){
          console.log((new Date()) + ' Peer  is reject');
          request.reject();
          return ;
      }
      console.log((new Date()) + ' Peer  is accept');
      var connection = request.accept('echo-protocol');
      var isAllow = false ;
      // var authInfo = JSON.parse(request.origin) ;
      var id = '';
      var type = '';
      
      const onAuthPassed = (type2:string,id2:string)=>{
        id = id2 ;
        type = type2 ;
        logger.info("auth passed:"+type2+"-"+id2);
        if(type=='user'){
          userMap.set(id,connection);

        }else if(type=='device'){
          deviceMap.set(id,connection);
        }

      }  



      connection.on('message',async function(message) {
          
          if (message.type === 'utf8') {
            logger.info('Received Message('+connection.remoteAddress+'): ' + message.utf8Data);
            if(!isAllow){
              if(!await originIsAllowed(message,onAuthPassed)){
                console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' is no allow');
                connection.close();
              }else{
                console.log(message);
                let deviceInfo = JSON.parse(message.utf8Data);
               
                isAllow = true ;
                userMap.set(deviceInfo.id ,connection);
                // clientMap[deviceInfo.id] =  connection ;
              }
              return ;
            }
            
            if(type=='service'){
              reviceServiceMessage(message);
            }
            
          }else if (message.type === 'binary') {
            logger.info('Received Message('+connection.remoteAddress+'|'+type+'|'+id+'): ' +JSON.stringify(message.binaryData.toJSON()));
            
            if(!isAllow){
              //兼容bin 校验
              let allow =await originIsAllowed(message,onAuthPassed);
              if(!allow){
                console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' is no allow');
                connection.close();
              }else{  
                
                let deviceInfo : any = message.binaryData.toJSON() ;
                deviceInfo.type = 'LOGIN';
                deviceInfo.login_ip = connection.remoteAddress ;
                producer.send({
                  topic: 'm2m',
                      messages: [
                          {value:JSON.stringify(deviceInfo)
                          }
                      ],
                  }) ;
                //向kafka 发送 登入消息
                isAllow = true ;
                // clientMap[deviceInfo.id] =  connection ;
              }
              return ;
            }

            //   var requestData = Uint8Array.from(message.binaryData) ;
            let m2mDataJson : any ={
             
              data:message.binaryData.toJSON()
              } ;

             
              m2mDataJson['id'] = id ;
              m2mDataJson['type'] = type ;
             
              producer.send({
                topic: 'm2m',
                    messages: [
                        {value:JSON.stringify(m2mDataJson)
                        }
                    ],
                }) ;
             
          }
      });

      connection.on('ping',function(){
        // console.log("ping........");
      });
      connection.on('close', function(reasonCode, description) {
        logger.info(id+" is closed");
        logout(id,type);
        if(type=='user'){
          userMap.delete(id);
        }else if(type=='device'){
          deviceMap.delete(id);
        }
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
      });
  });
