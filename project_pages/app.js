// ########################################
// ########## SETUP

//Citation: based on Web Exploration Canvas Module

//{{! Citation for use of AI Tools:
//      # Date: 6/8/2026
//      # Prompts used to generate prepopulation of non-primary attributes when primary key 
//      # is selected for update route. Current update form and update route was provided to copilot.
//      # AI Source URL: https://copilot.microsoft.com/conversations/join/4RwnCEkWuu6YMEjs7zxrW }}

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
        const query2 = 'SELECT Stores.location_ID, Stores.location_name FROM Stores;';
        const [locations] = await db.query(query2);
        const query3 = 'SELECT Customers.first_name, Customers.last_name, Customers.customer_ID FROM Customers;';
        const [customers] = await db.query(query3);
        //console.log("test");
        res.render('Orders', { Orders: Orders, locations:locations, customers:customers});
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
        const query2 = 'SELECT Stores.location_ID, Stores.location_name FROM Stores;';
            
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
        const query2 = 'SELECT Customers.customer_ID, Customers.first_name, Customers.last_name FROM Customers;';
        const [customers] = await db.query(query2);
        const query3 = 'SELECT Stores.location_ID, Stores.location_name FROM Stores;';
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
        FROM Ordered_Items
        LEFT JOIN 
            Orders ON Orders.order_ID = Ordered_Items.order_ID
        LEFT JOIN 
            Items ON Ordered_Items.item_ID = Items.item_ID;`;
       
        const [Ordered_Items] = await db.query(query1);

        const query2 = `SELECT Items.item_id, Stores.location_name, Items.item_name FROM Items
            LEFT JOIN 
                Stores ON Items.location_ID = Stores.location_ID;`;
       
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

// DELETE Ordered Item ROUTES
app.post('/Ordered_Items/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteOrderedItem(?);`;
        await db.query(query1, [data.delete_ordered_itemID]);

        console.log(`DELETE Ordered_Items. ID: ${data.delete_ordered_itemID} ` 
           
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Ordered_Items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// DELETE Stores ROUTES
app.post('/Stores/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_DeleteStore(?);`;
        // Sends in the delete_location_id value as the argument for sp_DeleteStore()
        await db.query(query1, [data.delete_location_id]);

        console.log(`DELETE Store. ID: ${data.delete_location_id} ` +
            `Location name: ${data.delete_location_name} ` +
            `Total transaction count: ${data.delete_transaction_count}`
        );

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

// DELETE Items ROUTES
app.post('/Items/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_DeleteItem(?);`;
        // Sends in the delete_item_id value as the argument for sp_DeleteItem()
        await db.query(query1, [data.delete_item_id]);

        console.log(`DELETE Item. ID: ${data.delete_item_id} ` +
            `Item cost: ${data.delete_item_cost} ` +
            `Item name: ${data.delete_item_name} ` +
            `Location name: ${data.delete_location_name}`
        );

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

// DELETE Customer_Stores ROUTES
app.post('/Customer_Stores/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;
       
        const query1 = `CALL sp_DeleteCustomerStore(?);`;
        // Sends in the delete_customer_store_id value as the argument for sp_DeleteCustomerStore()
        await db.query(query1, [data.delete_customer_store_id]);

        console.log(`DELETE Customer_Store. ID: ${data.delete_customer_store_id} ` +
            `Customer ID: ${data.delete_customer_store_customerID} ` +
            `Customer Full Name: ${data.delete_customer_store_customer_fname} ${data.delete_customer_store_customer_lname} ` +
            `Location ID: ${data.delete_customer_store_locationID} ` +
            `Location name: ${data.delete_customer_store_location_name}`
        );

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

// CREATE ROUTES

// Create Order Route

app.post('/Orders/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        console.log("Customer ID received:", req.body.create_order_customer_ID);
        console.log("Location ID received:", req.body.create_order_location_ID);

        // Cleanse data - If the homeworld or age aren't numbers, make them NULL.

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

// CREATE Ordered_Item ROUTE
app.post('/Ordered_Items/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateOrderedItem(?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_ordered_items_orderID,
            data.create_ordered_items_id,
        ]);

        console.log(`CREATE ordered item ID: ${rows.new_id} ` 
           
        );

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

// CREATE Store ROUTE
app.post('/Stores/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateStore(?, ?, @new_location_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_location_name,
            data.create_transaction_count
        ]);

        console.log(`CREATE Store. ID: ${rows.new_location_id} ` +
            `Location name: ${data.create_location_name} ` +
            `Total transaction count: ${data.create_transaction_count}`
        );

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

// CREATE Item ROUTE
app.post('/Items/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateItem(?, ?, ?, @new_item_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_item_cost,
            data.create_item_name,
            data.create_item_location_id
        ]);

        console.log(`CREATE Item. ID: ${rows.new_item_id} ` +
            `Item cost: ${data.create_item_cost} ` +
            `Item name: ${data.create_item_name} ` +
            `Location ID: ${data.create_item_location_id}`
        );

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

app.post('/Customer_Stores/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateCustomerStore(?, ?, @new_cs_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_customer_store_customerID,
            data.create_customer_store_locationID
        ]);

        console.log(`CREATE Customer_Store. ID: ${rows.new_cs_id} ` +
            `Customer ID: ${data.create_customer_store_customerID} ` +
            `Location ID: ${data.create_customer_store_locationID}`
        );

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

//Update Routes

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



// UPDATE Order ROUTE
app.post('/Orders/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Cleanse data - If the homeworld or age aren't numbers, make them NULL.
        //if (isNaN((data.update_order_pickup)))
          //  data.update_order_pickup = null;
       

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateOrder(?, ?, ?, ?, ?);';
        const query2 = 'SELECT order_ID, order_cost, item_count, pickup, location_ID FROM Orders WHERE order_ID = ?;';
        await db.query(query1, [
            data.update_order_id,
            data.update_order_cost,
            data.update_order_item_count,
            data.update_order_pickup,
            data.update_order_location_ID,
        ]);
        const [[rows]] = await db.query(query2, [data.update_order_id]);

        console.log(`UPDATE Order ID: ${data.update_order_id} ` 
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


// UPDATE Order ROUTE
app.post('/Ordered_Items/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;
       

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateOrderedItem(?, ?, ?);';
        const query2 = 'SELECT  order_ID, item_ID FROM Ordered_Items WHERE ordered_itemID = ?;';
        await db.query(query1, [
            data.update_ordered_itemID,
            data.update_order_id,
            data.update_item_id,

        ]);
        const [[rows]] = await db.query(query2, [data.update_order_id]);

        console.log(`UPDATE Ordered Item ID: ${data.update_order_id} ` 
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Ordered_Items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// UPDATE Store ROUTE
app.post('/Stores/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateStore(?, ?, ?);';
        const query2 = 'SELECT location_name, total_transaction_count FROM Stores WHERE location_ID = ?;';
        await db.query(query1, [
            data.update_location_id,
            data.update_location_name,
            data.update_transaction_count
        ]);
        const [[rows]] = await db.query(query2, [data.update_location_id]);

        console.log(`UPDATE Stores. ID: ${data.update_location_id} ` +
            `Location name: ${rows.location_name} ` +
            `Total transaction count: ${rows.total_transaction_count}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Stores');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// UPDATE Item ROUTE
app.post('/Items/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateItem(?, ?, ?, ?);';
        const query2 = 'SELECT item_cost, item_name, location_ID FROM Items WHERE item_ID = ?;';
        await db.query(query1, [
            data.update_item_id,
            data.update_item_cost,
            data.update_item_name,
            data.update_item_location_id
        ]);
        const [[rows]] = await db.query(query2, [data.update_item_id]);

        console.log(`UPDATE Items. ID: ${data.update_item_id} ` +
            `Item cost: ${rows.item_cost} ` +
            `Item name: ${rows.item_name} ` +
            `Location ID: ${rows.location_ID}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Items');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// UPDATE Customer_Store ROUTE
app.post('/Customer_Stores/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateCustomerStore(?, ?, ?);';
        const query2 = 'SELECT customer_ID, location_ID FROM Customer_Stores WHERE customer_StoreID = ?;';
        await db.query(query1, [
            data.update_customer_store_id,
            data.update_customer_store_customerID,
            data.update_customer_store_locationID
        ]);
        const [[rows]] = await db.query(query2, [data.update_customer_store_id]);

        console.log(`UPDATE Items. ID: ${data.update_customer_store_id} ` +
            `Customer ID: ${rows.customer_ID} ` +
            `Location ID: ${rows.location_ID}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Customer_Stores');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});


// Fetch one customer's data 
app.get('/Customers/:id', async function (req, res) {
    try {
        const customerID = req.params.id;
        const [rows] = await db.query(
            'SELECT first_name, last_name, email FROM Customers WHERE customer_ID = ?',
            [customerID]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Customer not found' });
        }

        res.json(rows[0]);
    } catch (error) {
        console.error('Error fetching customer:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

//get one order data
app.get('/Orders/:id', async function (req, res) {
    try {
        const order_ID = req.params.id;
        const [rows] = await db.query(
            'SELECT order_cost, item_count, pickup, location_ID FROM Orders WHERE order_ID = ?',
            [order_ID]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Order not found' });
        }

        res.json(rows[0]);
    } catch (error) {
        console.error('Error fetching Order:', error);
        res.status(500).json({ error: 'Server error' });
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
