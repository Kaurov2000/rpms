-- Отчет о доходах и расходах пользователя

(SELECT DISTINCT
	asset_name,
	sum(IF(contract_type='income',bill_amount,0)) OVER (PARTITION BY asset_id) as asset_income,
	sum(IF(contract_type='expense',bill_amount,0)) OVER (PARTITION BY asset_id) as asset_expenses,
	sum(IF(contract_type='expense',bill_amount * -1,bill_amount)) OVER (PARTITION BY asset_id) as asset_balance
FROM asset_bills 
WHERE user_id = 11
ORDER BY asset_id)
UNION ALL 
(SELECT DISTINCT
	'total' as asset_name,
	sum(IF(contract_type='income',bill_amount,0)) OVER () as asset_income,
	sum(IF(contract_type='expense',bill_amount,0)) OVER () as asset_expenses,
	sum(IF(contract_type='expense',bill_amount * -1,bill_amount)) OVER () as asset_balance
FROM asset_bills 
WHERE user_id = 11
ORDER BY asset_id);



