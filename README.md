# Project Title: Crafting Cozy Bakery Database

## Authors: Asmita Narayanan and Isabel Carbonell

## Organization Summary: 

Crafting Cozy Bakery is an up-and-coming bakery located in Seattle, Washington. 
What started as a small mom-and-pop shop has now expanded to three different locations. Over the past year, 
sales increased 15 percent. With the growth of the business, the need for organization has also increased. 
Crafting Cozy offers customers a variety of baked goods, with their specialties including chocolate chip cookies, 
red velvet cupcakes, and bacon cheddar croissants. Crafting Cozy sells to individual customers and caters to events. 
They average $200,000 in revenue and 700 unique customers a year. The main purpose of the database is 
to keep track of revenue and clientele. The database also tracks the total number of transactions associated 
with each store to understand the location’s popularity and growth.

To support this the database uses a Customers entity, an Orders entity, a Stores entity, and an Items entity. 
To facilitate the many to many relationship between Orders and Items, an intersection table named Ordered_Items 
records which item belongs to which order and to facilitate the many to many relationship between Customers and 
Stores, an intersection table named Customer_Stores records which customer visits which store location. 

## Citations: 

### DDL.sql:
Date: 5/26/2026
Copied Adapted from sp_moviedb.sql in Project Step 4 Draft example code
referenced procedure beginning and end syntax and altered it to 
match our existing code

### DML.sql:
Date: 5/8/2026
Queries are adapted from sample_data_manipultaion.sql provided in 
Web Exploration module https://canvas.oregonstate.edu/courses/2042369/assignments/10464663?module_item_id=26640192

### app.js:
Date: 5/8/2026
Routes adapted from Web Exploration Canvas Module:
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

### pl.sql:
Citation for all procedures with an additional source used for sp_DeleteStore and sp_CreateItem:
Citation for all procedures:
Date: 06/06/2026
Copied AND Adapted from:
Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
(a.k.a. "Exploration - Implementing CUD operations in your app" Canvas module)

#### Citation for sp_DeleteStore
Date: 06/06/2026
Based on 
Source URL: https://m365.cloud.microsoft/
If AI tools were used: AI was used to figure out why the console (when deleting from table on website) 
was reporting a null location_ID to be deleted. No code was copied, but its advice to check 
naming inconsistencies helped me narrow down the root cause.
(Explain the use of tools and include a summary of the prompts submitted to the AI tool)

#### Citation for sp_CreateItem
Date: 06/06/2026
Based on
Source URL: https://m365.cloud.microsoft/
If AI tools were used: AI was used to figure out why the console (when inserting new record into 
table on website) was reporting that a foreign key constraint failed for location ID. No code was
copied, but its advice made me realize that I was sending just the location name and not the 
location ID from the database into the handlebars template.

#### main.hbs:
Date: 5/8/2026
Adapted from Web Exploration Module: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Customer_Stores.hbs:
Date: 5/8/2026
Adapted from Web Exploration Module: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Customers.hbs:
Date: 5/8/2026
Adapted from Web Exploration Module: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Items.hbs:
Date: 5/8/2026
Adapted from Web Exploration Module: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Ordered_Items.hbs:
Date: 5/8/2026
Adapted from Web Exploration Module: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Orders.hbs:
Date: 5/8/2026
Adapted from Web Exploration Module: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Stores.hbs:
Date: 5/8/2026
Adapted from Web Exploration Module: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Database-connector.js:
Date: 5/8/2026
Adapted from Web Exploration Module https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188
