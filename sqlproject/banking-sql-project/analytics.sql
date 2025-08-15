-- analytics.sql

-- Top merchants by total spent
CREATE OR REPLACE VIEW top_merchants AS
SELECT m.name, m.category, SUM(t.amount) AS total_spent
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
GROUP BY m.name, m.category
ORDER BY total_spent DESC
LIMIT 10;

-- Monthly total transaction amounts
CREATE OR REPLACE VIEW monthly_totals AS
SELECT DATE_FORMAT(txn_time, '%Y-%m') AS month, SUM(amount) AS total_amount
FROM transactions
GROUP BY month
ORDER BY month;

-- Top customers by portfolio balance
CREATE OR REPLACE VIEW top_customers_by_balance AS
SELECT c.customer_id, c.name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_balance DESC
LIMIT 10;
