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
-- Проверка на наличие неоплаченных счетов. Функция возвращает id счета с самой
-- старой датой либо 0, если просроченных счетов по объекту нет
DROP FUNCTION IF EXISTS overdue_payments //
CREATE FUNCTION overdue_payments(input_asset_id INT)
RETURNS INT READS SQL DATA
BEGIN
	DECLARE bill_id INT;
	SELECT b.id INTO bill_id FROM bills b INNER JOIN contracts c 
		ON b.contract_id = c.id AND c.asset_id = input_asset_id
	WHERE b.due_date < CURRENT_DATE() AND b.payment_date is NULL
	ORDER BY b.issue_date LIMIT 1;
	RETURN coalesce(bill_id, 0);
END//
DELIMITER ;
