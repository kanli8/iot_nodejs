"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.bssDatabases = exports.ossDatabases = void 0;
const mysql_1 = __importDefault(require("mysql"));
const redis_1 = require("redis");
const node_appwrite_1 = require("node-appwrite");
const conf_1 = require("./conf");
//  const kafka = new Kafka({
//    clientId: 'my-app-customer',
//    brokers: ['localhost:9092'],
//  })
//  const consumer = kafka.consumer({ groupId: 'iot_customer' })
const mysqlConnection = mysql_1.default.createConnection({
    host: 'localhost',
    port: 3306,
    user: 'iot',
    password: 'iotiot',
    database: 'iot'
});
const redisClient = (0, redis_1.createClient)({
    url: 'redis://localhost:6379'
});
redisClient.on('error', (err) => console.log('Redis Client Error', err));
const appClient = new node_appwrite_1.Client();
appClient
    .setEndpoint(conf_1.config.APPWRITE_URL) // Your API Endpoint
    .setProject(conf_1.config.APPWRITE_PROJECT_ID) // Your project ID
    .setKey(conf_1.config.API_SECRET_KEY);
const users = new node_appwrite_1.Users(appClient);
const ossDatabases = new node_appwrite_1.Databases(appClient, conf_1.config.OSS_DATABASE_ID);
exports.ossDatabases = ossDatabases;
const bssDatabases = new node_appwrite_1.Databases(appClient, conf_1.config.BSS_DATABASE_ID);
exports.bssDatabases = bssDatabases;
//# sourceMappingURL=common.js.map