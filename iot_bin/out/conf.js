"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.config = void 0;
exports.config = {
    MAX_CONNECT_NUM: 3,
    listen_port: 8082,
    font_host: '127.0.0.1',
    kafkaClientId: 'iot_font_1',
    http_ip_whitelist: [
        "127.0.0.1",
        "::ffff:127.0.0.1",
        "localhost"
    ],
    log_level: "debug",
    APPWRITE_URL: 'https://appwrite.ankemao.com/v1',
    APPWRITE_PROJECT_ID: '6305ce5fc916f9662a50',
    BSS_DATABASE_ID: '6305cefc1f0cdeaa8b96',
    OSS_DATABASE_ID: '6305cf020fd7c3e0174e',
    API_SECRET_KEY: '3f0497dc972a790eb0cb0b2ae20caa8dc99034ef7bd71a750cfaae4a03936890ee01aacc75b294acfb54b80942c29a3e1182c78664d3fa8a272a95413b50ca8dc728558063ce2b12f8b6812327c9b4bf03148c2c941b6dc33ff2fcbc87ffbae8a85000ba94e47c45ea67c897f5f127fa7108ec2ef9e62890db04750c755bb9cf',
    OSS_DEVICE_COLLETION_ID: '6305dd1f30ea754a2b25',
    OSS_UNIQUE_DEVICE_COLLETION_ID: '630dd7bbd82902436bc4',
    BSS_USER_FAMILY_COLLETION_ID: '63085f9f85baf18ab66d',
    BSS_FAMILY_COLLETION_ID: '63085fae908b32733d3f',
    BSS_DEVICE_FAMILY_COLLETION_ID: '63086186adb68ca2efe5',
    REDIS_DEVICE_FAMILY_KEY: 'devices_family',
    REDIS_FAMILY_KEY: 'family',
};
//# sourceMappingURL=conf.js.map