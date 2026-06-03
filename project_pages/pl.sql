-- Citation for the following code:
-- Copied Adapted from Exploration - Implementing CUD operations in your app
-- match our existing code

-- #############################
-- DELETE order
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteOrder;

DELIMITER //
CREATE PROCEDURE sp_DeleteOrder(IN o_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both bsg_people table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM Orders WHERE order_ID = o_id;
      

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Orders for id: ', o_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- DELETE Customer
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteCustomer;

DELIMITER //
CREATE PROCEDURE sp_DeleteCustomer(IN c_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both bsg_people table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM Customers WHERE customer_ID = c_id;
      

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Customers for id: ', c_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;




-- #############################
-- CREATE Customer
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateCustomer;

DELIMITER //
CREATE PROCEDURE sp_CreateCustomer(
    
    IN c_first_name VARCHAR(50), 
    IN c_last_name VARCHAR(50), 
    IN c_email VARCHAR(50), 
    
    OUT c_id INT)
BEGIN
    INSERT INTO Customers ( first_name, last_name, email) 
    VALUES ( c_first_name, c_last_name, c_email);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into c_id;
    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'new_id';

    -- Example of how to get the ID of the newly created person:
        -- CALL sp_CreatePerson('Theresa', 'Evans', 2, 48, @new_id);
        -- SELECT @new_id AS 'New Person ID';
END //
DELIMITER ;




-- #############################
-- CREATE Order
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateOrder;

DELIMITER //
CREATE PROCEDURE sp_CreateOrder(
    IN o_customer_ID INT(11), 
    IN o_order_cost DECIMAL(10, 2), 
    IN o_item_count INT(11),
    IN o_pickup DATE,
    IN o_location_ID INT(11),
    OUT o_id INT)
BEGIN
    INSERT INTO Orders ( customer_ID, order_cost, item_count, pickup, location_ID) 
    VALUES ( o_customer_ID, o_order_cost, o_item_count, o_pickup, o_location_ID);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into o_id;
    -- Display the ID of the last inserted order.
    SELECT LAST_INSERT_ID() AS 'new_id';

    
END //
DELIMITER ;

-- Example of how to get the ID of the newly created person:
        -- CALL sp_CreatePerson('Theresa', 'Evans', 2, 48, @new_id);
        -- SELECT @new_id AS 'New Person ID';



-- #############################
-- UPDATE Customer
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateCustomer;

DELIMITER //
CREATE PROCEDURE sp_UpdateCustomer(IN c_id INT, IN c_first_name VARCHAR(50), IN c_last_name VARCHAR(50), IN c_email VARCHAR(50))

BEGIN
    UPDATE Customers SET first_name = c_first_name, last_name = c_last_name, email = c_email WHERE customer_ID = c_id; 
END //
DELIMITER ;