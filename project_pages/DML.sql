-- Citation: queries are inspired by sample_data_manipultaion.sql provided in Web Exploration module (link will be provided once Canvas access is restored)

--Customers Queries

--Select info used to display information on the Customers
SELECT Customers.customer_ID, Customers.first_name, Customers.last_name, Customers.email FROM Customers;

--Insert into Customers using form on /Customers page
INSERT INTO Customers (first_name, last_name, email) VALUES (:first_nameInput, :last_nameInput, :emailInput);

--Update Existing Customer  
UPDATE Customers SET first_name = :first_nameInput, last_name= :last_nameInput, email = :emailInput WHERE customer_ID= :customer_ID_from_drop_down_menu

--Delete Customer from database including all information associated with them
DELETE FROM Customers WHERE Customer_ID = :Customer_ID_selected_from_Customers_page

--Stores Queries

--Select info used to display information on the Stores
SELECT Stores.location_ID, Stores.location_name, Stores.total_transaction_count FROM Stores;

--Insert into Stores in the following order on /Stores page
INSERT INTO Stores (location_name, total_transaction_count) VALUES (:location_nameInput, :total_transaction_countInput);

--Update existing store
UPDATE Stores SET location_name = :location_nameInput, total_transaction_count = :total_transaction_countInput WHERE location_ID= :location_ID_from_drop_down_menu

--Deletes a Store from database including all information associated with it
DELETE FROM Stores WHERE Location_ID = :location_ID_selected_from_Stores_page

--Orders Queries

--Select used to display information on the Orders, the Customer who placed the order, and the location it was purchased from.
SELECT Orders.order_ID, Orders.order_cost, Orders.item_count, Customers.first_name, Customers.last_name, 
            Stores.location_name FROM Customers 
            LEFT JOIN Orders ON Customers.customer_ID = Orders.customer_ID
            LEFT JOIN Stores ON Orders.location_ID = Stores.location_ID;

--Select used to display location names in dropdown
SELECT Stores.location_name FROM Stores;

--Insert into Orders using form on /Orders page
INSERT INTO Orders (order_cost, item_cost, customer_ID, location_ID) VALUES (:order_costInput, :item_costInput, :pickupInput, 
                    :(SELECT Customer_ID FROM Customers WHERE Customers.first_name = :first_name_from_dropdown_menu AND Customers.lastname = :last_name_from_dropdown_menu), 
                    :(SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu));

--Update Existing Order  
UPDATE Orders SET order_cost = :order_costInput, item_count = :item_countInput, :pickup = pickupInput, location_ID = (SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu) 
    WHERE order_ID= :order_ID_from_drop_down_menu

--Delete Order from database including all information associated with them
DELETE FROM Orders WHERE order_ID = :order_ID_selected_from_Orders_page

--Select info used to display information on the Stores
SELECT Items.item_ID, Items.item_cost, Items.item_name, 
        Stores.location_name FROM Items
        LEFT JOIN Stores on Items.location_ID = Stores.location_ID;

--Used to display the location names in dropdown
SELECT Stores.location_name FROM Stores;

--Insert into Items in the following order on /Items page
INSERT INTO Items (item_cost, item_name, location_ID) VALUES (:item_costInput, :item_nameInput, 
                    :(SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu));

--Update existing item
UPDATE Items SET item_cost = :item_costInput, item_name = :item_nameInput, location_ID = (SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu)
    WHERE item_ID = :item_ID_from_drop_down_menu

--Deletes an Item from database including all information associated with it
DELETE FROM Items WHERE item_ID = :item_ID_selected_from_Items_page;

SELECT Customer_Stores.customer_storeID, Customer_Stores.customer_ID, Customer_Stores.store_ID FROM Customer_Stores
    LEFT JOIN Customers on Customer_Stores.customer_ID = Customers.customer_ID
    LEFT JOIN Stores on Customer_Stores.location_ID = Stores.location_ID;

INSERT INTO Customer_Stores (customer_ID, location_ID) VALUES (:(SELECT customer_ID FROM Customers WHERE Customers.customer_ID = :customerID_from_dropdown_menu),  
                    :(SELECT location_ID FROM Stores WHERE Stores.location_ID = :locationID_from_dropdown_menu));

--Update Existing Order  
UPDATE Customer_Stores SET customer_ID = (SELECT customer_ID FROM Customers WHERE Customers.customer_ID = :customerID_from_dropdown_menu), location_ID = (SELECT location_ID FROM Stores WHERE Stores.location_ID = :locationID_from_dropdown_menu) 
    WHERE customer_storeID = :customer_storeID_from_drop_down_menu

DELETE FROM Customer_Stores WHERE customer_storeID = :customer_storeID_selected_from_Items_page;