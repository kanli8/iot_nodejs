//过滤器
/**------------过滤器 start---------- */
var path = require('path')
var mysql = require('../mysql/mysqlDeal');
const os = require('os')
const fs = require('fs')
var ErrorCode = require('../constant/errorResp');
const platform = os.platform()
var {getUserInfo} = require('../util/SeesionUtil');

/**
 * 通用过滤器，兼容系统间过滤器，API请求过滤器，session请求过滤器
 * @param {*} req 
 * @param {*} res 
 * @param {*} next 
 */
const commonFilter =async (req, res, next) => { 

  // let isStatic = staticFileFilter(req, res, next) ;
  // console.log("isStatic........."+isStatic);
  if(!await staticFileFilter(req, res, next)){
    console.log("return........");
    return ;
  }

  if(!managerFilter(req, res, next)){
    return ;
  }

  if(!sessionFilter(req, res, next)){
    return ;
  }

  if(!apiFilter(req, res, next)){
    return ;
  }
  next();


}


const staticFileFilter =async (req, res, next) =>{
  let startTime = Date.now();
  let fullUrl = req.protocol + '://' + req.get('host') + req.originalUrl;
  console.log("req.pathname:::");
  console.log(req._parsedUrl.pathname);
  console.log("req.pathname:::");
  let host = req.get('host')  ;
  /**
   * 查看是否是请求静态资源，
   * 非以下前缀 均会视作静态文件请求
   * admin.ankemao.com
   * api.ankemao.com
   * */
  if(
    host.toLowerCase().trim()==="admin.ankemao.com"
    || host.toLowerCase().trim()==="api.ankemao.com"){
      return true ;
  }
  console.log("fullUrl:"+fullUrl);
  let ip = req.socket.remoteAddress ;
  let x_forwarded_for=req.headers['x-forwarded-for'] ;
  //根据请求头，返回
  let getHostInfoSql = 'select * from cms_host_dir where host=?';
  let insertReqLogSql = 'insert into cms_req_log (connect_ip,x_forwarded_for,req_full_url,deal_timeout) value (?,?,?,?)';

  //获取host配置
  console.log("req.get('host'):staticFileFilter:::"+req.get('host'));
  let mysqlres =await mysql.doSQL(getHostInfoSql,[host]);

  if(mysqlres==null||mysqlres.length==0){
    console.log("mysqlres==null........");
    res.send(ErrorCode.FILE_NOT_EXIST);
    return false;
  }
   //获取路径
  let pathDir = mysqlres[0].html_dir ;

  //补全文件信息
  let filePath = pathDir +req._parsedUrl.pathname ;
  if(!filePath.match(/.*\..*/)){
    if(req._parsedUrl.pathname==='/'){
      filePath = filePath +"index.html"
    }else{
      filePath = filePath +".html"
    }
    
  }
  if(platform == 'win32'){
    
    filePath =filePath.replaceAll("/","\\");
  }

 
  
  console.log("filePath:::"+filePath);

  if(!fs.existsSync(filePath)){
    console.log("no fs.existsSync(filePath)");
    if(platform == 'win32'){
      res.sendFile(pathDir+"\\"+"404.html") ;
    }else{
      res.sendFile(pathDir+"/"+"404.html") ;
    }
    let endTime = Date.now();
    let timeout = endTime - startTime ;
    let params = [ip,x_forwarded_for,fullUrl,timeout];
    mysql.doSQL(insertReqLogSql,params);
    return false ;
  }
  var resolvedPath = path.resolve(filePath);
  console.log(resolvedPath);
  res.sendFile(resolvedPath) ;
  console.log("send file....");
  let endTime = Date.now();
  let timeout = endTime - startTime ;
  let params = [ip,x_forwarded_for,fullUrl,timeout];
  mysql.doSQL(insertReqLogSql,params);
  return false ;
}

//@deprecated
const managerFilter = (req, res, next) => {
    console.log("managerFilter.....");
    // if(true){
    //   next()
    //   return ;
    // }
      let pk = process.env.MANAGER_PK ;
      let sk = process.env.MANAGER_SK ;
      let r_pk = req.headers.public_key ; //公钥
      let r_rs = req.headers.random_str ; //随机数
      let r_time = req.headers.req_time ; //请求时间戳,秒
      let md5_value = req.headers.md5_value ; 
      let now = Date.now() / 1000;
      if(Math.abs(now-r_time) > 60000){ //60000秒提供测试，上线改为20秒
        res.status(401);
        res.send("time error noAccess");
        //next("noAccess");
      }else{
        let data =""+ pk + sk + r_rs + r_time ;
        console.log(data);
        let r_md5 = crypto.createHash('md5').update(data).digest("hex");
        console.log("r_md5---->"+r_md5);
        if(r_md5==md5_value){
          next()
        }else {
          res.status(401);
          res.send("noAccess");
         // next("noAccess");
        }
       
      }
  
     
      // if(req.params.name == 'admin' && req.params.pwd == 'admin'){
      //     next()
      // } else {
      //     next('用户名密码不正确')
      // }
  }
  
  /* TODO  过滤器，session 版本 */
  //@deprecated
let sessionFilter = (req, res, next) => {
  //mysql 
    let username = req.session.username ;
    if(!username){
      res.status(401);
      res.send("noAccess");
    }
}
  
  /** TODO  过滤器，API 版本 */
  //@deprecated
  const apiFilter = (req, res, next) => {
  
    // if(true){
    //   next()
    //   return ;
    // }
      let pk ="从数据库获取";
      let sk = "从数据库获取" ;
      let r_pk = req.headers.public_key ; //公钥
      let r_rs = req.headers.random_str ; //随机数
      let r_time = req.headers.req_time ; //请求时间戳,秒
      let md5_value = req.headers.md5_value ; 
      let now = Date.now() / 1000;
      if(Math.abs(now-r_time) > 60000){ //60000秒提供测试，上线改为20秒
        res.status(401);
        res.send("time error noAccess");
        //next("noAccess");
      }else{
        let data =""+ pk + sk + r_rs + r_time ;
        console.log(data);
        let r_md5 = crypto.createHash('md5').update(data).digest("hex");
        console.log("r_md5---->"+r_md5);
        if(r_md5==md5_value){
          next()
        }else {
          res.status(401);
          res.send("noAccess");
         // next("noAccess");
        }
       
      }
  }
  
  
  
  /**------------过滤器 end---------- */

  module.exports = {
    commonFilter
  }