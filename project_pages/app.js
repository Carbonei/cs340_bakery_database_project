// ########################################
// ########## SETUP

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
        // In query1, we use a JOIN clause to display the names of the homeworlds
       /*
        const query1 = `SELECT Customers.customer_ID, Customers.first_name, Customers.last_name, Customers.email, \
            Stores.location_name AS 'Stores', Stores.location_ID FROM Customers \

            LEFT JOIN Customer_Stores ON Customers.customer_ID = Customer_Stores.customer_ID
            LEFT JOIN Stores ON Customer_Stores.location_ID = Stores.location_ID;`;
     */
        const query1 = `SELECT Customers.customer_ID, Customers.first_name, Customers.last_name, Customers.email FROM Customers;`;
            
        //const query2 = 'SELECT * FROM Stores;';
        const [Customers] = await db.query(query1);
        //const [Stores] = await db.query(query2);

        // Render the Customers.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('Customers', { Customers: Customers});//, Stores: Stores 
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
        const query1 = `SELECT Orders.order_ID, Orders.order_cost, Orders.item_count, Customers.first_name, Customers.last_name, \
            Stores.location_name FROM Customers \

            LEFT JOIN Orders ON Customers.customer_ID = Orders.customer_ID
            LEFT JOIN Stores ON Orders.location_ID = Stores.location_ID;`;
            
       
        const [Orders] = await db.query(query1);
        const query2 = 'SELECT Stores.location_name FROM Stores;';
            
        const [locations] = await db.query(query2);
      

        // Render the bsg-people.hbs file, and also send the renderer
        //  an object that contains our bsg_people and bsg_homeworld information
        res.render('Orders', { Orders: Orders, locations:locations});
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
