-- seed.sql
-- Minimal sample data (expand as needed)

INSERT INTO customers (name, email, city, join_date, last_login_time) VALUES
('Amit Sharma', 'amit@example.com', 'Mumbai', '2023-02-15 10:00:00', '2024-12-01 08:15:00'),
('Priya Singh', 'priya@example.com', 'Delhi', '2022-08-10 12:00:00', '2025-01-12 21:30:00'),
('Raj Patel', 'raj@example.com', 'Bengaluru', '2024-03-05 09:30:00', '2025-02-01 10:05:00');

INSERT INTO accounts (customer_id, account_type, balance, opened_on) VALUES
(1, 'Savings', 100000.00, '2023-02-16 09:00:00'),
(1, 'Current',  25000.00, '2024-04-05 14:00:00'),
(2, 'Savings', 250000.00, '2022-08-15 11:00:00'),
(3, 'Savings',  50000.00, '2024-03-06 10:00:00');

INSERT INTO merchants (name, city, category) VALUES
('Reliance Fresh', 'Mumbai', 'Groceries'),
('Taj Hotels', 'Delhi', 'Hospitality'),
('Indigo Airlines', 'Bengaluru', 'Travel');

-- Transactions: some withdrawals at odd hours, deposits, and cross-city activity
INSERT INTO transactions (account_id, merchant_id, txn_type, amount, txn_city, transaction_channel, txn_time) VALUES
(1, 1, 'Withdrawal', 50000.00, 'Mumbai', 'POS', '2024-01-10 23:45:00'),
(1, 2, 'Withdrawal', 20000.00, 'Delhi', 'POS', '2024-01-11 00:15:00'),
(2, NULL, 'Deposit', 100000.00, 'Delhi', 'Online', '2024-01-12 10:30:00'),
(3, 3, 'Withdrawal', 700000.00, 'Bengaluru', 'POS', '2024-02-01 02:20:00'),
(4, NULL, 'Deposit', 15000.00, 'Bengaluru', 'Online', '2024-02-03 09:05:00');
