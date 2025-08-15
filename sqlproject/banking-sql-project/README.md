# Banking Transaction & Fraud Detection Database (Level 2)

A compact, finance-themed SQL project that manages customers, accounts, merchants, and transactions; 
automates balance updates; and flags suspicious activity via fraud rules. Built for MySQL 8.0+.

## ✨ Highlights
- Core tables: `customers`, `accounts`, `merchants`, `transactions`, `alerts`
- **Triggers** to auto-update balances
- **Stored procedures** for monthly interest & transfers
- **Fraud rules**: large amounts, night transactions, velocity, impossible travel
- **Indexes** for performance
- **Views** for portfolios & features
- Easy to seed and run locally

> Works on MySQL 8.0+. You can adapt to PostgreSQL by replacing a few MySQL-specific bits (ENUM, DELIMITER, TIMESTAMPDIFF/HOUR).

---

## 🗂️ Project Structure
```
banking-sql-project/
├── schema.sql
├── seed.sql
├── indexes.sql
├── views.sql
├── triggers.sql
├── procedures.sql
├── fraud_queries.sql
├── analytics.sql
├── docs/
│   └── ERD.md   # Mermaid ER diagram (renders on GitHub)
└── README.md
```

---

## 🛠️ Setup (Step-by-step)

### 1) Install tools
- **MySQL 8.0+** (Workbench optional)
- **Git** (and a GitHub account)

### 2) Create a database
```sql
-- Run this once in your MySQL client/terminal
CREATE DATABASE bankdb;
```

### 3) Run the SQL files in order
From the project folder in your terminal:
```bash
# Windows PowerShell / macOS / Linux (replace root/password as needed)
mysql -u root -p bankdb < schema.sql
mysql -u root -p bankdb < seed.sql
mysql -u root -p bankdb < indexes.sql
mysql -u root -p bankdb < triggers.sql
mysql -u root -p bankdb < procedures.sql
mysql -u root -p bankdb < views.sql
mysql -u root -p bankdb < fraud_queries.sql  # optional to test queries
mysql -u root -p bankdb < analytics.sql      # optional analytics queries
```

### 4) Quick functional test
```sql
-- Check balances & portfolio
SELECT * FROM accounts;
SELECT * FROM customer_portfolio;

-- Try a transfer (from procedures.sql)
CALL transfer_funds(1, 2, 5000.00);

-- Apply monthly interest on account 1 at 6% annual rate
CALL apply_monthly_interest(1, 6.00);

-- Run a fraud check (query only)
SELECT * FROM fraud_large_txn;
SELECT * FROM fraud_night_txn;
SELECT * FROM fraud_impossible_travel;
```

### 5) Export a CSV (one example using mysql client)
```bash
# Example: monthly totals into a CSV
mysql -u root -p -e "USE bankdb; SELECT DATE_FORMAT(txn_time, '%Y-%m') AS month, SUM(amount) AS total FROM transactions GROUP BY month ORDER BY month;" > monthly_totals.csv
```

---

## 🧭 ER Diagram (Mermaid)
See **docs/ERD.md** (renders on GitHub).

---

## 📌 Notes
- `transactions.txn_type` values: `Deposit`, `Withdrawal`, `TransferOut`, `TransferIn`, `Interest`
- `transaction_channel`: `ATM`, `POS`, `Online`
- Triggers ensure balances update and block insufficient withdrawals/transfers via `SIGNAL`.
- You can expand `seed.sql` with more rows or generate synthetic data later.

---

## 🧪 What to show in interviews
- Triggers, stored procedures, and a transfer demo
- A fraud rule query with explanation
- An EXPLAIN plan before/after adding an index
- The ER diagram and a portfolio view screenshot

---

## 📝 License
MIT
