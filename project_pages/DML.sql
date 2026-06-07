-- Citation: queries are inspired by sample_data_manipultaion.sql provided in Web Exploration module https://canvas.oregonstate.edu/courses/2042369/assignments/10464663?module_item_id=26640192

-- Customers Queries

--Select info used to display information on the Customers
SELECT Customers.customer_ID, Customers.first_name, Customers.last_name, Customers.email FROM Customers;

--Insert into Customers using form on /Customers page
INSERT INTO Customers (first_name, last_name, email) VALUES (:first_nameInput, :last_nameInput, :emailInput);

-- Update Existing Customer  
UPDATE Customers SET first_name = :first_nameInput, last_name= :last_nameInput, email = :emailInput WHERE customer_ID= :customer_ID_from_drop_down_menu;

--Delete Customer from database including all information associated with them
DELETE FROM Customers WHERE Customer_ID = :Customer_ID_selected_from_Customers_page;

-- Stores Queries

--Select info used to display information on the Stores
SELECT Stores.location_ID, Stores.location_name, Stores.total_transaction_count FROM Stores;

--Insert into Stores in the following order on /Stores page
INSERT INTO Stores (location_name, total_transaction_count) VALUES (:location_nameInput, :total_transaction_countInput);

--Update existing store
UPDATE Stores SET location_name = :location_nameInput, total_transaction_count = :total_transaction_countInput WHERE location_ID= :location_ID_from_drop_down_menu;

--Deletes a Store from database including all information associated with it
DELETE FROM Stores WHERE Location_ID = :location_ID_selected_from_Stores_page;

-- Orders Queries

--Select used to display information on the Orders, the Customer who placed the order, and the location it was purchased from.
SELECT Orders.order_ID, Orders.order_cost, Orders.item_count, Orders.pickup AS pickup_date, Customers.first_name, Customers.last_name, 
            Stores.location_name FROM Customers 
            LEFT JOIN Orders ON Customers.customer_ID = Orders.customer_ID
            LEFT JOIN Stores ON Orders.location_ID = Stores.location_ID;

--Select used to display location names in dropdown
SELECT Stores.location_name FROM Stores;

--Insert into Orders using form on /Orders page
INSERT INTO Orders (order_cost, item_count, pickup, customer_ID, location_ID) VALUES (:order_costInput, :item_countInput, :pickupInput, 
                    (SELECT Customer_ID FROM Customers WHERE Customers.first_name = :first_name_from_dropdown_menu AND Customers.last_name = :last_name_from_dropdown_menu), 
                    (SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu));

--Update Existing Order  
UPDATE Orders SET order_cost = :order_costInput, item_count = :item_countInput, pickup = :pickupInput, location_ID = (SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu) 
    WHERE order_ID= :order_ID_from_drop_down_menu;

--Delete Order from database including all information associated with them
DELETE FROM Orders WHERE order_ID = :order_ID_selected_from_Orders_page;

-- Items Queries

--Select info used to display information on the Items
SELECT Items.item_ID, Items.item_cost, Items.item_name, 
        Stores.location_name FROM Items
        LEFT JOIN Stores on Items.location_ID = Stores.location_ID;

--Used to display the location names in dropdown
SELECT Stores.location_name FROM Stores;

--Insert into Items in the following order on /Items page
INSERT INTO Items (item_cost, item_name, location_ID) VALUES (:item_costInput, :item_nameInput, 
                    (SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu));

--Update existing Item
UPDATE Items SET item_cost = :item_costInput, item_name = :item_nameInput, location_ID = (SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu)
    WHERE item_ID = :item_ID_from_drop_down_menu;

--Deletes an Item from database including all information associated with it
DELETE FROM Items WHERE item_ID = :item_ID_selected_from_Items_page;

-- Customer_Stores Queries

--Select info used to display information on Customer_Stores
SELECT Customer_Stores.customer_storeID, Customer_Stores.customer_ID, Customers.first_name, Customers.last_name, Customer_Stores.location_ID, Stores.location_name FROM Customer_Stores
    LEFT JOIN Customers on Customer_Stores.customer_ID = Customers.customer_ID
    LEFT JOIN Stores on Customer_Stores.location_ID = Stores.location_ID;

--Used to display the customer IDs in dropdown
SELECT Customers.customer_ID FROM Customers;

--Used to display the location IDs in dropdown
SELECT Stores.location_ID FROM Stores;

--Inserts a new Customer_Store into Customer_Stores table
INSERT INTO Customer_Stores (customer_ID, location_ID) VALUES ((SELECT customer_ID FROM Customers WHERE Customers.customer_ID = :customerID_from_dropdown_menu),  
                    (SELECT location_ID FROM Stores WHERE Stores.location_ID = :locationID_from_dropdown_menu));

--Update Existing Customer_Store  
UPDATE Customer_Stores SET customer_ID = (SELECT customer_ID FROM Customers WHERE Customers.customer_ID = :customerID_from_dropdown_menu), location_ID = (SELECT location_ID FROM Stores WHERE Stores.location_ID = :locationID_from_dropdown_menu) 
    WHERE customer_storeID = :customer_storeID_from_drop_down_menu;

--Deletes a Customer_Store
DELETE FROM Customer_Stores WHERE customer_storeID = :customer_storeID_selected_from_Customer_Stores_page;

-- Ordered_Items Queries

--Select info used to display information on Ordered_Items
SELECT Ordered_Items.ordered_itemID, Orders.order_ID, Items.item_name, Items.item_cost, Orders.order_cost
        FROM Orders
        LEFT JOIN 
            Ordered_Items ON Orders.order_ID = Ordered_Items.order_ID
        LEFT JOIN 
            Items ON Ordered_Items.item_ID = Items.item_ID;

--Used to display the item IDs in dropdown
SELECT Items.item_id FROM Items;

--Insert into Ordered Items with a new ordered Item
INSERT INTO Ordered_Items (order_ID, item_ID) VALUES (:order_ID_from_drop_down_menu, :item_ID_from_drop_down_menu);

-- Delete an ordered item
DELETE FROM Ordered_Items WHERE ordered_itemID = :ordered_itemID_selected_from_Ordered_Items_page;

--Update an Ordered Item
UPDATE Ordered_Items SET order_ID = :order_ID_from_drop_down_menu, item_ID = :item_ID_from_drop_down_menu
    WHERE ordered_itemID = :ordered_itemID_from_drop_down_menu;