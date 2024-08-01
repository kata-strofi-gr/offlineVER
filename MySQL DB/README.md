# Disaster Relief Management System

This project is a disaster relief management system designed to streamline the process of managing resources and requests during a disaster. It includes a MySQL database schema, stored procedures, triggers, and test data to support a PHP-based web application.

## Database Schema

The database schema is defined in `db_schema.sql` and includes the following tables:

- `Administrator`: Stores information about system administrators.
- `Rescuer`: Stores information about rescuers who handle requests.
- `Citizen`: Stores information about citizens who can make requests and offers.
- `Items`: Stores information about items available for requests and offers.
- `Warehouse`: Manages item quantities in the warehouse.
- `Requests`: Manages requests made by citizens for specific items.
- `Offers`: Manages offers made by citizens to provide specific items.
- `Vehicles`: Manages vehicles assigned to rescuers for delivering items.
- `Announcements`: Stores announcements made by administrators.
- `RequestLogs` and `OfferLogs`: Track the history of requests and offers.

## Stored Procedures and Triggers

The `Procedures_Trigers.sql` file contains stored procedures and triggers, including:

### Stored Procedures

1. **CreateRequest**
   - **Usage:** Create a new request.
   - **Parameters:** 
     - `p_CitizenID INT`: ID of the citizen making the request.
     - `p_Item VARCHAR(100)`: Name of the item requested.
     - `p_Quantity INT`: Quantity of the item requested.
   - **Description:** Inserts a new request into the `Requests` table with a status of 'Pending'.

2. **CreateOffer**
   - **Usage:** Create a new offer.
   - **Parameters:**
     - `p_CitizenID INT`: ID of the citizen making the offer.
     - `p_Item VARCHAR(100)`: Name of the item offered.
     - `p_Quantity INT`: Quantity of the item offered.
   - **Description:** Inserts a new offer into the `Offers` table with a status of 'Pending'.

3. **AssignRequest**
   - **Usage:** Assign a request to a rescuer.
   - **Parameters:**
     - `p_RequestID INT`: ID of the request to be assigned.
     - `p_RescuerID INT`: ID of the rescuer to whom the request is assigned.
   - **Description:** Updates the `Requests` table to assign a rescuer and change the status to 'INPROGRESS'.

4. **AssignOffer**
   - **Usage:** Assign an offer to a rescuer.
   - **Parameters:**
     - `p_OfferID INT`: ID of the offer to be assigned.
     - `p_RescuerID INT`: ID of the rescuer to whom the offer is assigned.
   - **Description:** Updates the `Offers` table to assign a rescuer and change the status to 'INPROGRESS'.

5. **ChangeRequestStatus**
   - **Usage:** Change the status of a request.
   - **Parameters:**
     - `p_RequestID INT`: ID of the request whose status is to be changed.
     - `p_Status VARCHAR(20)`: New status of the request.
   - **Description:** Updates the status of a request. If the status is 'PENDING', the rescuer assignment and date are reset.

6. **ChangeOfferStatus**
   - **Usage:** Change the status of an offer.
   - **Parameters:**
     - `p_OfferID INT`: ID of the offer whose status is to be changed.
     - `p_Status VARCHAR(20)`: New status of the offer.
   - **Description:** Updates the status of an offer. If the status is 'PENDING', the rescuer assignment and date are reset.

### Triggers

1. **check_warehouse_before_assign_request**
   - **Description:** Before assigning a request, checks if there are enough items in the warehouse. If not, an error is raised.

2. **log_requests_changes**
   - **Description:** After updating a request, logs the change into the `RequestLogs` table.

3. **log_offers_changes**
   - **Description:** After updating an offer, logs the change into the `OfferLogs` table.

4. **prevent_rescuer_task_overload**
   - **Description:** Before updating a request, checks if the rescuer has reached their task limit (4 tasks). If so, an error is raised.

5. **prevent_rescuer_task_overload_offers**
   - **Description:** Before updating an offer, checks if the rescuer has reached their task limit (4 tasks). If so, an error is raised.

## Test Data

The `test_data.sql` file provides sample data to populate the database for testing purposes. It includes sample administrators, rescuers, citizens, items, requests, offers, vehicles, and announcements.

## How to Use

1. **Setup Database:**
   - Create a new MySQL database.
   - Run `db_schema.sql` to create the database schema.
   - Run `Procedures_Trigers.sql` to add the stored procedures and triggers.
   - Run `test_data.sql` to populate the database with sample data.

2. **Configure PHP Application:**
   - Update the database connection settings in your PHP application to connect to the MySQL database.
   - Use the provided database schema and procedures to handle requests, offers, and other operations in the application.

3. **API Integration:**
   - Create PHP scripts to interact with the database using the defined schema and procedures.
   - Implement API endpoints to manage disaster relief operations, such as creating requests, assigning rescuers, updating statuses, and more.

## Example API Endpoints

- `POST /api/requests`: Create a new request.
- `POST /api/offers`: Create a new offer.
- `GET /api/requests`: Retrieve a list of requests.
- `GET /api/offers`: Retrieve a list of offers.
- `PUT /api/requests/:id/assign`: Assign a request to a rescuer.
- `PUT /api/requests/:id/status`: Update the status of a request.
