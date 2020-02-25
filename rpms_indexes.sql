-- users
CREATE INDEX users_login_idx ON users(login);

-- clients
CREATE INDEX clients_id_idx ON clients(client_id);
CREATE INDEX clients_name_idx ON clients(last_name,first_name,middle_name);

-- contractors
CREATE INDEX contractors_id_idx ON contractors(contractor_id);
CREATE INDEX contractors_name_idx ON contractors(name);
CREATE INDEX contractors_city_idx ON contractors(country,city);

-- assets
CREATE INDEX assets_id_idx ON assets(asset_id);

-- contracts
CREATE INDEX contracts_id_idx ON contracts(contract_id);
CREATE INDEX contracts_counterpart_idx ON contracts(counterpart_id,counterpart_type_id);

-- documents
CREATE INDEX documents_document_subject_idx ON documents(document_subject_id,document_type_id);
