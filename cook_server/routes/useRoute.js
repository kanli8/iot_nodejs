/**
 * 提供给前置机调用的接口
 */

 var express = require('express');
 var router = express.Router();
 var md5 = require('md5');
 var mysql = require('../mysql/mysqlDeal');
var BUS_SQL= require('../mysql/busSQL');
var RE_CODE= require('../constant/errorResp');
/**
  *app login
 */
 router.post('/login', async function (req, res) {
    

});

/**
  *app login-第三方登录，先带username 上来吧
  * 设备信息不进行采集
 */
router.post('/loginAuth', async function (req, res) {
    const {username} = req.body;
    //设备ID
    
    //用户信息
    
    //如果没有，则创建一个


    //返回允许登录
    let reCode = RE_CODE.SUCCESS ;
    reCode["sessionId"] = "test_sessionId" ;
    res.send(reCode);
});





module.exports = router;