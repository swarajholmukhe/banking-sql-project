-- views.sql

-- Customer total balance across all accounts
CREATE OR REPLACE VIEW customer_portfolio AS
SELECT c.customer_id, c.name, SUM(a.balance) AS total_balance, MAX(t.txn_time) AS last_txn_time
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY c.customer_id, c.name;

-- Transaction features (night flag, large flag, hour bucket)
CREATE OR REPLACE VIEW v_txn_features AS
SELECT
  t.transaction_id,
  t.account_id,
  t.amount,
  t.txn_city,
  t.txn_time,
  (HOUR(t.txn_time) BETWEEN 0 AND 5) AS is_night,
  (t.amount > 500000.00) AS is_large,
  HOUR(t.txn_time) AS hour_of_day
FROM transactions t;
