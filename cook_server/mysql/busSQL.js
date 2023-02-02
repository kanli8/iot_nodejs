// 获取鉴权信息
const getAuthInfo=`
    select 
    a.project_public_key, 
    a.project_screct_key, 
    b.device_request_serials 
    from iot_project a , 
    iot_device b 
    where a.project_id=b.project_id  
    and b.device_id=?
    `;

//序号增加
const upateDeviceSerials=
    `update iot_device a set 
    a.device_request_serials=?
    where a.device_id=?`;

//鉴权日志记录
const insert_auth_log = 
    `insert into iot_auth_log(device_id,serialsNum,enkey,randstr,res_code)
      value (?,?,?,?,?)
    `;

module.exports = {
    getAuthInfo,
    upateDeviceSerials,
    insert_auth_log
}