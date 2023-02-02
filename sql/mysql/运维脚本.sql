# 创建客户信息
delete from iot_custom where `name` ='八斤';
insert into iot_custom (
  `name` ,`phone_num` ,`email`,`company`, `addr` ,`sale_name` 
) values(
	'八斤','13112341234','bajin@wangwang.com','大宇宙汪星人科技公司','银河系太阳系火星','pkc');
	
	select * from iot_custom where `name` ='八斤'; -- custom_id=3
# 为客户创建登录用户
INSERT INTO iot_user (username,`password`,`email`,`phone`)
VALUES
('bajin','bajin123','bajin@wangwang.com','13112341234')

select * from iot_user a where a.username='bajin' ; -- user_id=1

update iot_custom set user_id=1 where custom_id=3 ;

# 添加项目
select RIGHT(TO_BASE64(uuid()),8);
select RIGHT(TO_BASE64(uuid()),16);

insert into iot_project (project_name,project_public_key,project_screct_key,owner_custom_id)
value('空气烤箱',RIGHT(TO_BASE64(uuid()),8),RIGHT(TO_BASE64(uuid()),16),3)
select * from iot_project where project_name='空气烤箱' and owner_custom_id=3 ; -- project_id=2
#添加设备
insert into iot_device (project_id,device_request_serials) values (2,0);
