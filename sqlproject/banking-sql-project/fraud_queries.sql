-- fraud_queries.sql

-- 1) Large transactions (> ₹5L)
CREATE OR REPLACE VIEW fraud_large_txn AS
SELECT t.transaction_id, t.account_id, t.amount, t.txn_time, t.txn_city
FROM transactions t
WHERE t.amount > 500000.00;

-- 2) Night transactions (00:00 to 05:59)
CREATE OR REPLACE VIEW fraud_night_txn AS
SELECT t.transaction_id, t.account_id, t.amount, t.txn_time, t.txn_city
FROM transactions t
WHERE HOUR(t.txn_time) BETWEEN 0 AND 5;

-- 3) Velocity: 3+ transactions within 10 minutes for the same account
-- Uses a self-join window approximation
CREATE OR REPLACE VIEW fraud_velocity_txn AS
SELECT t1.transaction_id, t1.account_id, t1.txn_time, t1.amount,
       COUNT(t2.transaction_id) AS txns_in_10m
FROM transactions t1
JOIN transactions t2
  ON t1.account_id = t2.account_id
 AND t2.txn_time BETWEEN DATE_SUB(t1.txn_time, INTERVAL 10 MINUTE) AND t1.txn_time
GROUP BY t1.transaction_id, t1.account_id, t1.txn_time, t1.amount
HAVING txns_in_10m >= 3;

-- 4) Impossible travel: same account in different cities within 60 minutes
CREATE OR REPLACE VIEW fraud_impossible_travel AS
SELECT t1.transaction_id AS txn1, t2.transaction_id AS txn2, t1.account_id,
       t1.txn_city AS city1, t2.txn_city AS city2,
       TIMESTAMPDIFF(MINUTE, t1.txn_time, t2.txn_time) AS minutes_diff
FROM transactions t1
JOIN transactions t2
  ON t1.account_id = t2.account_id
 AND t2.transaction_id > t1.transaction_id
WHERE t1.txn_city <> t2.txn_city
  AND ABS(TIMESTAMPDIFF(MINUTE, t1.txn_time, t2.txn_time)) <= 60;
