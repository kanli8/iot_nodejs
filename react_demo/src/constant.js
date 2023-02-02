import { Client } from "appwrite";

const appwriteClient = new Client();

appwriteClient
  .setEndpoint("https://appwrite.ankemao.com/v1") // Your Appwrite Endpoint
  .setProject("6305ce5fc916f9662a50"); //


export {appwriteClient};