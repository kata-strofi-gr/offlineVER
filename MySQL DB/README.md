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
- `RequestItems`: Manages the items and quantities associated with each request.
- `Offers`: Manages offers made by citizens to provide specific items.
- `OfferItems`: Manages the items and quantities associated with each offer.
- `Vehicles`: Manages vehicles assigned to rescuers for delivering items.
- `VehicleItems`: Manages the items and quantities associated with each vehicle.
- `Announcements`: Stores announcements made by administrators.
- `AnnouncementItems`: Manages the items and quantities associated with each announcement.
- `RequestHistory`: Tracks the history of requests.
- `OfferHistory`: Tracks the history of offers.

## Stored Procedures and Triggers

The `Procedures_Trigers.sql` file contains stored procedures and triggers, including:

### Stored Procedures

1. **CreateNewRequest**
   - **Usage:** Create a new request using item names.
   - **Parameters:** 
     - `citizenID INT`: ID of the citizen making the request.
     - `items JSON`: JSON array of items and their quantities.
     - `status ENUM('PENDING', 'INPROGRESS', 'FINISHED')`: Status of the request.
   - **Description:** Inserts a new request into the `Requests` table and its associated items into the `RequestItems` table.

2. **CreateNewOffer**
   - **Usage:** Create a new offer using item names.
   - **Parameters:** 
     - `citizenID INT`: ID of the citizen making the offer.
     - `items JSON`: JSON array of items and their quantities.
     - `status ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED')`: Status of the offer.
   - **Description:** Inserts a new offer into the `Offers` table and its associated items into the `OfferItems` table.

3. **CreateNewRescuer**
   - **Usage:** Create a new rescuer.
   - **Parameters:**
     - `username VARCHAR(50)`: Username of the rescuer.
     - `password VARCHAR(255)`: Password of the rescuer.
     - `latitude DECIMAL(10, 8)`: Latitude of the rescuer's location.
     - `longitude DECIMAL(11, 8)`: Longitude of the rescuer's location.
   - **Description:** Inserts a new rescuer into the `Rescuer` table.

4. **CreateNewCitizen**
   - **Usage:** Create a new citizen.
   - **Parameters:**
     - `username VARCHAR(50)`: Username of the citizen.
     - `password VARCHAR(255)`: Password of the citizen.
     - `name VARCHAR(100)`: Name of the citizen.
     - `phone VARCHAR(15)`: Phone number of the citizen.
     - `latitude DECIMAL(10, 8)`: Latitude of the citizen's location.
     - `longitude DECIMAL(11, 8)`: Longitude of the citizen's location.
   - **Description:** Inserts a new citizen into the `Citizen` table.

5. **AssignRequestToRescuer**
   - **Usage:** Assign a request to a rescuer.
   - **Parameters:**
     - `requestID INT`: ID of the request.
     - `rescuerID INT`: ID of the rescuer.
   - **Description:** Updates the request with the rescuer's ID and changes the status to 'INPROGRESS'.

6. **AssignOfferToRescuer**
   - **Usage:** Assign an offer to a rescuer.
   - **Parameters:**
     - `offerID INT`: ID of the offer.
     - `rescuerID INT`: ID of the rescuer.
   - **Description:** Updates the offer with the rescuer's ID and changes the status to 'ACCEPTED'.

7. **ChangeRequestStatus**
   - **Usage:** Change the status of a request.
   - **Parameters:**
     - `requestID INT`: ID of the request.
     - `newStatus ENUM('PENDING', 'INPROGRESS', 'FINISHED')`: New status of the request.
   - **Description:** Updates the status of the request. If moving from 'INPROGRESS' to 'PENDING', sets `DateAssignedVehicle` and `RescuerID` to `NULL`.

8. **ChangeOfferStatus**
   - **Usage:** Change the status of an offer.
   - **Parameters:**
     - `offerID INT`: ID of the offer.
     - `newStatus ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED')`: New status of the offer.
   - **Description:** Updates the status of the offer. If moving from 'ACCEPTED' to 'PENDING', sets `DateAssigned` and `RescuerID` to `NULL`.

9. **CreateAnnouncement**
   - **Usage:** Create a new announcement.
   - **Parameters:**
     - `adminID INT`: ID of the administrator making the announcement.
     - `items JSON`: JSON array of items and their quantities.
   - **Description:** Inserts a new announcement into the `Announcements` table and its associated items into the `AnnouncementItems` table.
date are reset.

### Triggers

1. **BeforeInsertRequestItem**
   - **Description:** Before inserting into `RequestItems`, checks if there are enough items in the warehouse. If not, an error is raised.

2. **AfterRequestUpdate**
   - **Description:** After updating a request, logs the change into the `RequestHistory` table.

3. **AfterRequestInsert**
   - **Description:** After inserting a new request, logs the insertion into the `RequestHistory` table.

4. **AfterRequestDelete**
   - **Description:** After deleting a request, logs the deletion into the `RequestHistory` table.

5. **AfterOfferUpdate**
   - **Description:** After updating an offer, logs the change into the `OfferHistory` table.

6. **AfterOfferInsert**
   - **Description:** After inserting a new offer, logs the insertion into the `OfferHistory` table.

7. **AfterOfferDelete**
   - **Description:** After deleting an offer, logs the deletion into the `OfferHistory` table.

8. **BeforeAssignRescuerRequest**
   - **Description:** Before updating a request, checks if the rescuer has reached their task limit (4 tasks). If so, an error is raised.

9. **BeforeAssignRescuerOffer**
   - **Description:** Before updating an offer, checks if the rescuer has reached their task limit (4 tasks). If so, an error is raised.

## Test Data

The `test_data.sql` file provides sample data to populate the database for testing purposes. It includes sample administrators, rescuers, citizens, items, requests, and offers.

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
- `PUT /api/offers/:id/assign`: Assign an offer to a rescuer.
- `PUT /api/offers/:id/status`: Update the status of an offer.