const sdk = require('node-appwrite');

const client = new sdk.Client();

client
    .setEndpoint('https://appwrite.ankemao.com/v1') // Your API Endpoint
    .setProject('62fc87d29f0534cfdfab') // Your project ID
    .setKey('fa85aeeefd027ad57860babb0ce0b34b41bfb82d805b9601c76aad94fbeec81f1a67641b96c2098ec174c53cb8b93f753348f5b178da6f8f95b60f5639221150e940646d3e4f3d256ef7a4392c548bdbe3d045e8915fe5a904148b6838fe877ced5037b29a44b96d973a41b115665400527165fc1e59649ee4eb029c8c24901d') // Your secret API key
;

const users = new sdk.Users(client);
const databases = new sdk.Databases(client,'6302f6fea7c0aa302d8a');
const query = sdk.Query;

// const promise = users.getSessions('064cabd3-cf59-42b8-9c50-b74e6b170e86');

// //获取session 信息
// promise.then(function (response) {
//     console.log(response);
// }, function (error) {
//     console.log(error);
// });

const dbpromise =databases.listDocuments('6302f83391e4b4e4c619',
[
    query.equal('id',1)
]);

dbpromise.then(function (response) {

    console.log(response);
}, function (error) {
    console.log(error);
});




