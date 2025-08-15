-- procedures.sql
DELIMITER //

-- Apply monthly interest to a Savings account.
-- annual_rate_percent: e.g., 6.00 means 6% per year
CREATE PROCEDURE apply_monthly_interest(IN p_account_id INT, IN annual_rate_percent DECIMAL(5,2))
BEGIN
    DECLARE acct_type ENUM('Savings','Current');
    DECLARE curr_balance DECIMAL(15,2);
    DECLARE monthly_rate DECIMAL(10,6);
    DECLARE interest_amt DECIMAL(15,2);

    SELECT account_type, balance INTO acct_type, curr_balance
    FROM accounts WHERE account_id = p_account_id FOR UPDATE;

    IF acct_type IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account not found';
    END IF;

    IF acct_type <> 'Savings' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Interest applies to Savings accounts only';
    END IF;

    SET monthly_rate = (annual_rate_percent / 12.0) / 100.0;
    SET interest_amt = ROUND(curr_balance * monthly_rate, 2);

    -- Record interest as a transaction (type 'Interest'); triggers will update balance
    INSERT INTO transactions(account_id, merchant_id, txn_type, amount, txn_city, transaction_channel, txn_time)
    VALUES (p_account_id, NULL, 'Interest', interest_amt, 'Online', 'Online', NOW());
END;
//

-- Transfer funds between two accounts atomically
CREATE PROCEDURE transfer_funds(IN p_from INT, IN p_to INT, IN p_amount DECIMAL(15,2))
BEGIN
    IF p_from = p_to THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Source and destination account must differ';
    END IF;

    START TRANSACTION;

    -- Debit source (TransferOut) - BEFORE trigger will validate funds
    INSERT INTO transactions(account_id, merchant_id, txn_type, amount, txn_city, transaction_channel, txn_time)
    VALUES (p_from, NULL, 'TransferOut', p_amount, 'Online', 'Online', NOW());

    -- Credit destination (TransferIn)
    INSERT INTO transactions(account_id, merchant_id, txn_type, amount, txn_city, transaction_channel, txn_time)
    VALUES (p_to, NULL, 'TransferIn', p_amount, 'Online', 'Online', NOW());

    COMMIT;
END;
//

DELIMITER ;
