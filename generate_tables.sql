
CREATE DATABASE vending_machines;

USE vending_machines;


CREATE TABLE periodicity (
	id INT NOT NULL AUTO_INCREMENT,
	days INT NOT NULL,
	description VARCHAR(100),
	created_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (id)
);

CREATE TABLE product (
	id INT  NOT NULL AUTO_INCREMENT,
	name VARCHAR(255),
	description VARCHAR(255),
	created_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY(id)
);

CREATE TABLE machine (
	id INT NOT NULL AUTO_INCREMENT,
	description VARCHAR(255),
	product_id INT,
	quantity INT,
	created_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY(id),
	FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE place (
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(255),
	address VARCHAR(255),
	zip_code VARCHAR(12),
	phone VARCHAR(50),
	contact_name VARCHAR(100),
	actived_date TIMESTAMP,
	cancelled_date TIMESTAMP NULL,
	periodicity_id INT,
	created_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY(id),
	FOREIGN KEY (periodicity_id) REFERENCES periodicity(id)
);

CREATE TABLE `place_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `place_id` int(11) NOT NULL,
  `machine_id` int(11) NOT NULL,
  `machine_quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `place_id` (`place_id`),
  KEY `machine_id` (`machine_id`),
  CONSTRAINT `place_detail_ibfk_1` FOREIGN KEY (`place_id`) REFERENCES `place` (`id`) ON DELETE CASCADE,
  CONSTRAINT `place_detail_ibfk_2` FOREIGN KEY (`machine_id`) REFERENCES `machine` (`id`) ON DELETE CASCADE
);

CREATE TABLE `user`(
	id int not null auto_increment,
	name varchar(255),
	email varchar(255),
	login varchar(50),
	`password` varchar(20),
	PRIMARY KEY (id)
);
