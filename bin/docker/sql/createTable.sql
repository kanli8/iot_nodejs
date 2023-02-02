
CREATE TABLE `logs_device_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `data` text DEFAULT NULL,
  `send_time` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `status` int(11) DEFAULT NULL,
  `retry_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `logs_devices_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `randstr` varchar(255) DEFAULT NULL,
  `serials` int(255) DEFAULT NULL,
  `oper_count` int(255) DEFAULT NULL,
  `md5` varchar(255) DEFAULT NULL,
  `auth_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `login_ip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `logs_user_auth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(0) DEFAULT NULL,
  `session_id` varchar(0) DEFAULT NULL,
  `auth_time` datetime DEFAULT NULL,
  `login_ip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `logs_user_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) DEFAULT NULL,
  `data` text DEFAULT NULL,
  `send_time` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `status` int(11) DEFAULT NULL,
  `retry_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `user_schema` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `data` text DEFAULT NULL,
  `schema_time` datetime DEFAULT NULL,
  `insert_time` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


