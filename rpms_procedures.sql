DELIMITER //
-- Проверка правильности ссылки на вторую сторону в договорах
DROP TRIGGER IF EXISTS add_contract_dependencies_check //
CREATE TRIGGER add_contract_dependencies_check BEFORE INSERT ON contracts
FOR EACH ROW 
BEGIN
	IF NEW.contract_type_id = (SELECT id FROM contract_types ct WHERE contract_type = 'income')
		AND 
		NEW.counterpart_id NOT IN (SELECT id from clients)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		'Insert cancelled: counterpart_id for income contracts must reference clients.id';
	ELSEIF NEW.contract_type_id = (SELECT id FROM contract_types ct WHERE contract_type = 'expense')
		AND 
		NEW.counterpart_id NOT IN (SELECT id from contractor_service_type_links)
	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		'Insert cancelled: counterpart_id for expense contracts must reference contractor_service_type_links.id';
	 END IF;
END//
-- Проверка на наличие неоплаченных счетов. Функция возвращает колическтво
-- просроченных счетов по объекту
DROP FUNCTION IF EXISTS overdue_payments_count //
CREATE FUNCTION overdue_payments_count(input_client_id INT)
RETURNS INT READS SQL DATA
BEGIN
	DECLARE bill_count INT;
	SELECT count(b.id) INTO bill_count 
	FROM bills b INNER JOIN contracts c ON b.contract_id = c.id
		INNER JOIN contract_types ct ON ct.id =c.contract_type_id 
			AND ct.contract_type = 'expense'
		INNER JOIN assets a ON a.id = c.asset_id
			AND a.client_id = input_client_id
	WHERE b.due_date < CURRENT_DATE() AND b.payment_date is NULL;
	RETURN bill_count;
END//
-- Процедура собирает таблицу с фактами просрочки платежа клиентами 
DROP PROCEDURE IF EXISTS update_overdue_payments_log//
CREATE PROCEDURE update_overdue_payments_log()
BEGIN
	INSERT INTO client_overdue_payments_log
		(log_entry_date, user_id, asset_id, bill_id, overdue_days, client_id, client_name)
	SELECT 
		CURRENT_DATE() as log_entry_date,
		a.user_id,
		c.asset_id,
		b.id as bill_id,
		DATEDIFF(CURRENT_DATE(), b.due_date) as overdue_days,
		cli.id as client_id,
		CONCAT(cli.last_name, ' ', cli.first_name) as client_name
	FROM bills b INNER JOIN contracts c ON b.contract_id = c.id 
		INNER JOIN contract_types ct ON ct.id =c.contract_type_id 
			AND ct.contract_type = 'income'
		INNER JOIN clients cli ON c.counterpart_id = cli.id
		INNER JOIN assets a ON a.id = c.asset_id 
	WHERE b.due_date < CURRENT_DATE() AND b.payment_date is NULL;
END//
-- Процедура создает счета
DROP PROCEDURE IF EXISTS automatic_bill_issuer//
CREATE PROCEDURE automatic_bill_issuer()
BEGIN
	INSERT INTO bills (bill_number,issue_date,contract_id,bill_amount,due_date,comment)		
	SELECT
		CONCAT(c.name, ' ', c.contract_number ,' ',CURRENT_DATE()),
		CURRENT_DATE(),
		c.id,
		c.contract_amount,
		CURRENT_DATE() + INTERVAL 5 DAY,
		CONCAT('Asset: ', a.name ,'; Client: ', c2.last_name, ' ', c2.first_name )
	FROM contracts c 
		INNER JOIN clients c2 ON c2.id = c.counterpart_id
		INNER JOIN assets a ON c.asset_id =a.id 
	WHERE c.payment_day = DAYOFMONTH(CURRENT_DATE() + INTERVAL 5 DAY)
		AND c.contract_type_id = (SELECT id FROM contract_types ct WHERE contract_type = 'income'); 
END//
DELIMITER ;

	


