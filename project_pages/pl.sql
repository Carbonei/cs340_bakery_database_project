-- Citation for all procedures with an additional source used for sp_DeleteStore and sp_CreateItem:
-- Citation for all procedures:
-- Date: 06/06/2026
-- Copied, Adapted from Implementing CUD operations in your app Exploration Canvas module:
-- https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205

-- Citation for sp_DeleteStore
-- Date: 06/06/2026
-- Based on:
-- https://m365.cloud.microsoft/
-- AI was used to figure out why the console (when deleting from table on website) 
-- was reporting a null location_ID to be deleted. No code was copied, but its advice to check 
-- naming inconsistencies helped me narrow down the root cause.

-- Citation for sp_CreateItem
-- Date: 06/06/2026
-- Based on: 
-- https://m365.cloud.microsoft/
-- AI was used to figure out why the console (when inserting new record into table on website) was 
-- reporting that a foreign key constraint failed for location ID. No code was copied, but its advice 
-- made me realize that I was sending just the location name and not the location ID from the database 
-- into the handlebars template.

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
        DELETE FROM Orders WHERE order_ID = o_id;
      

        -- Executes if the input provided is an invalid order_ID (ROW_COUNT being 0 means no rows 
        -- were affected after executing above DELETE query)
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
        DELETE FROM Customers WHERE customer_ID = c_id;
      

        -- Executes if the input provided is an invalid customer_ID (ROW_COUNT being 0 means no rows 
        -- were affected after executing above DELETE query)
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Customers for id: ', c_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- DELETE Ordered_Item
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteOrderedItem;

DELIMITER //
CREATE PROCEDURE sp_DeleteOrderedItem(IN oi_id INT)
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
        DELETE FROM Ordered_Items WHERE ordered_itemID = oi_id;
      

        -- Executes if the input provided is an invalid ordered_itemID (ROW_COUNT being 0 means no rows 
        -- were affected after executing above DELETE query)
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Ordered Items for id: ', oi_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;

-- #############################
-- DELETE Store
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteStore;

DELIMITER //
CREATE PROCEDURE sp_DeleteStore(IN l_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
         DELETE FROM Stores WHERE location_ID = l_id;

        -- Executes if the input provided is an invalid location_ID (ROW_COUNT being 0 means no rows 
        -- were affected after executing above DELETE query)
         IF ROW_COUNT() = 0 THEN 
             SET error_message = CONCAT('No matching record found in Stores for location_id ', l_id);
             -- Trigger custom error, invoke EXIT HANDLER
             SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
         END IF;
         
    COMMIT;

END //
DELIMITER ;

-- #############################
-- DELETE Item
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteItem;

DELIMITER //
CREATE PROCEDURE sp_DeleteItem(IN i_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
         DELETE FROM Items WHERE item_ID = i_id;

        -- Executes if the input provided is an invalid item_ID (ROW_COUNT being 0 means no rows 
        -- were affected after executing above DELETE query)
         IF ROW_COUNT() = 0 THEN 
             SET error_message = CONCAT('No matching record found in Items for item_id ', i_id);
             -- Trigger custom error, invoke EXIT HANDLER
             SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
         END IF;
         
    COMMIT;

END //
DELIMITER ;

-- #############################
-- DELETE Customer_Store
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteCustomerStore;

DELIMITER //
CREATE PROCEDURE sp_DeleteCustomerStore(IN cs_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);

    -- error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rolls back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
         DELETE FROM Customer_Stores WHERE customer_storeID = cs_id;

        -- Executes if the input provided is an invalid customer_storeID (ROW_COUNT being 0 means no rows 
        -- were affected after executing above DELETE query)
         IF ROW_COUNT() = 0 THEN 
             SET error_message = CONCAT('No matching record found in Customer_Stores for customer_storeID ', cs_id);
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
    -- Display the ID of the last inserted customer.
    SELECT LAST_INSERT_ID() AS 'new_id';

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



-- #############################
-- CREATE Ordered Item
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateOrderedItem;

DELIMITER //
CREATE PROCEDURE sp_CreateOrderedItem(
    IN oi_order_ID INT, 
    IN oi_item_ID INT, 
    OUT oi_id INT)
BEGIN
    INSERT INTO Ordered_Items (order_ID, item_ID) 
    VALUES (oi_order_ID, oi_item_ID);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into oi_id;
    -- Display the ID of the last inserted item.
    SELECT LAST_INSERT_ID() AS 'new_id';

END //
DELIMITER ;

-- #############################
-- CREATE Store
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateStore;

DELIMITER //
CREATE PROCEDURE sp_CreateStore(
    IN s_location_name VARCHAR(50),
    IN s_total_transaction_count INT,
    OUT l_id INT
    )
BEGIN
    INSERT INTO Stores (location_name, total_transaction_count)
    VALUES (s_location_name, s_total_transaction_count);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into l_id;
    -- Display the ID of the last inserted location
    SELECT LAST_INSERT_ID() AS 'new_location_id';

END //
DELIMITER ;

-- #############################
-- CREATE Item
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateItem;

DELIMITER //
CREATE PROCEDURE sp_CreateItem(
    IN i_item_cost DECIMAL(10, 2),
    IN i_item_name VARCHAR(50),
    IN i_location_ID INT,
    OUT i_id INT
    )
BEGIN
    INSERT INTO Items (item_cost, item_name, location_ID)
    VALUES (i_item_cost, i_item_name, i_location_ID);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into i_id;
    -- Display the ID of the last inserted item
    SELECT LAST_INSERT_ID() AS 'new_item_id';

END //
DELIMITER ;

-- #############################
-- CREATE Customer_Store
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateCustomerStore;

DELIMITER //
CREATE PROCEDURE sp_CreateCustomerStore(
    IN cs_customer_ID INT,
    IN cs_location_ID INT,
    OUT cs_id INT
    )
BEGIN
    INSERT INTO Customer_Stores (customer_ID, location_ID)
    VALUES (cs_customer_ID, cs_location_ID);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into cs_id;
    -- Display the ID of the last inserted item
    SELECT LAST_INSERT_ID() AS 'new_cs_id';

END //
DELIMITER ;

-- #############################
-- UPDATE Order
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateOrder;

DELIMITER //
CREATE PROCEDURE sp_UpdateOrder(IN o_id INT, IN o_order_cost DECIMAL(10, 2), IN o_item_count INT, IN o_pickup DATE, IN o_location_ID INT)

BEGIN
    UPDATE Orders SET order_cost = o_order_cost, item_count = o_item_count, pickup = o_pickup, location_ID = o_location_ID WHERE order_ID = o_id; 
END //
DELIMITER ;



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


-- #############################
-- UPDATE Ordered Item
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateOrderedItem;

DELIMITER //
CREATE PROCEDURE sp_UpdateOrderedItem(IN oi_id INT, IN oi_order INT, IN oi_item INT)

BEGIN
    UPDATE Ordered_Items SET order_ID = oi_order, item_ID = oi_item WHERE ordered_itemID = oi_id; 
END //
DELIMITER ;

-- #############################
-- UPDATE Store
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateStore;

DELIMITER //
CREATE PROCEDURE sp_UpdateStore(IN s_location_id INT, IN s_location_name VARCHAR(50), IN s_total_transaction_count INT)

BEGIN
    UPDATE Stores SET location_name = s_location_name, total_transaction_count = s_total_transaction_count WHERE location_ID = s_location_id; 
END //
DELIMITER ;

-- #############################
-- UPDATE Item
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateItem;

DELIMITER //
CREATE PROCEDURE sp_UpdateItem(IN i_item_id INT, IN i_item_cost DECIMAL(10, 2), IN i_item_name VARCHAR(50), IN i_location_ID INT)

BEGIN
    UPDATE Items SET item_cost = i_item_cost, item_name = i_item_name, location_ID = i_location_ID WHERE item_ID = i_item_id; 
END //
DELIMITER ;

-- #############################
-- UPDATE Customer_Store
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateCustomerStore;

DELIMITER //
CREATE PROCEDURE sp_UpdateCustomerStore(IN cs_id INT, IN cs_customer_id INT, IN cs_location_id INT)

BEGIN
    UPDATE Customer_Stores SET customer_ID = cs_customer_id, location_ID = cs_location_id WHERE customer_StoreID = cs_id; 
END //
DELIMITER ;