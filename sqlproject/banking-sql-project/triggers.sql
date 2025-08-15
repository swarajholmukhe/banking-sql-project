-- triggers.sql
DELIMITER //

-- BEFORE INSERT: validate amounts and auto-fill txn_city from merchant if missing
CREATE TRIGGER trg_txn_before_insert
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE acc_balance DECIMAL(15,2);

    -- If merchant is provided but txn_city is empty, use merchant city
    IF NEW.merchant_id IS NOT NULL AND (NEW.txn_city IS NULL OR NEW.txn_city = '') THEN
        SELECT city INTO @mcity FROM merchants WHERE merchant_id = NEW.merchant_id;
        IF @mcity IS NOT NULL THEN
            SET NEW.txn_city = @mcity;
        END IF;
    END IF;

    -- Ensure positive amount
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount must be positive';
    END IF;

    -- For withdrawal/transfer-out, ensure sufficient funds
    IF NEW.txn_type IN ('Withdrawal','TransferOut') THEN
        SELECT balance INTO acc_balance FROM accounts WHERE account_id = NEW.account_id FOR UPDATE;
        IF acc_balance IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account not found';
        END IF;
        IF acc_balance < NEW.amount THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds';
        END IF;
    END IF;
END;
//

-- AFTER INSERT: update account balance
CREATE TRIGGER trg_txn_after_insert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.txn_type IN ('Deposit','TransferIn','Interest') THEN
        UPDATE accounts SET balance = balance + NEW.amount WHERE account_id = NEW.account_id;
    ELSEIF NEW.txn_type IN ('Withdrawal','TransferOut') THEN
        UPDATE accounts SET balance = balance - NEW.amount WHERE account_id = NEW.account_id;
    END IF;
END;
//

DELIMITER ;
