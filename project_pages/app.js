// ########################################
// ########## SETUP

//Citation: based on Web Exploration Canvas Module


// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 1268;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/Customers', async function (req, res) {
    try {
        // Create and execute our queries      
        const query1 = `SELECT Customers.customer_ID, Customers.first_name, Customers.last_name, Customers.email FROM Customers;`;
        const [Customers] = await db.query(query1);
        

        
        res.render('Customers', { Customers: Customers}); 
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Orders', async function (req, res) {
    try {
        const query1 = `SELECT Orders.order_ID, Orders.order_cost, Orders.item_count, Orders.pickup, Customers.first_name, Customers.last_name, \
            Stores.location_name FROM Customers \

            LEFT JOIN Orders ON Customers.customer_ID = Orders.customer_ID
            LEFT JOIN Stores ON Orders.location_ID = Stores.location_ID;`;
            
       
        const [Orders] = await db.query(query1);
        const query2 = 'SELECT Stores.location_name FROM Stores;';
        const [locations] = await db.query(query2);

        res.render('Orders', { Orders: Orders, locations:locations});
            } catch (error) {
                console.error('Error executing queries:', error);
                // Send a generic error message to the browser
                res.status(500).send(
                    'An error occurred while executing the database queries.'
                );
            }
});

app.get('/Stores', async function (req, res) {
    try {
        
        // Define our queries
        const query1 = `SELECT Stores.location_ID, Stores.location_name, Stores.total_transaction_count FROM Stores;`;
        
        const [Stores] = await db.query(query1); // Store the results
        
        // Send the results to the browser
        res.render('Stores', { Stores: Stores});
    } catch (error) {
        console.error("Error executing queries:", error);

        // Send a generic error message to the browser
        res.status(500).send("An error occurred while executing the database queries.");
    }
});
        
app.get('/Items', async function (req, res) {
    try {
        const query1 = `SELECT Items.item_ID, Items.item_cost, Items.item_name, Stores.location_name FROM Items
            LEFT JOIN Stores ON Items.location_ID = Stores.location_ID;`;
            
        const [Items] = await db.query(query1);
        const query2 = 'SELECT Stores.location_name FROM Stores;';
            
        const [locations] = await db.query(query2);
      
        res.render('Items', { Items: Items, locations:locations});
            } catch (error) {
                console.error('Error executing queries:', error);
                // Send a generic error message to the browser
                res.status(500).send(
                    'An error occurred while executing the database queries.'
                );
            }
});

app.get('/Customer_Stores', async function (req, res) {
    try {
        const query1 = `SELECT Customer_Stores.customer_storeID, Customer_Stores.customer_ID, Customers.first_name, Customers.last_name, Customer_Stores.location_ID, Stores.location_name FROM Customer_Stores
            LEFT JOIN Customers ON Customer_Stores.customer_ID = Customers.customer_ID
            LEFT JOIN Stores ON Customer_Stores.location_ID = Stores.location_ID;`;
        const [Customer_Stores] = await db.query(query1);
        const query2 = 'SELECT Customers.customer_ID FROM Customers;';
        const [customers] = await db.query(query2);
        const query3 = 'SELECT Stores.location_ID FROM Stores;';
        const [locations] = await db.query(query3);

        res.render('Customer_Stores', { Customer_Stores: Customer_Stores, customers:customers, locations:locations});
            } catch (error) {
                console.error('Error executing queries:', error);
                // Send a generic error message to the browser
                res.status(500).send(
                    'An error occurred while executing the database queries.'
                );
            }
});

app.get('/Ordered_Items', async function (req, res) {
    try {
        const query1 = `SELECT Ordered_Items.ordered_itemID, Orders.order_ID, Items.item_name, Items.item_cost, Orders.order_cost
        FROM Orders
        LEFT JOIN 
            Ordered_Items ON Orders.order_ID = Ordered_Items.order_ID
        LEFT JOIN 
            Items ON Ordered_Items.item_ID = Items.item_ID;`;
            
       
        const [Ordered_Items] = await db.query(query1);
        const query2 = 'SELECT Items.item_id FROM Items;';
       
        const [item] = await db.query(query2);
        //console.log("Ordered")
        //console.log(Ordered_Items)
        //console.log("item")
        //console.log(item)
        res.render('Ordered_Items', { Ordered_Items: Ordered_Items, item: item});
            } catch (error) {
                console.error('Error executing queries:', error);
                // Send a generic error message to the browser
                res.status(500).send(
                    'An error occurred while executing the database queries.'
                );
            }
});




// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});
