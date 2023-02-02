/**
 * 提供给前置机调用的接口
 */

 var express = require('express');
 var router = express.Router();
 var md5 = require('md5');
 var mysql = require('../mysql/mysqlDeal');
var BUS_SQL= require('../mysql/busSQL');
 
/**
 * {
  id: 1,
  sid: 'sid',
  sn: 2,
  ek: '4bf2f06e8d22de9bfe6ff9572ffb3ebe',
  rs: 'randstr'
}
 */
 router.post('/auth', async function (req, res) {
    const {id,sn,ek,rs} = req.body;
    let resList = await mysql.doSQL(BUS_SQL.getAuthInfo,[id]);
    if(resList.length==0){
        res.send({reCode:9,reDesc:"Device not found"});
        return ;
    }
    
    let device_request_serials = resList[0].device_request_serials ;
    let project_public_key=resList[0].project_public_key ;
    let project_screct_key=resList[0].project_screct_key
    let enstr = project_public_key+"-"+rs+"-"+project_screct_key+"-"+sn
    let renkey = md5(enstr);
    console.log("enstr:::"+enstr);
    console.log("enstr_md5:::"+renkey);
    // mysql.doSQL(BUS_SQL.upateDeviceSerials,[ns,deviceId]);
    let reCode = 0 ;
    // MTEwMDAy-randstr-MDI0MmFjMTEwMDAy-1
    if(renkey==ek){
        res.send({reCode:0,reDesc:"SUCCESS"});
    }else{
        reCode = 3
        res.send({reCode:3,reDesc:"NOT ACCESS"});
    }
    // (device_id,serialsNum,enkey,randstr,res_code)
    mysql.doSQL(BUS_SQL.insert_auth_log,[id,sn,ek,rs,reCode]);


});





module.exports = router;