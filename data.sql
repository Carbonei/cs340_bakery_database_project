SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

DROP TABLE IF EXISTS Ordered_Items;
DROP TABLE IF EXISTS Customer_Stores;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Items;

CREATE TABLE Customers (
    customer_ID int(11) NOT NULL AUTO_INCREMENT, 
    first_name varchar(50) NOT NULL, 
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    UNIQUE KEY (customer_ID),
    UNIQUE KEY (email), 
    PRIMARY KEY (customer_ID)
);

INSERT INTO Customers (first_name, last_name, email)
VALUES ('Taylor', 'Murray', 'murrayt@hello.com'),
('Jeremy', 'Grant', 'grantj@hello.com'),
('Kate', 'Whitaker', 'whitakate@hello.com');

CREATE TABLE Stores (
    location_ID int(11) NOT NULL AUTO_INCREMENT, 
    location_name varchar(50) NOT NULL, 
    total_transaction_count int(11) NOT NULL,
    UNIQUE KEY (location_ID),
    UNIQUE KEY (location_name),
    PRIMARY KEY (location_ID)
);

INSERT INTO Stores (location_name, total_transaction_count)
VALUES ('Maple Avenue', 200),
('Cedar Street', 250),
('Oak Place', 300);

CREATE TABLE Orders (
    order_ID int(11) NOT NULL AUTO_INCREMENT, 
    customer_ID int(11) NOT NULL,
    order_cost decimal(10, 2) NOT NULL,
    item_count int(11) NOT NULL,
    pickup date,
    location_ID int(11) NOT NULL,
    UNIQUE KEY (order_ID), 
    PRIMARY KEY (order_ID),
    FOREIGN KEY (customer_ID) REFERENCES Customers(customer_ID),
    FOREIGN KEY (location_ID) REFERENCES Stores(location_ID)
);

INSERT INTO Orders (customer_ID, order_cost, item_count, pickup, location_ID)
VALUES ((SELECT customer_ID FROM Customers WHERE first_name='Kate' AND last_name = 'Whitaker'), 5, 2, '2026-06-28', (SELECT location_ID FROM Stores WHERE location_name='Cedar Street')),
((SELECT customer_ID FROM Customers WHERE first_name='Taylor' AND last_name = 'Murray'), 6, 2, '2026-07-11', (SELECT location_ID FROM Stores WHERE location_name='Oak Place')),
((SELECT customer_ID FROM Customers WHERE first_name='Jeremy' AND last_name = 'Grant'), 3, 1, '2026-05-30', (SELECT location_ID FROM Stores WHERE location_name='Maple Avenue'));

CREATE TABLE Items (
    item_ID int(11) NOT NULL AUTO_INCREMENT, 
    item_cost decimal(10, 2) NOT NULL,
    item_name varchar(50) NOT NULL, 
    location_ID int(11) NOT NULL, 
    UNIQUE KEY (item_ID),
    PRIMARY KEY (item_ID),
    FOREIGN KEY (location_ID) REFERENCES Stores(location_ID)
);


INSERT INTO Items (item_cost, item_name, location_ID)
VALUES (2, 'Chocolate Chip Cookie', (SELECT location_ID FROM Stores WHERE location_name='Cedar Street')),
(3, 'Red Velvet Cupcake', (SELECT location_ID FROM Stores WHERE location_name='Maple Avenue')),
(4, 'Bacon Cheddar Croissant', (SELECT location_ID FROM Stores WHERE location_name='Oak Place')),
(2, 'Chocolate Chip Cookie', (SELECT location_ID FROM Stores WHERE location_name='Oak Place')),
(3, 'Red Velvet Cupcake', (SELECT location_ID FROM Stores WHERE location_name='Cedar Street'));

CREATE TABLE Ordered_Items (
    ordered_itemID int(11) NOT NULL AUTO_INCREMENT, 
    order_ID int(11) NOT NULL, 
    item_ID int(11) NOT NULL, 
    UNIQUE KEY (ordered_itemID),
    PRIMARY KEY (ordered_itemID),
    FOREIGN KEY (order_ID) REFERENCES Orders(order_ID),
    FOREIGN KEY (item_ID) REFERENCES Items(item_ID)
);

INSERT INTO Ordered_Items (order_ID, item_ID)
VALUES 
((SELECT order_ID FROM Orders WHERE customer_ID = 
        (SELECT customer_ID FROM Customers WHERE email = 'whitakate@hello.com') AND pickup = '2026-06-28'), 
        (SELECT item_ID FROM Items WHERE item_name = "Chocolate Chip Cookie" AND location_ID = 2)),
((SELECT order_ID FROM Orders WHERE customer_ID = 
        (SELECT customer_ID FROM Customers WHERE email = 'whitakate@hello.com') AND pickup = '2026-06-28'), 
        (SELECT item_ID FROM Items WHERE item_name = "Red Velvet Cupcake" AND location_ID = 2)),
((SELECT order_ID FROM Orders WHERE customer_ID = 
        (SELECT customer_ID FROM Customers WHERE email = 'murrayt@hello.com') AND pickup = '2026-07-11'),
        (SELECT item_ID FROM Items WHERE item_name = "Bacon Cheddar Croissant" AND location_ID = 3)),
((SELECT order_ID FROM Orders WHERE customer_ID = 
        (SELECT customer_ID FROM Customers WHERE email = 'murrayt@hello.com') AND pickup = '2026-07-11'), 
        (SELECT item_ID FROM Items WHERE item_name = "Chocolate Chip Cookie" AND location_ID = 3)),
((SELECT order_ID FROM Orders WHERE customer_ID = 
        (SELECT customer_ID FROM Customers WHERE email = 'grantj@hello.com') AND pickup = '2026-05-30'), 
        (SELECT item_ID FROM Items WHERE item_name = "Red Velvet Cupcake" AND location_ID = 1));

CREATE TABLE Customer_Stores (
    customer_storeID int(11) NOT NULL AUTO_INCREMENT,
    customer_ID int(11) NOT NULL,
    location_ID int(11) NOT NULL,
    UNIQUE KEY (customer_storeID),
    PRIMARY KEY (customer_storeID),
    FOREIGN KEY (customer_ID) REFERENCES Customers(customer_ID),
    FOREIGN KEY (location_ID) REFERENCES Stores(location_ID)
);

INSERT INTO Customer_Stores (customer_ID, location_ID)
VALUES ((SELECT customer_ID FROM Customers WHERE email = 'murrayt@hello.com'), (SELECT location_ID FROM Stores WHERE location_name='Oak Place')),
((SELECT customer_ID FROM Customers WHERE email = 'grantj@hello.com'), (SELECT location_ID FROM Stores WHERE location_name='Maple Avenue')),
((SELECT customer_ID FROM Customers WHERE email = 'whitakate@hello.com'), (SELECT location_ID FROM Stores WHERE location_name='Cedar Street')),
((SELECT customer_ID FROM Customers WHERE email = 'grantj@hello.com'), (SELECT location_ID FROM Stores WHERE location_name='Oak Place')),
((SELECT customer_ID FROM Customers WHERE email = 'murrayt@hello.com'), (SELECT location_ID FROM Stores WHERE location_name='Cedar Street'));