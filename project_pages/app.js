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
        const query1 = `SELECT Orders.order_ID, Orders.order_cost, Orders.item_count, Orders.pickup AS pickup_date, Customers.first_name, Customers.last_name, \
            Stores.location_name FROM Orders \

            LEFT JOIN Customers ON Orders.customer_ID = Customers.customer_ID
            LEFT JOIN Stores ON Orders.location_ID = Stores.location_ID;`;
            
       
        const [Orders] = await db.query(query1);
        const query2 = 'SELECT Stores.location_name FROM Stores;';
        const [locations] = await db.query(query2);
        console.log("test");
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

// reset orders ROUTES
app.post('/Orders/reset', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_load_bakerydb();`;

      
        await db.query(query1);

        console.log(`Reset`);

        // Redirect the user to the updated webpage
        res.redirect('/Orders');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// reset Stores ROUTES
app.post('/Stores/reset', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_load_bakerydb();`;

      
        await db.query(query1);

        console.log(`Reset`);

        // Redirect the user to the updated webpage
        res.redirect('/Stores');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// reset Customers ROUTES
app.post('/Customers/reset', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_load_bakerydb();`;

      
        await db.query(query1);

        console.log(`Reset`);

        // Redirect the user to the updated webpage
        res.redirect('/Customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// reset Customer_Stores ROUTES
app.post('/Customer_Stores/reset', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_load_bakerydb();`;

      
        await db.query(query1);

        console.log(`Reset`);

        // Redirect the user to the updated webpage
        res.redirect('/Customer_Stores');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// reset Ordered_Items ROUTES
app.post('/Ordered_Items/reset', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_load_bakerydb();`;

      
        await db.query(query1);

        console.log(`Reset`);

        // Redirect the user to the updated webpage
        res.redirect('/Ordered_Items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// reset Items ROUTES
app.post('/Items/reset', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_load_bakerydb();`;

      
        await db.query(query1);

        console.log(`Reset`);

        // Redirect the user to the updated webpage
        res.redirect('/Items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

//-- Citation for the following code:
//-- Date: 5/26/2026
// Adapted from "Exploration - Implementing CUD operations in your app" 
//  example code
// -- referenced procedure beginning and end syntax and altered it to 
// -- match our existing code


// DELETE ROUTES
app.post('/Orders/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log(data);
        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteOrder(?);`;
        await db.query(query1, [data.delete_order_id]);

        console.log(`DELETE Order. ID: ${data.delete_order_id} ` +
            `Name: ${data.delete_order_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Orders');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});



// DELETE Customers ROUTES
app.post('/Customers/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
        console.log(data);
        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteCustomer(?);`;
        await db.query(query1, [data.delete_customer_id]);

        console.log(`DELETE Customer. ID: ${data.delete_customer_id} ` +
            `Name: ${data.delete_customer_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// Create Order Route
// CREATE ROUTES
app.post('/Orders/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        console.log("Customer ID received:", req.body.create_order_customer_ID);
        console.log("Location ID received:", req.body.create_order_location_ID);

        // Cleanse data - If the homeworld or age aren't numbers, make them NULL.

        //probably doesn't work*********
        if (isNaN(parseInt(data.create_order_pickup)))
            data.create_order_pickup = null;

        


        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateOrder( ?, ?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_order_customer_ID,
            data.create_order_cost,
            data.create_order_item_count,
            data.create_order_pickup,
            data.create_order_location_ID,
        ]);

        console.log(`CREATE Order ID: ${rows.new_id} ` +
            `Name: ${data.create_order_customer_ID} `
        );

        // Redirect the user to the updated webpage
        res.redirect('/Orders');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});




// CREATE Customer ROUTE
app.post('/Customers/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateCustomer(?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_customer_first_name,
            data.create_customer_last_name,
            data.create_customer_email,
        ]);

        console.log(`CREATE Customer ID: ${rows.new_id} ` +
            `Name: ${data.create_person_first_name} ${data.create_person_last_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/Customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


//Update Customer Route
app.post('/Customers/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateCustomer(?, ?, ?, ?);';
        const query2 = 'SELECT first_name, last_name, email FROM Customers WHERE customer_ID = ?;';
        await db.query(query1, [
            data.update_customer_id,
            data.update_customer_first_name,
            data.update_customer_last_name,
            data.update_customer_email,
        ]);
        const [[rows]] = await db.query(query2, [data.update_customer_id]);

        console.log(`UPDATE Customers. ID: ${data.update_customer_id} ` +
            `Name: ${rows.last_name} ${rows.first_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Customers');
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
