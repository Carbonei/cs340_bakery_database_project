-- Citation: queries are inspired by sample_data_manipultion.sql provided in Web Exploration module (link will be provided once Canvas access is restored)

--Customers Queries

--Select info used to display information on the Customers
SELECT Customers.customer_ID, Customers.first_name, Customers.last_name, Customers.email FROM Customers;

--Insert into Customers using form on /Customers page
INSERT INTO Customers (first_name, last_name, email) VALUES (:first_nameInput, :last_nameInput, :emailInput);

--Update Existing Customer  
UPDATE Customers SET first_name = :first_nameInput, last_name= :last_nameInput, email = :emailInput WHERE customer_ID= :customer_ID_from_drop_down_menu

--Delete Customer from database including all information associated with them
DELETE FROM Customers WHERE Customer_ID = :Customer_ID_selected_from_Customers_page

--Orders Quries

--Select used to display information on the Orders, the Customer who placed the order, and the location it was purchased from.
SELECT Orders.order_ID, Orders.order_cost, Orders.item_count, Customers.first_name, Customers.last_name, 
            Stores.location_name FROM Customers 
            LEFT JOIN Orders ON Customers.customer_ID = Orders.customer_ID
            LEFT JOIN Stores ON Orders.location_ID = Stores.location_ID;

--Select used to display location names in dropdown
SELECT Stores.location_name FROM Stores;

--Insert into Orders using form on /Customers page
INSERT INTO Orders (order_cost, item_cost, customer_ID, location_ID) VALUES (:order_costInput, :item_costInput, 
                    :(SELECT Customer_ID FROM Customers WHERE Customers.first_name = :first_name_from_dropdown_menu AND Customers.lastname = :last_name_from_dropdown_menu), 
                    :(SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu));

--Update Existing Order  
UPDATE Orders SET order_cost = :order_costInput, item_count = :item_countInput, location_ID = (SELECT location_ID FROM Stores WHERE Stores.location_name = :location_name_from_dropdown_menu) 
    WHERE order_ID= :order_ID_from_drop_down_menu

--Delete Customer from database including all information associated with them
DELETE FROM Orders WHERE order_ID = :order_ID_selected_from_Orders_page


