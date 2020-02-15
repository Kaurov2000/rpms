DROP DATABASE IF EXISTS rpms;
CREATE DATABASE rpms;
USE rpms;

-- Таблица, содержащая пользователей системы
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

-- Таблица профилей пользователей системы
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

-- Таблица с клиентами - арендаторами
CREATE TABLE IF NOT EXISTS clients (
	client_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(100) NOT NULL,
	middle_name VARCHAR(100),
	last_name VARCHAR(100),
	passport_number VARCHAR(20),
	phone VARCHAR(15),
	email VARCHAR(120),
	comment TEXT,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (client_id)
);


-- Словарь услуг, которые могут оказывать объекты системы
CREATE TABLE IF NOT EXISTS service_types (
	service_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	service_type VARCHAR(120),
	PRIMARY KEY (service_type_id)
);

-- Таблица с контрагентами
CREATE TABLE IF NOT EXISTS contractors (
	contractor_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	country VARCHAR(100),
	city VARCHAR(100),
	address VARCHAR(200),
	phone VARCHAR(15),
	email VARCHAR(120),
	comment TEXT,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (contractor_id)
);

-- Таблица связи контрагентов с оказываемыми услугами
CREATE TABLE contractor_service_type_links (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	contractor_id INT UNSIGNED NOT NULL,
	service_type_id INT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY (contractor_id,service_type_id),
	CONSTRAINT contractors_service_types_links_contractor_id_fk FOREIGN KEY (contractor_id) REFERENCES contractors(contractor_id),
	CONSTRAINT contractors_service_types_links_service_type_id_fk FOREIGN KEY (service_type_id) REFERENCES service_types(service_type_id)
);


-- Словарь типов объектов недвижимости
CREATE TABLE asset_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	asset_type VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

-- Таблица с объектами недвижимости
CREATE TABLE assets (
	asset_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(100),
	country VARCHAR(100),
	city VARCHAR(100),
	address VARCHAR(200),
	asset_type_id INT UNSIGNED,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (asset_id),
	CONSTRAINT assets_asset_type_id_fk FOREIGN KEY (asset_type_id) REFERENCES asset_types(id)
);

-- Таблица связей пользователей и объектов недвижимости
CREATE TABLE user_asset_links (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	user_id INT UNSIGNED NOT NULL,
	asset_id INT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY (user_id,asset_id),
	CONSTRAINT user_asset_links_user_id_fk FOREIGN KEY (user_id) REFERENCES users(user_id),
	CONSTRAINT user_asset_links_asset_id_fk FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
);


-- Таблица связей арендаторов и объектов недвижимости
CREATE TABLE client_asset_links (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	client_id INT UNSIGNED NOT NULL,
	asset_id INT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY (client_id,asset_id),
	CONSTRAINT client_asset_links_client_id_fk FOREIGN KEY (client_id) REFERENCES clients(client_id),
	CONSTRAINT client_asset_links_asset_id_fk FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
);

-- Словарь типов документов. Документы относятся только к одному объекту
CREATE TABLE document_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	document_type VARCHAR(50) NOT NULL,
	document_subject_type VARCHAR(50) NOT NULL, 
	PRIMARY KEY (id)
);

-- Таблица с документами
CREATE TABLE documents (
	document_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	owner_id INT UNSIGNED NOT NULL,
	name VARCHAR(100),
	document_number VARCHAR(100),
	issue_date DATE,
	document_type_id INT UNSIGNED,
	document_subject_id INT UNSIGNED,
	document_file VARCHAR(200) NOT NULL,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (document_id),
	CONSTRAINT documents_document_type_id_fk FOREIGN KEY (document_type_id) REFERENCES document_types(id),
	CONSTRAINT documents_owner_id_fk FOREIGN KEY (owner_id) REFERENCES users(user_id)
);


-- Словарь объектов системы, которые могут выступать сторонами договора
CREATE TABLE counterpart_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	counterpart_type VARCHAR(50) NOT NULL, 
	PRIMARY KEY (id)
);


-- Таблица с договорами
CREATE TABLE contracts (
	contract_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(200),
	contract_number VARCHAR(100),
	issue_date DATE,
	user_id INT UNSIGNED NOT NULL,
	asset_id INT UNSIGNED NOT NULL,
	counterpart_type_id INT UNSIGNED,
	counterpart_id INT UNSIGNED NOT NULL,
	contract_file VARCHAR(200) NOT NULL,
	service_type_id INT UNSIGNED,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (contract_id),
	CONSTRAINT contracts_user_id_fk FOREIGN KEY (user_id) REFERENCES users(user_id),
	CONSTRAINT contracts_asset_id_fk FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
	CONSTRAINT contracts_counterpart_type_id_fk FOREIGN KEY (counterpart_type_id) REFERENCES counterpart_types(id),
	CONSTRAINT contracts_service_type_id_fk FOREIGN KEY (service_type_id) REFERENCES service_types(service_type_id)
);


-- Таблица со счетами
CREATE TABLE bills (
	bill_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	bill_number VARCHAR(100),
	issue_date DATE,
	contract_id INT UNSIGNED NOT NULL,
	issuer_type_id INT UNSIGNED NOT NULL,
	issuer_id INT UNSIGNED NOT NULL,
	bill_amount DECIMAL(2),
	payment_date DATE,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (bill_id),
	CONSTRAINT bills_contract_id_fk FOREIGN KEY (contract_id) REFERENCES contracts(contract_id),
	CONSTRAINT bills_issuer_type_id_fk FOREIGN KEY (issuer_type_id) REFERENCES counterpart_types(id)
);


