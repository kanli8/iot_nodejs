const {Base64} = require('js-base64');

let u8s   =  new Uint8Array([100,97,110,107,111,103,97,105]);
var base64 = Base64.fromUint8Array(u8s);   
console.log(base64);
