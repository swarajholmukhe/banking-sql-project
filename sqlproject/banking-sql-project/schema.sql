-- schema.sql
-- MySQL 8.0+
-- Run: CREATE DATABASE bankdb; USE bankdb;

DROP TABLE IF EXISTS alerts;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS merchants;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(50),
    join_date DATETIME NOT NULL,
    last_login_time DATETIME
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_type ENUM('Savings','Current') NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    opened_on DATETIME NOT NULL,
    CONSTRAINT fk_accounts_customer
      FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
      ON DELETE CASCADE
);

CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    merchant_id INT NULL,
    txn_type ENUM('Deposit','Withdrawal','TransferOut','TransferIn','Interest') NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    txn_city VARCHAR(50) NOT NULL,
    transaction_channel ENUM('ATM','POS','Online') NOT NULL DEFAULT 'Online',
    txn_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_amount_positive CHECK (amount > 0),
    CONSTRAINT fk_txn_account
      FOREIGN KEY (account_id) REFERENCES accounts(account_id)
      ON DELETE CASCADE,
    CONSTRAINT fk_txn_merchant
      FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
      ON DELETE SET NULL
);

CREATE TABLE alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT NOT NULL,
    alert_reason VARCHAR(255) NOT NULL,
    alert_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alert_txn
      FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
      ON DELETE CASCADE
);
