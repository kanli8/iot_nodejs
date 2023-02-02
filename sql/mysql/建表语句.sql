

drop table iot_custom ;
CREATE TABLE `iot_custom` (
  `custom_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `phone_num` varchar(18) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `addr` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `sale_name` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP ,
	`last_update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`custom_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

drop table iot_user ;
CREATE TABLE `iot_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP ,
	`last_update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop table iot_project ;
CREATE TABLE `iot_project` (
  `project_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_public_key` varchar(255) DEFAULT NULL,
  `project_screct_key` varchar(255) DEFAULT NULL,
  `owner_custom_id` int(255) DEFAULT NULL,
	`create_time` datetime DEFAULT CURRENT_TIMESTAMP ,
	`last_update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


drop table iot_device ;
CREATE TABLE `iot_device` (
  `device_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `device_request_serials` int(11) unsigned zerofill NOT NULL,
	`create_time` datetime DEFAULT CURRENT_TIMESTAMP ,
	`last_update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;