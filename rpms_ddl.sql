CREATE DATABASE rpms;
USE rpms;

CREATE TABLE IF NOT EXISTS users (
	user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	login VARCHAR(50) NOT NULL,
	password_hash CHAR(64),
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (user_id),
	UNIQUE KEY (login)
);
CREATE INDEX users_login_idx ON users(login);

CREATE TABLE IF NOT EXISTS user_profiles (
	user_id INT UNSIGNED NOT NULL,
	first_name VARCHAR(100) NOT NULL,
	middle_name VARCHAR(100),
	last_name VARCHAR(100),
	phone VARCHAR(15),
	email VARCHAR(120),
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT user_profiles_fk FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS clients (
	client_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (client_id)
);

CREATE TABLE IF NOT EXISTS client_profiles (
	client_id INT UNSIGNED NOT NULL,
	first_name VARCHAR(100) NOT NULL,
	middle_name VARCHAR(100),
	last_name VARCHAR(100),
	passport_number VARCHAR(20),
	phone VARCHAR(15),
	email VARCHAR(120),
	comment TEXT,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT client_profiles_fk FOREIGN KEY (client_id) REFERENCES clients(client_id)
);
CREATE INDEX clients_name_idx ON clients(last_name,first_name,middle_name);

CREATE TABLE IF NOT EXISTS contractors (
	contractor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (contractor_id)
);

CREATE TABLE IF NOT EXISTS contractor_profiles (
	contractor_id INT UNSIGNED NOT NULL,
	name VARCHAR(100) NOT NULL,
	country VARCHAR(100),
	city VARCHAR(100),
	address VARCHAR(200),
	phone VARCHAR(15),
	email VARCHAR(120),
	service_type_id INT UNSIGNED,
	comment TEXT,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	CONSTRAINT contractor_profiles_fk FOREIGN KEY (contractor_id) REFERENCES contractors(contractor_id)
);
CREATE INDEX contractor_profiles_name_idx ON contractor_profiles(name);
CREATE INDEX contractor_profiles_service_type_id_idx ON contractor_profiles(service_type_id);
CREATE INDEX contractor_profiles_city_idx ON contractor_profiles(country,city);

CREATE TABLE IF NOT EXISTS service_types (
	service_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	service_type VARCHAR(120),
	PRIMARY KEY (service_type_id)
);
ALTER TABLE contractor_profiles 
	ADD CONSTRAINT contractor_profiles_service_type_id_fk FOREIGN KEY (service_type_id) REFERENCES service_types(service_type_id);
	


