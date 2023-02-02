import {Client, Users,Databases,Query } from 'node-appwrite' ;
import { IBinaryMessage, IUtf8Message } from 'websocket';
import md5 from 'md5';
import { config } from '../conf';
import { createClient } from 'redis';

const client = new Client();

client
    .setEndpoint(config.APPWRITE_URL) // Your API Endpoint
    .setProject(config.APPWRITE_PROJECT_ID) // Your project ID
    .setKey(config.API_SECRET_KEY) ;
const users = new Users(client);
const databases = new Databases(client, config.OSS_DATABASE_ID);




interface AllowData {
    user_id: string;
    id: number;
    uid:number ;
    randstr:string;
    serials:number ;
    oper_count:number;
    md5:string;
    session_id:string;


}


const redisClient = createClient({ url: 'redis://localhost:6379'});

redisClient.on('error', (err) => console.log('Redis Client Error', err));
redisClient.connect();

// const setRedisValue = async (key:string,value:string) => {
//     return new Promise((resolve, reject) => {
//         redisClient.set(key, value);
//     });
// }




const device_auth = async (origin: IBinaryMessage,onAuthFinish : Function) => {
    const dataBuffer = origin.binaryData;
        console.log("dataBuffer=========");
        if(dataBuffer!=null){
            //  let hexStr = dataBuffer.toString('hex').match(/../g);
           
            console.log(dataBuffer.toString('hex').match(/../g)?.join(' '));
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
        const list = await databases.listDocuments(
            config.OSS_UNIQUE_DEVICES_COLLECTION_ID,
            [
                Query.equal('uid',uidStr)
            ]
        );
        if(list.documents.length==0){
            console.log("list.documents.length==0, return false");
            return false;
        }
        const device:any = list.documents[0];

        const device_sk:string = device.sk;
        const device_status :number = device.status;
        if(device_status!==0){
            console.log("device_status!==0, return false");
            return false;
        }
       
      
     
        //device sk hex string to uint8array
        const device_skUint8Array = new Uint8Array(device_sk.match(/.{1,2}/g)!.map(byte => parseInt(byte, 16)));

        //complate sk
        let nbuffer =  dataUint8Array.slice(0, 49);
        //set sk
        nbuffer.set(device_skUint8Array,33);
       

 
        //calculate md5
        const newMd5 = md5(nbuffer);
        //newUint8Array to hex string
        // const newMd5Str = newMd5.match(/.{1,2}/g)!.map(byte => parseInt(byte, 16)).reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');
        // console.log(dataBuffer.toString('hex').match(/../g)?.join(' '));
        // console.log("nbuffer:::"+Buffer.from(nbuffer).toString('hex').match(/../g)?.join(' '));
        // console.log("esp md5:::"+md5Str);
        // console.log("cal md5:::"+newMd5);
        if(newMd5!=md5Str){
            console.log("newMd5!=md5Str, return false");
            return false;
        }

        if (status == 1) {
            //set new device id
            const update = await databases.updateDocument(
                config.OSS_UNIQUE_DEVICES_COLLECTION_ID,
                device.$id,
                {
                    device_id: idStr
                }
            );
        }


        //get device bind user
        const list2 = await databases.listDocuments(
            config.OSS_USER_DEVICE_COLLECTION_ID,
            [
                Query.equal('device_id',idStr)
            ]
        );
        for(const doc2 of list2.documents){
            //save to redis
            const key = "device_"+idStr;
            let doc3 : any = doc2;
            const value : string = doc3.owner_user_id;
            redisClient.set(key, value);

        }
        
        onAuthFinish('device',idStr);
        return true ;


}

const app_auth = async (origin: IUtf8Message,onAuthFinish : Function) => {
    const dataStr = origin.utf8Data;
    console.log("dataStr=========");
    console.log(dataStr);
    if(dataStr!=null){
        const data = JSON.parse(dataStr);
        const user_id = data.user_id;
           //user normal check
        if(data.user_id!=null && ''!==data.user_id){
            //user
            let user_id = data.user_id;
            let session_id =  data.session_id ;
            const list =await users.getSessions(user_id);
            for(var i=0; i< list.sessions.length; i++){
                const session = list.sessions[i];
                if(session.$id==session_id){
                    //get user devie list from oss
                    const list = await databases.listDocuments(
                        config.OSS_USER_DEVICE_COLLECTION_ID,
                        [
                            Query.equal('owner_user_id',user_id)
                        ]
                    );
                    for(var j=0; j< list.documents.length; j++){
                        var docs : any = list.documents[j];
                        
                    }
                    //get user device list from appwrite
                    const list2 = await databases.listDocuments(
                        config.OSS_USER_DEVICE_COLLECTION_ID,
                        [
                            Query.equal('owner_user_id',user_id)
                        ]
                    );
                    //save to redis
                    var deviceList = [];
                    for(var j=0; j< list2.documents.length; j++){
                        var docs : any = list2.documents[j];
                        var device_id = docs.device_id;
                        deviceList.push(device_id);
                    }
                    const key = "user_"+user_id;
                    const value = JSON.stringify(deviceList);
                    redisClient.set(key, value);


                    onAuthFinish('user',user_id);
                    return true ;
                }
            }
        }
    }
    return false ;
}


const service_auth = async (origin: IUtf8Message,onAuthFinish : Function) => {
    const dataStr = origin.utf8Data;
    console.log("dataStr=========");
    console.log(dataStr);
    if(dataStr!=null){
        const data = JSON.parse(dataStr);
        const auth = data.auth;
        if(auth=='iotTaskAuth_111213181930'){
            onAuthFinish('service','iotTaskAuth_111213181930');
            return true;
        }
    }
    return false ;

}

/**
 * 登入校验
 * @param {*} origin 
 * @returns 
 */
 export const auth = async (origin:  IUtf8Message | IBinaryMessage,onAuthFinish : Function ) =>{

    if(origin.type=='utf8'){
        const dataStr = origin.utf8Data;
        if(dataStr!=null){
            const data = JSON.parse(dataStr);
           if(data.type=='service'){
                return await service_auth(origin,onAuthFinish);
           }else{
                return await app_auth(origin,onAuthFinish);
           }
        }
       
        
    }

    //esp connect
    if(origin.type=='binary'){
        return device_auth(origin,onAuthFinish);
    }
    
    return false ;
}

export const logout = async (id:string,type:string) =>{
    if(type=='DEVICE'){
       //delete redis device info
         await redisClient.del("device_"+id);
    }

    if(type=='user'){
        //delete redis user info
       
        await redisClient.del("user_"+id);
    }
    return true;
}



