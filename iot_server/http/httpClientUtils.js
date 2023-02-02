var http = require('http');
var uuid = require('uuid');
var crypto = require('crypto');
const { SimDevCloudConfig: {http_host, http_port}} = require('../config/config');

async function post(action, params) {
    console.log(" COME IN");
    var options = { 
        host: http_host, 
        port: http_port, 
        path: action, 
        method: 'post', 
        headers: { 
            'Content-Type': 'application/json', 
            'Content-Length': params.body.length,
            ...params.headers
        } 
    };

    return new Promise((resolve, reject) => {
        //使用http 发送
        var req = http.request(options, function (res) {
            console.log('STATUS: ' + res.statusCode);
            console.log('HEADERS: ' + JSON.stringify(res.headers));
            //设置字符编码
            res.setEncoding('utf8');
            //返回数据流
            var _data = "";
            //数据
            res.on('data', function (chunk) {
                _data += chunk; console.log('BODY: ' + chunk);
            });
            // 结束回调
            res.on('end', function () {
                console.log("REBOAK:", _data) ; 
                resolve(_data)
            });
            //错误回调 // 这个必须有。 不然会有不少 麻烦
            req.on('error', function (e) {
                console.error('problem with request: ' + e.message); 
                reject('problem with request: ' + e.message)
            });
        }); 
        req.write(params.body + "\n"); 
        req.end();
    });
}

async function initRoute() {
    const random = uuid.v4();
    const requestTime = Date.now()/1000;
    const data = `${process.env.SIM_PROJECT_ID||150}${process.env.MANAGER_PK||''}${process.env.MANAGER_SK||''}${random}${requestTime}`;
    const md5Value = crypto.createHash('md5').update(data).digest("hex");
    const headers = { random, requestTime, md5Value }
    console.log(`{
        rocess.env.SIM_PROJECT_ID: ${process.env.SIM_PROJECT_ID},
        process.env.MANAGER_PK:${process.env.MANAGER_PK||''},
        process.env.MANAGER_SK:${process.env.MANAGER_SK||''},
        data: ${data}
    }`, headers)
    return await post('/sim/simapi/route/init', {
        headers,
        body: JSON.stringify({
            "projectId": process.env.SIM_PROJECT_ID
        })
    });
}

module.exports = {
    post,
    initRoute
}
