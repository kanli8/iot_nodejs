const fs = require('fs');
const path = require('path');
const http = require('http');
var url = require('url');

const loadByIconName = (iconName) => {
    return new Promise((resolve, reject) => {
        const iconPath = path.join(__dirname, "icons", `${iconName}.ico`);
        console.log('iconPath ... ', iconPath)

        let exists = fs.existsSync(iconPath);
        if(!exists){
            reject("图片不存在：" + iconPath);
            return;
        }

        fs.readFile(iconPath, 'binary', function (err, file) {
            if(err) reject(err);
            resolve({
                type: "image/x-icon; charset=UTF-8", // image/vnd.microsoft.icon; charset=UTF-8
                data: file
            })
        })
    })
    
}

const loadByUrl = (http_url) => {
    var options = url.parse(http_url);
    return new Promise((resolve, reject) => {

        var request = http.get(options, function (response) {
            var data = '';
            response.setEncoding('binary');
            response.on('data', function (chunk) {
                data += chunk;
            });

            response.on('end', function () {
                resolve({
                    type: response.headers["content-type"], 
                    data
                });
            })
        });
        request.on('error', function (err) {
            console.log('Error : Image err' + err);
            request.abort();
            reject(err);
        });

        request.setTimeout(5000, function () {
            console.log('Error : Image Time Out');
            request.abort();
            reject('Error : Image Time Out')
        })
    })

}

const loadByPath = (filePath) => {
    return new Promise((resolve, reject) => {
        let exists = fs.existsSync(filePath);
        if(!exists){
            reject("图片不存在：" + filePath);
            return;
        }

        let contentType = "";
        if(filePath.endsWith(".png")) {
            contentType = "image/png; charset=UTF-8";

        } else if (/\.[jfif|jpg|jpe|jpeg]$/.test(filePath)) {
            contentType = "image/jpeg; charset=UTF-8";

        } else if (filePath.endsWith(".bmp")) {
            contentType = "application/x-bmp; charset=UTF-8";

        } else if (filePath.endsWith(".gif")) {
            contentType = "image/gif; charset=UTF-8";

        } else if (filePath.endsWith(".ico")) {
            contentType = "image/x-icon; charset=UTF-8";
        }
        fs.readFile(filePath, 'binary', function (err, file) {
            if(err) reject(err);
            resolve({ type: contentType, data: file})
        })
    })
}

const upload = (file) => {
    const imgName = `${file.filename}.${file.mimeType.split('/')[1]}`;
    // 读取文件
    const readFile = fs.readFileSync(file.filepath);
    // 写入文件
    const imagePath = join(__dirname, `../public/uploadImg/${imgName}`);
    fs.writeFileSync(
        imagePath,
        readFile
    );
    
    return imagePath;
}

module.exports = {
    loadByIconName,
    loadByUrl,
    loadByPath,
    upload
}