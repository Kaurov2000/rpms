-- users
CREATE INDEX users_login_idx ON users(login);

-- clients
CREATE INDEX clients_name_idx ON clients(last_name,first_name,middle_name);

-- contractors
CREATE INDEX contractors_name_idx ON contractors(name);
CREATE INDEX contractors_city_idx ON contractors(country,city);

-- assets
CREATE INDEX assets_name_idx ON assets(name);

-- contracts
CREATE INDEX contracts_counterpart_idx ON contracts(counterpart_id);
CREATE INDEX contracts_payment_day_idx ON contracts(payment_day);

-- bills
CREATE INDEX bills_due_date_idx ON bills(due_date);
