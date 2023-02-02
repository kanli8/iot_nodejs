const fetch = require('node-fetch');

async function main(){
    let body = {
        "id": 1,
        "sid": "sid",
        "sn": 1,
        "ek": "12ece392b4228ab644db7f2493677f0d",
        "rs": "randstr"
      }
    const response = await fetch(
        'http://127.0.0.1:8083/front/auth', 
        {method: 'POST',
            headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(body),});

    const data = await response.json();

    console.log(data);
}

main()
