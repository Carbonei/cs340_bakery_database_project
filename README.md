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
Based on, adapted from sp_moviedb.sql in Project Step 4 Draft example code: 
https://canvas.oregonstate.edu/courses/2042369/assignments/10464666
Referenced procedure beginning and end syntax and altered it to 
match our existing code

### DML.sql:
Date: 5/8/2026\
Based on Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 \
Below queries are inspired by sample_data_manipultaion.sql from source.

### app.js:

#### All app.post('/<entity_name>/<CRUD_op_type>', async function (req, res): 
Date: 5/8/2026\
Adapted from Implementing CUD operations in your app Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205

#### All app.get('/<entity_name>/:id', async function (req, res):
Date: 6/8/2026\
Copied, Adapted from:\
AI Source URL: https://copilot.microsoft.com/conversations/join/4RwnCEkWuu6YMEjs7zxrW \
Prompts used to generate prepopulation of non-primary attributes when primary key\
is selected for update route. Current update form and update route was provided to copilot. 

#### All other source code: 
Date: 5/8/2026\
Based on Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188

### pl.sql:
Citation for all procedures with an additional source used for sp_DeleteStore and sp_CreateItem:\
Citation for all procedures:\
Date: 06/06/2026\
Copied, Adapted from Implementing CUD operations in your app Exploration Canvas module:
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205

#### Citation for sp_DeleteStore
Date: 06/06/2026\
Based on:
https://m365.cloud.microsoft/  
AI was used to figure out why the console (when deleting from table on website)\
was reporting a null location_ID to be deleted. No code was copied, but its advice to check\
naming inconsistencies helped me narrow down the root cause.

#### Citation for sp_CreateItem
Date: 06/06/2026\
Based on:\
https://m365.cloud.microsoft/
AI was used to figure out why the console (when inserting new record into table on website) was 
reporting that a foreign key constraint failed for location ID. No code was copied, but its advice 
made me realize that I was sending just the location name and not the location ID from the database 
into the handlebars template.

#### main.hbs:
##### Citation for structure:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

##### Citation for fonts:
Date: 05/20/2026\
Copied from Google fonts for CSS display fonts:\
https://fonts.google.com/

#### Customer_Stores.hbs:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Customers.hbs:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

##### Citation for <script> content:
Date: 6/8/2026\
Copied, Adapted from:\
AI Source URL: https://copilot.microsoft.com/conversations/join/4RwnCEkWuu6YMEjs7zxrW  
Prompts used to generate prepopulation of non-primary attributes when primary key\
is selected for update route. Current update form and update route was provided to copilot.

#### Items.hbs:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

##### Citation for <script> content:
Date: 6/8/2026\
Copied, Adapted from:\
AI Source URL: https://copilot.microsoft.com/conversations/join/4RwnCEkWuu6YMEjs7zxrW  
Prompts used to generate prepopulation of non-primary attributes when primary key\
is selected for update route. Current update form and update route was provided to copilot.

#### Ordered_Items.hbs:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

#### Orders.hbs:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 

##### Citation for <script> content:
Date: 6/8/2026\
Copied, Adapted from:\
AI Source URL: https://copilot.microsoft.com/conversations/join/4RwnCEkWuu6YMEjs7zxrW  
Prompts used to generate prepopulation of non-primary attributes when primary key\
is selected for update route. Current update form and update route was provided to copilot.

#### Stores.hbs:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188 
##### Citation for <script> content:
Date: 6/8/2026\
Copied, Adapted from:\
AI Source URL: https://copilot.microsoft.com/conversations/join/4RwnCEkWuu6YMEjs7zxrW  
Prompts used to generate prepopulation of non-primary attributes when primary key\
is selected for update route. Current update form and update route was provided to copilot.

#### database/db-connector.js:
Date: 5/8/2026\
Adapted from Web Application Technology Exploration Canvas module:\
https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188

#### style.css
 Date: 05/20/2026 
 Copied from Google fonts for CSS display fonts: 
 https://fonts.google.com/