-- Представление с активами всех польователей
DROP VIEW IF EXISTS users_assets;
CREATE VIEW users_assets AS
SELECT 
	u.id as user_id,
	a.id as asset_id,
	a.asset_type_id,
	ast.asset_type,
	a.name,
	a.country,
	a.city,
	a.address
FROM users u INNER JOIN assets a ON u.id = a.user_id 
	INNER JOIN asset_types ast ON a.asset_type_id = ast.id
ORDER BY user_id;
	
-- Представление со всеми расчетами по активам
DROP VIEW IF EXISTS assets_bills;
CREATE VIEW assets_bills AS
SELECT
	a.id as asset_id,
	ct.contract_type ,
	c.name as contract_name,
	b.id as bill_id,
	b.issue_date,
	b.bill_amount,
	b.due_date,
	b.payment_date 
FROM assets a LEFT JOIN contracts c ON a.id = c.asset_id
	INNER JOIN contract_types ct ON c.contract_type_id = ct.id 
	LEFT JOIN bills b ON b.contract_id = c.id
ORDER BY asset_id, issue_date;


-- Представление "Расчеты с арендаторами"
DROP VIEW IF EXISTS client_bills;
CREATE VIEW client_bills AS
SELECT
	a.id as asset_id,
	cl.first_name,
	cl.last_name,
	b.id as bill_id,
	b.issue_date,
	b.bill_amount,
	b.due_date,
	b.payment_date 
FROM assets a LEFT JOIN contracts c ON a.id = c.asset_id 
	AND c.contract_type_id = 
		(SELECT ct.id FROM contract_types ct WHERE ct.contract_type = 'income')
 	LEFT JOIN clients cl ON cl.id = c.counterpart_id 
	LEFT JOIN bills b ON b.contract_id = c.id
ORDER BY asset_id, last_name, issue_date;

-- Представление "Расчеты с поставщиками услуг"
SELECT 
	a.id as asset_id,
	b.id as bill_id,
	st.service_type,
	cn.name as contractor,
	b.issue_date,
	b.bill_amount,
	b.due_date,
	b.payment_date 
FROM assets a LEFT JOIN contracts c ON a.id = c.asset_id 
	AND c.contract_type_id = 
		(SELECT ct.id FROM contract_types ct WHERE ct.contract_type = 'expense')
 	LEFT JOIN (contractor_service_type_links cs
 			INNER JOIN service_types st ON st.id = cs.service_type_id) 
 		ON cs.id = c.counterpart_id 
	LEFT JOIN contractors cn ON cn.id = cs.id 
 	LEFT JOIN bills b ON b.contract_id = c.id
ORDER BY asset_id, contractor, issue_date;

SELECT * from bills where id = 612;
select * from contracts c where id = 303;
select * from contractor_service_type_links cstl;






