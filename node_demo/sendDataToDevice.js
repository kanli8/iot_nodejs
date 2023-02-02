const fetch = require('node-fetch');
const {Base64} = require('js-base64');
const url = require('url');
async function main(){
    let str = "bigtree" ;
    let enStr = Base64.encode(str);
    let body = {
        "id": 1,
        "data":enStr
      }

    let urlStr = url.format({
        protocol:'http',
        host: '127.0.0.1:8082',
        port:8082,
        query: {
            id: 1,
          data: enStr
        }
      })
      console.log(urlStr);
    const response = await fetch(urlStr);

    const data = await response.json();

    console.log(data);
}

main()
