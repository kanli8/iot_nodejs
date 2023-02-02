Unexpected token . - ...options?.modules #2131

Environment:

Node.js Version: v11.2.0
Redis Server Version: 5.0.3
Node Redis Version: 4.0.6
Platform: node:11.2.0-alpine + any docker image
usr/src/app/node_modules/redis/dist/index.js:42
...options?.modules
^

SyntaxError: Unexpected token .
at Module._compile (internal/modules/cjs/loader.js:760:23)
at Object.Module._extensions..js (internal/modules/cjs/loader.js:827:10)
at Module.load (internal/modules/cjs/loader.js:685:32)
at Function.Module._load (internal/modules/cjs/loader.js:620:12)
at Module.require (internal/modules/cjs/loader.js:723:19)
at require (internal/modules/cjs/helpers.js:14:16)
at Object. (/usr/src/app/config/redis_connector.js:2:15)
at Module._compile (internal/modules/cjs/loader.js:816:30)
at Object.Module._extensions..js (internal/modules/cjs/loader.js:827:10)
at Module.load (internal/modules/cjs/loader.js:685:32)
root@ee0301c9b03e:/usr/src/app# node --version


sudo npm cache clean -f
sudo npm install -g n
sudo n stable