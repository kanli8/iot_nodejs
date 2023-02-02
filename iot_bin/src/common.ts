/**
 * 没有走redis
 */
 import {Kafka} from 'kafkajs';
 import fetch from 'node-fetch';
 import mysql from 'mysql';
 import { createClient } from 'redis';
 import {Client, Users,Databases,Query } from 'node-appwrite' ;
import { config } from './conf';


 
//  const kafka = new Kafka({
//    clientId: 'my-app-customer',
//    brokers: ['localhost:9092'],
//  })
 
//  const consumer = kafka.consumer({ groupId: 'iot_customer' })
 
 const mysqlConnection = mysql.createConnection({
    host     : 'localhost',
    port     : 3306,
    user     : 'iot',
    password : 'iotiot',
    database : 'iot'
  });
 

  const redisClient = createClient({
    url: 'redis://localhost:6379'
    });

  redisClient.on('error', 
    (err) => console.log('Redis Client Error', err)
    );


const appClient = new Client();

appClient
    .setEndpoint(config.APPWRITE_URL) // Your API Endpoint
    .setProject(config.APPWRITE_PROJECT_ID) // Your project ID
    .setKey(config.API_SECRET_KEY) ;

const users = new Users(appClient);
const ossDatabases = new Databases(appClient, config.OSS_DATABASE_ID);
const bssDatabases = new Databases(appClient, config.BSS_DATABASE_ID);

 

export {
  ossDatabases,
  bssDatabases
}
