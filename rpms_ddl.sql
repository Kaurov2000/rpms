DROP DATABASE IF EXISTS rpms;
CREATE DATABASE rpms;
USE rpms;

-- Таблица с пользователями системы
CREATE TABLE IF NOT EXISTS users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	login VARCHAR(50) NOT NULL,
	password_hash CHAR(64),
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (id),
	UNIQUE KEY (login)
);

-- Таблица с профилями пользователей системы
CREATE TABLE IF NOT EXISTS user_profiles (
	user_id INT UNSIGNED NOT NULL,
	first_name VARCHAR(100) NOT NULL,
	middle_name VARCHAR(100),
	last_name VARCHAR(100),
	phone VARCHAR(15),
	email VARCHAR(120),
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (user_id),
	CONSTRAINT user_profiles_fk FOREIGN KEY (user_id) REFERENCES users(id)
);


-- Словарь типов объектов недвижимости
CREATE TABLE asset_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	asset_type VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

-- Таблица с объектами недвижимости
CREATE TABLE assets (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	user_id INT UNSIGNED NOT NULL,
	asset_type_id INT UNSIGNED NOT NULL,
	name VARCHAR(100),
	country VARCHAR(100),
	city VARCHAR(100),
	address VARCHAR(200),
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (id),
	CONSTRAINT assets_asset_type_id_fk FOREIGN KEY (asset_type_id) REFERENCES asset_types(id),
	CONSTRAINT assets_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)
);


-- Словарь типов документов
CREATE TABLE document_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	document_type VARCHAR(50) NOT NULL, 
	PRIMARY KEY (id)
);

-- Таблица с документами
CREATE TABLE documents (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	asset_id INT UNSIGNED NOT NULL,
	name VARCHAR(100),
	document_number VARCHAR(100),
	isser VARCHAR(200),
	issue_date DATE,
	document_type_id INT UNSIGNED,
	document_file VARCHAR(200) NOT NULL,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (id),
	CONSTRAINT documents_document_type_id_fk FOREIGN KEY (document_type_id) REFERENCES document_types(id),
	CONSTRAINT documents_asset_id_fk FOREIGN KEY (asset_id) REFERENCES assets(id)
);


-- Таблица с клиентами - арендаторами
CREATE TABLE IF NOT EXISTS clients (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
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
	PRIMARY KEY (id)
);


-- Словарь услуг, которые могут оказывать контрагенты
CREATE TABLE IF NOT EXISTS service_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	service_type VARCHAR(120),
	PRIMARY KEY (id)
);

-- Таблица с контрагентами
CREATE TABLE IF NOT EXISTS contractors (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(100) NOT NULL,
	country VARCHAR(100),
	city VARCHAR(100),
	address VARCHAR(200),
	phone VARCHAR(15),
	email VARCHAR(120),
	web_site VARCHAR(200),
	comment TEXT,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (id)
);

-- Таблица связи контрагентов с оказываемыми услугами
CREATE TABLE contractor_service_type_links (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	contractor_id INT UNSIGNED NOT NULL,
	service_type_id INT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY (contractor_id,service_type_id),
	CONSTRAINT contractors_service_types_links_contractor_id_fk FOREIGN KEY (contractor_id) REFERENCES contractors(id),
	CONSTRAINT contractors_service_types_links_service_type_id_fk FOREIGN KEY (service_type_id) REFERENCES service_types(id)
);



-- Словарь типов договоров договора
CREATE TABLE contract_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	contract_type VARCHAR(50) NOT NULL, 
	PRIMARY KEY (id)
);

-- Таблица с договорами
CREATE TABLE contracts (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name VARCHAR(200),
	contract_number VARCHAR(100),
	issue_date DATE NOT NULL,
	asset_id INT UNSIGNED NOT NULL,
	contract_type_id INT UNSIGNED NOT NULL,
	counterpart_id INT UNSIGNED NOT NULL,
	contract_file VARCHAR(200) NOT NULL,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (id),
	CONSTRAINT contracts_asset_id_fk FOREIGN KEY (asset_id) REFERENCES assets(id),
	CONSTRAINT contracts_contract_type_id_fk FOREIGN KEY (contract_type_id) REFERENCES contract_types(id)
);


-- Таблица со счетами
CREATE TABLE bills (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	bill_number VARCHAR(100),
	issue_date DATE NOT NULL,
	contract_id INT UNSIGNED NOT NULL,
	bill_amount DECIMAL(12,2),
	due_date DATE,
	comment VARCHAR(200),
	payment_date DATE,
	create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	delete_time DATETIME,
	PRIMARY KEY (id),
	CONSTRAINT bills_contract_id_fk FOREIGN KEY (contract_id) REFERENCES contracts(id)
);


CREATE TABLE  client_overdue_payments_log (
	log_entry_date DATE NOT NULL, 
	user_id INT UNSIGNED NOT NULL, 
	asset_id INT UNSIGNED NOT NULL, 
	bill_id INT UNSIGNED NOT NULL, 
	overdue_days INT,
	client_id INT UNSIGNED NOT NULL,
	client_name VARCHAR(201),
	PRIMARY KEY (log_entry_date, client_id, bill_id)
);
