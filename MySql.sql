CREATE TABLE `qrcode` (
  `id` varchar(12) NOT NULL DEFAULT '',
  `url` varchar(200) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `qrlog` (
  `id` varchar(12) NOT NULL DEFAULT '',
  `ip` varchar(15) DEFAULT NULL,
  `log_date` datetime DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
