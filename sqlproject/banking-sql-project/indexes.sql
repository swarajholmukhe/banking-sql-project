-- indexes.sql
CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);
CREATE INDEX idx_txn_account_time ON transactions(account_id, txn_time);
CREATE INDEX idx_txn_city_time ON transactions(txn_city, txn_time);
CREATE INDEX idx_txn_merchant ON transactions(merchant_id);
