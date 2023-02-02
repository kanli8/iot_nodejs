/**
 * 没有走redis,不能知道设备是否在线，
 * 没有记录log 到mysql
 */
 import {Kafka} from 'kafkajs';
 import fetch from 'node-fetch';
 import mysql from 'mysql';
 import { createClient } from 'redis';
 import {Client, Users,Databases,Query } from 'node-appwrite' ;
import { config } from './conf';
import { DeviceFamily } from './model';
import {client as WebSocketClient} from 'websocket';

 const kafka = new Kafka({
   clientId: 'my-app-customer',
   brokers: ['localhost:9092'],
 })
 
 const consumer = kafka.consumer({ groupId: 'iot_customer' })
 
 const mysqlConnection = mysql.createConnection({
    host     : 'localhost',
    port     : 3306,
    user     : 'iot',
    password : 'iotiot',
    database : 'iot'
  });
  var wsclient = new WebSocketClient();

  const redisClient = createClient({
    url: 'redis://localhost:6379'
    });

  redisClient.on('error', 
    (err: any) => console.log('Redis Client Error', err)
    );


const appClient = new Client();

appClient
    .setEndpoint(config.APPWRITE_URL) // Your API Endpoint
    .setProject(config.APPWRITE_PROJECT_ID) // Your project ID
    .setKey(config.API_SECRET_KEY) ;

const users = new Users(appClient);
const ossDatabases = new Databases(appClient, config.OSS_DATABASE_ID);
const bssDatabases = new Databases(appClient, config.BSS_DATABASE_ID);

 
 async function sendDataToFont(deviceId: number , data: string,userId:string ){
    //use websocket


 }

 //device auth
 async function deviceLogin(msgJson:any)  {
    //
    mysqlConnection.query(
        'insert into logs_devices_auth (device_id,randstr,serials,oper_count,md5,login_ip) values(?,?,?,?,?,?)',
        [msgJson.id,msgJson.randstr,msgJson.serials,msgJson.oper_count,msgJson.md5,msgJson.login_ip],
        (error, results, fields)=>{
            if (error){
                console.error('deviceAuth..insert mysql error');
                console.error(msgJson);
            }
        }
    );

    const deviceFamilyList =await bssDatabases.listDocuments(config.BSS_DEVICE_FAMILY_COLLETION_ID,
        [
            Query.equal('device_id',msgJson.id)
        ]);
       
        for(var i=0; i< deviceFamilyList.documents.length; i++){
            const document :any = deviceFamilyList.documents[i];
            await redisClient.HSET(config.REDIS_DEVICE_FAMILY_KEY, msgJson.id, document.family_id);
            const family = await redisClient.HGET(config.REDIS_FAMILY_KEY,document.family_id);
            if(family==undefined || family===null || ''===family){
                //insert family
                const familyDoc : any =await bssDatabases.getDocument(config.BSS_FAMILY_COLLETION_ID,document.family_id) ;
                let fid = familyDoc.$id ;
                redisClient.HSET(config.REDIS_FAMILY_KEY,document.family_id,);
                //TODO 
                
            }

        }
    


 }



 //user auth
 function userLogin (msgJson:any){
    mysqlConnection.query(
        'insert into logs_user_auth (user_id,session_id,login_ip) values(?,?,?)',
        [msgJson.user_id,msgJson.session_id,msgJson.login_ip],
        (error, results, fields)=>{
            if (error){
                console.error('userAuth..insert mysql error');
                console.error(msgJson);
            }
        }
    ) ;

}

var connection: any;
function sendDataToWS(data:string) {
    if (connection.connected) {
        console.log("send:::"+data);
        connection.sendUTF(data);

    }
}

 //device msg
 async function deviceMsg(msgJson:any){
    var id:string = msgJson.id;
    //获取设备绑定的用户
    const user_id = await redisClient.get('device_'+id);
    if(user_id==undefined || user_id===null || ''===user_id){
        console.log('device_'+id+' not bind user');
        return;
    }

    //assemble byte msg
    var msg = new Uint8Array(12+msgJson.data.data.length);
    msg[0] = 0x50;
    msg[1] = 0x01
    //set device id
    //id hex string to byte array
    var idArray = new Uint8Array(8);
    for(var i=0;i<8;i++){
        idArray[i] = parseInt(id.substring(i*2,i*2+2),16);
    }
    msg.set(idArray,2);

    //set data
    msg.set(msgJson.data.data,10);

    //calc crc
    var crc = 0;
    for(var i=0;i<msg.length-2;i++){
        crc += msg[i];
    }
    msg[msg.length-2] = crc & 0xff;
    msg[msg.length-1] = 0x4c;

    //send to websocket
    var sendmsgJson : any = {}
    sendmsgJson['id'] = user_id;
    sendmsgJson['data'] = Buffer.from(msg).toJSON();
    sendmsgJson['type'] = 'user';
    sendDataToWS(JSON.stringify(sendmsgJson));



}

 //user msg
 async function userMsg(msgJson:any){
    var id = msgJson.id;
    var data = msgJson.data;
    //json to byte
    var dataByte = Uint8Array.from(Buffer.from(data.data));
    //get to device id from databyte
    var deviceId : Uint8Array = dataByte.slice(2,10);
    //device id to hex string
    const deviceIdStr = deviceId.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');
    //check device is online and device bind user from redis
    const user_id = await redisClient.get('device_'+deviceIdStr);
    if(user_id==undefined || user_id===null || ''===user_id||user_id!=id){
        console.error('device('+deviceIdStr+') is not bind user or device is offline');
        //TODO send msg to user

        return;
    }
    var sendBytes = dataByte.slice(10,dataByte.length-2);
    //send to device
    Buffer.from(sendBytes).toJSON();

    let sendJson : any ={
        type: 'device', 
        id: deviceIdStr,   
        data:Buffer.from(sendBytes).toJSON()
    } ;
    sendDataToWS(JSON.stringify(sendJson));





    

}



//
async function deviceLogout(msgJson:any)  {
    //更新redis 数据库
    //更新appwirte状态，通知关联用户

}

async function userLogout(msgJson:any)  {

}




async function start_websocket() {
    
    wsclient.on('connectFailed', function(error) {
        console.log('Connect Error: ' + error.toString());
    });

    wsclient.on('connect', function(connection2) {
        connection = connection2;
        console.log('WebSocket Client Connected');
        connection.on('error', function(error: any) {
            console.log("Connection Error: " + error.toString());
        });
        connection.on('close', function() {
            console.log('echo-protocol Connection Closed');
        });
        connection.on('message', function(message: any) {
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
                type: 'service',
                auth:'iotTaskAuth_111213181930'
            
        });
        connection.sendUTF(allow);
    
    });



    wsclient.connect(config.font_host_ws, 'echo-protocol');
}


 
 async function main(){
    
     await mysqlConnection.connect();
     await redisClient.connect();
     await consumer.connect()
     await consumer.subscribe({ topic: 'm2m', fromBeginning: true })
     await consumer.run({
         eachMessage: async ({ topic, partition, message }) => {
             //处理MQ 数据
             var msg = message.value? message.value.toString() :'';
             var msgJson = JSON.parse(msg?msg:'');
                console.log(msgJson);
             if(msgJson.type === 'LOGIN'){
                if(msgJson.id>0){
                    deviceLogin(msgJson) ;
                }else{
                    userLogin(msgJson) ;
                }
                return ;         
             }
             if(msgJson.type === 'LOGOUT'){
                if(msgJson.id>0){
                    deviceLogout(msgJson) ;
                }else{
                    userLogout(msgJson) ;
                }
                return ;  
            }
            
            
            if(msgJson.type=='user'){

                userMsg(msgJson);
            }else if(msgJson.type=='device'){
                deviceMsg(msgJson);
            }

            
             //
         },
     }) ;

     start_websocket();
 }
 
 main();