USE kata_strofh;

-- Procedure to create a new request 
DELIMITER //
CREATE PROCEDURE CreateNewRequest(
    IN citizen_id INT,
    IN NumberofPeople INT,
    IN item_names VARCHAR(1000),  -- Comma-separated item names
    IN quantities VARCHAR(1000)   -- Comma-separated quantities
)
BEGIN
    DECLARE item_name VARCHAR(255);
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE request_id INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;

    -- Calculate the total number of items from the comma-separated string
    SET total_items = LENGTH(item_names) - LENGTH(REPLACE(item_names, ',', '')) + 1;

    -- Initialize item count
    SET item_count = 0;

    -- Loop through the delimited item names and quantities to validate existence
    WHILE i <= total_items DO
        -- Extract the current item name
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Validate the existence of the item and get its ID
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        -- Ensure the item exists and the quantity is valid
        IF found_item_id > 0 AND quantity > 0 THEN
            -- Increment the item count for each valid item
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Check if the number of valid items matches the total number of items
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    -- Insert a new request with the current date
    INSERT INTO Requests (CitizenID,NumberofPeople,Status,DateCreated)
    VALUES (citizen_id,NumberofPeople,'PENDING',NOW());

    -- Retrieve the new request ID
    SET request_id = LAST_INSERT_ID();

    -- Reset the loop counter
    SET i = 1;

    -- Loop again to insert each item into RequestItems
    WHILE i <= total_items DO
        -- Extract the current item name
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Get the ItemID for the current item name
        SELECT ItemID INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        -- Insert the item into RequestItems
        IF found_item_id > 0 AND quantity > 0 THEN
            INSERT INTO RequestItems (RequestID, ItemID, Quantity)
            VALUES (request_id, found_item_id, quantity);
        END IF;

        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;


-- Procedure to create a new offer
DELIMITER //
CREATE PROCEDURE CreateNewOffer(
    IN citizen_id INT,
    IN item_names VARCHAR(1000),  -- Comma-separated item names
    IN quantities VARCHAR(1000)   -- Comma-separated quantities
)
BEGIN
    DECLARE item_name VARCHAR(255);
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE offer_id INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;

    -- Calculate the total number of items from the comma-separated string
    SET total_items = LENGTH(item_names) - LENGTH(REPLACE(item_names, ',', '')) + 1;

    -- Initialize item count
    SET item_count = 0;

    -- Loop through the delimited item names and quantities to validate existence
    WHILE i <= total_items DO
        -- Extract the current item name
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Validate the existence of the item and get its ID
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        -- Ensure the item exists and the quantity is valid
        IF found_item_id > 0 AND quantity > 0 THEN
            -- Increment the item count for each valid item
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Check if the number of valid items matches the total number of items
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    -- Insert a new offer with the current date
    INSERT INTO Offers (CitizenID,Status,DateCreated)
    VALUES (citizen_id,'PENDING',NOW());

    -- Retrieve the new offer ID
    SET offer_id = LAST_INSERT_ID();

    -- Reset the loop counter
    SET i = 1;

    -- Loop again to insert each item into OfferItems
    WHILE i <= total_items DO
        -- Extract the current item name
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Get the ItemID for the current item name
        SELECT ItemID INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        -- Insert the item into OfferItems
        IF found_item_id > 0 AND quantity > 0 THEN
            INSERT INTO OfferItems (OfferID, ItemID, Quantity)
            VALUES (offer_id, found_item_id, quantity);
        END IF;

        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;


-- Procedure to create a new announcement
DELIMITER //
CREATE PROCEDURE CreateNewAnnouncement(
    IN admin_id INT,
    IN item_names VARCHAR(1000),  -- Comma-separated item names
    IN quantities VARCHAR(1000)   -- Comma-separated quantities
)
BEGIN
    DECLARE item_name VARCHAR(255);
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE announcement_id INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;

    -- Calculate the total number of items from the comma-separated string
    SET total_items = LENGTH(item_names) - LENGTH(REPLACE(item_names, ',', '')) + 1;

    -- Initialize item count
    SET item_count = 0;

    -- Loop through the delimited item names and quantities to validate existence
    WHILE i <= total_items DO
        -- Extract the current item name
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Validate the existence of the item and get its ID
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        -- Ensure the item exists and the quantity is valid
        IF found_item_id > 0 AND quantity > 0 THEN
            -- Increment the item count for each valid item
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Check if the number of valid items matches the total number of items
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    -- Insert a new announcement with the current date
    INSERT INTO Announcements (AdminID, DateCreated)
    VALUES (admin_id, NOW());

    -- Retrieve the new announcement ID
    SET announcement_id = LAST_INSERT_ID();

    -- Reset the loop counter
    SET i = 1;

    -- Loop again to insert each item into AnnouncementItems
    WHILE i <= total_items DO
        -- Extract the current item name
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Get the ItemID for the current item name
        SELECT ItemID INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        -- Insert the item into AnnouncementItems
        IF found_item_id > 0 AND quantity > 0 THEN
            INSERT INTO AnnouncementItems (AnnouncementID, ItemID, Quantity)
            VALUES (announcement_id, found_item_id, quantity);
        END IF;

        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;


-- Procedure to create a new rescuer
DELIMITER //
CREATE PROCEDURE CreateNewRescuer(
    IN username VARCHAR(255),
    IN password VARCHAR(255),
    IN latitude DOUBLE,
    IN longitude DOUBLE
)
BEGIN
    DECLARE user_id INT;
    DECLARE rescuer_id INT;

    -- Insert into user table
    INSERT INTO Users (username, password ,Role ) VALUES (username, password, 'Rescuer');

    -- Retrieve the new user ID
    SET user_id = LAST_INSERT_ID();

    -- Insert into Rescuer table
    INSERT INTO Rescuer (UserID) VALUES (user_id);

    -- Retrieve the new Rescuer ID
    SET rescuer_id = LAST_INSERT_ID();

    -- Insert into Vehicles table
    INSERT INTO Vehicles (RescuerID, Latitude, Longitude) VALUES (rescuer_id, latitude, longitude);

END//
DELIMITER ;


-- Procedure to create a new citizen
DELIMITER //
CREATE PROCEDURE CreateNewCitizen(
    IN username VARCHAR(255),
    IN password VARCHAR(255),
    IN first_name VARCHAR(255),
    IN last_name VARCHAR(255),
    IN phone_number VARCHAR(255),
    IN latitude DOUBLE,
    IN longitude DOUBLE
)
BEGIN
    DECLARE user_id INT;

    -- Insert into user table
    INSERT INTO Users (username, password ,Role) VALUES (username, password, 'Citizen');

    -- Retrieve the new user ID
    SET user_id = LAST_INSERT_ID();

    -- Insert into Citizen table
    INSERT INTO Citizen (UserID, Name, Surname, Phone, Latitude, Longitude)
    VALUES (user_id, first_name, last_name, phone_number, latitude, longitude);
END//
DELIMITER ;


-- Procedure to create a new admin
DELIMITER //
CREATE PROCEDURE CreateNewAdmin(
    IN username VARCHAR(255),
    IN password VARCHAR(255)
)
BEGIN
    DECLARE user_id INT;

    -- Insert into user table
    INSERT INTO Users (username, password) VALUES (username, password);

    -- Retrieve the new user ID
    SET user_id = LAST_INSERT_ID();

    -- Insert into Admin table
    INSERT INTO Administrator (UserID) VALUES (user_id);
END//
DELIMITER ;


-- Procedure to assign a request to a rescuer
DELIMITER //
CREATE PROCEDURE AssignRequest (
    IN p_RequestID INT,
    IN p_RescuerID INT
)
BEGIN
    UPDATE Requests SET RescuerID = p_RescuerID, Status = 'INPROGRESS', DateAssignedVehicle = NOW() 
    WHERE RequestID = p_RequestID;
END//
DELIMITER ;

-- Procedure to assign an offer to a rescuer
DELIMITER //
CREATE PROCEDURE AssignOffer (
    IN p_OfferID INT,
    IN p_RescuerID INT
)
BEGIN
    UPDATE Offers SET RescuerID = p_RescuerID, Status = 'INPROGRESS', DateAssignedVehicle = NOW() 
    WHERE OfferID = p_OfferID;
END//
DELIMITER ;

-- Procedure to Cancel a Request
DELIMITER //
CREATE PROCEDURE CancelRequest (
    IN reqID INT
)
BEGIN
    UPDATE Requests
    SET Status = 'PENDING', DateAssignedVehicle = NULL, RescuerID = NULL
    WHERE RequestID = reqID;
END//

DELIMITER ;

-- Procedure to Cancel an Offer
DELIMITER //
CREATE PROCEDURE CancelOffer (
    IN p_offerID INT
)
BEGIN
    -- Diagnostic message
    SELECT 'CancelOffer called with OfferID =', p_offerID;
    -- Update statement
    UPDATE Offers
    SET Status = 'PENDING', DateAssignedVehicle = NULL, RescuerID = NULL
    WHERE OfferID = p_offerID;
END//
DELIMITER ;

-- Procedure to Mark a Request as Finished
DELIMITER //
CREATE PROCEDURE FinishRequest (
    IN reqID INT
)
BEGIN
    UPDATE Requests
    SET Status = 'FINISHED' , DateFinished = NOW()
    WHERE RequestID = reqID;
END//
DELIMITER ;

-- Procedure to Mark an Offer as Finished
DELIMITER //
CREATE PROCEDURE FinishOffer (
    IN p_offerID INT
)
BEGIN
    UPDATE Offers
    SET Status = 'FINISHED',  DateFinished = NOW()
    WHERE OfferID = p_offerID;
END//
DELIMITER ;

-- Procedure to move items from warehouse to rescuer's vehicle
DELIMITER //
CREATE PROCEDURE MoveItemsToVehicle (
    IN p_RescuerID INT,
    IN item_ids VARCHAR(1000),  -- Comma-separated item ids
    IN quantities VARCHAR(1000)   -- Comma-separated quantities
)
BEGIN
    DECLARE item_id INT;
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;

    -- Calculate the total number of items from the comma-separated string
    SET total_items = LENGTH(item_ids) - LENGTH(REPLACE(item_ids, ',', '')) + 1;

    -- Initialize item count
    SET item_count = 0;

    -- Loop through the delimited item names and quantities to validate existence
    WHILE i <= total_items DO
        -- Extract the current item id
        SET item_id = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_ids, ',', i), ',', -1)) AS UNSIGNED);

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Validate the existence of the item and get its ID
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE ItemID = item_id
        LIMIT 1;

        -- Ensure the item exists and the quantity is valid
        IF found_item_id > 0 AND quantity > 0 THEN
            -- Increment the item count for each valid item
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Check if the number of valid items matches the total number of items
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    -- Check if quantities of items in warehouse is more than required quantity for each item
    SET i = 1;
    WHILE i <= total_items DO
        -- Extract the current item id
        SET item_id = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_ids, ',', i), ',', -1)) AS UNSIGNED);

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Check if the quantity of the item in the warehouse is less than the required quantity
        SELECT Quantity INTO found_item_id
        FROM Warehouse
        WHERE ItemID = item_id
        LIMIT 1;

        -- Ensure the quantity in the warehouse is sufficient
        IF found_item_id < quantity THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient quantity of one or more items in the warehouse', MYSQL_ERRNO = 4002;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Loop again to move each item from Warehouse to Rescuer's Vehicle
    SET i = 1;
    WHILE i <= total_items DO
        -- Extract the current item id
        SET item_id = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_ids, ',', i), ',', -1)) AS UNSIGNED);

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Remove quantity from warehouse, insert into vehicle
        UPDATE Warehouse
        SET Quantity = Quantity - quantity
        WHERE ItemID = item_id;

        INSERT INTO VehicleItems (VehicleID, ItemID, Quantity)
        VALUES ((SELECT VehicleID FROM Vehicles WHERE RescuerID = p_RescuerID), item_id, quantity);

        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;

-- Procedure to move items from rescuer's vehicle to warehouse
DELIMITER //
CREATE PROCEDURE MoveItemsToWarehouse (
    IN p_RescuerID INT,
    IN item_ids VARCHAR(1000),  -- Comma-separated item ids
    IN quantities VARCHAR(1000)   -- Comma-separated quantities
)
BEGIN
    DECLARE item_id INT;
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;

    -- Calculate the total number of items from the comma-separated string
    SET total_items = LENGTH(item_ids) - LENGTH(REPLACE(item_ids, ',', '')) + 1;

    -- Initialize item count
    SET item_count = 0;

    -- Loop through the delimited item names and quantities to validate existence
    WHILE i <= total_items DO
        -- Extract the current item id
        SET item_id = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_ids, ',', i), ',', -1)) AS UNSIGNED);

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Validate the existence of the item and get its ID
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE ItemID = item_id
        LIMIT 1;

        -- Ensure the item exists and the quantity is valid
        IF found_item_id > 0 AND quantity > 0 THEN
            -- Increment the item count for each valid item
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Check if the number of valid items matches the total number of items
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    -- Check if quantities of items in vehicle is more than required quantity for each item
    SET i = 1;
    WHILE i <= total_items DO
        -- Extract the current item id
        SET item_id = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_ids, ',', i), ',', -1)) AS UNSIGNED);

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Check if the quantity of the item in the vehicle is less than the required quantity
        SELECT Quantity INTO found_item_id
        FROM VehicleItems
        WHERE ItemID = item_id
        LIMIT 1;

        -- Ensure the quantity in the vehicle is sufficient
        IF found_item_id < quantity THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient quantity of one or more items in the vehicle', MYSQL_ERRNO = 4002;
        END IF;

        SET i = i + 1;
    END WHILE;

    -- Loop again to move each item from Vehicle to Warehouse
    SET i = 1;
    WHILE i <= total_items DO
        -- Extract the current item id
        SET item_id = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_ids, ',', i), ',', -1)) AS UNSIGNED);

        -- Extract the current quantity and convert it to an integer
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        -- Remove quantity from vehicle, insert into warehouse
        UPDATE VehicleItems
        SET Quantity = Quantity - quantity
        WHERE ItemID = item_id;

        INSERT INTO Warehouse (ItemID, Quantity)
        VALUES (item_id, quantity);

        SET i = i + 1;
    END WHILE;
END//
DELIMITER ;

-- Trigger to prevent rescuer assignment if they have reached the task limit for requests
DELIMITER //
CREATE TRIGGER BeforeAssignRescuerToRequest
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    DECLARE taskCount INT;

    IF NEW.RescuerID IS NOT NULL AND NEW.Status != 'FINISHED' THEN
        SELECT COUNT(*) INTO taskCount
        FROM (
            SELECT RescuerID FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
            UNION ALL
            SELECT RescuerID FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
        ) AS RescuerTasks;

        IF taskCount >= 4 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Rescuer has reached the maximum number of tasks.', MYSQL_ERRNO = 6002;
        END IF;
    END IF;
END//
DELIMITER ;

-- Trigger to prevent rescuer assignment if they have reached the task limit for offers
DELIMITER //

CREATE TRIGGER BeforeAssignRescuerToOffer
BEFORE UPDATE ON Offers
FOR EACH ROW
BEGIN
    DECLARE taskCount INT;

    IF NEW.RescuerID IS NOT NULL AND NEW.Status != 'FINISHED' THEN
        SELECT COUNT(*) INTO taskCount
        FROM (
            SELECT RescuerID FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
            UNION ALL
            SELECT RescuerID FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
        ) AS RescuerTasks;

        IF taskCount >= 4 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Rescuer has reached the maximum number of tasks.', MYSQL_ERRNO = 6002;
        END IF;
    END IF;
END//
DELIMITER ;

-- Trigger to prevent reassignment of in-progress requests
DELIMITER //
CREATE TRIGGER PreventReassignInProgressRequest
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    IF OLD.Status = 'INPROGRESS' AND OLD.RescuerID IS NOT NULL AND OLD.RescuerID != NEW.RescuerID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'In-progress requests cannot be reassigned.', MYSQL_ERRNO = 5003;
    END IF;
END//
DELIMITER ;

-- Trigger to prevent reassignment of in-progress offers
DELIMITER //
CREATE TRIGGER PreventReassignInProgressOffer
BEFORE UPDATE ON Offers
FOR EACH ROW
BEGIN
    IF OLD.Status = 'INPROGRESS' AND OLD.RescuerID IS NOT NULL AND OLD.RescuerID != NEW.RescuerID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'In-progress offers cannot be reassigned.', MYSQL_ERRNO = 5004;
    END IF;
END//
DELIMITER ;

-- Trigger to prevent pending requests from being marked as finished
DELIMITER //
CREATE TRIGGER PreventPendingRequestFinished
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    IF OLD.Status = 'PENDING' AND NEW.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending requests cannot be marked as finished.', MYSQL_ERRNO = 5005;
    END IF;
END//
DELIMITER ;

-- Trigger to prevent pending offers from being marked as finished
DELIMITER //
CREATE TRIGGER PreventPendingOfferFinished
BEFORE UPDATE ON Offers
FOR EACH ROW
BEGIN
    IF OLD.Status = 'PENDING' AND NEW.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending offers cannot be marked as finished.', MYSQL_ERRNO = 5006;
    END IF;
END//
DELIMITER ;


-- Trigger to prevent finished requests from being altered
DELIMITER //
CREATE TRIGGER PreventFinishedRequestAlteration
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    IF OLD.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finished requests cannot be altered.', MYSQL_ERRNO = 5007;  
    END IF;
END//
DELIMITER ;

-- Trigger to prevent finished offers from being altered

DELIMITER //
CREATE TRIGGER PreventFinishedOfferAlteration
BEFORE UPDATE ON Offers
FOR EACH ROW
BEGIN
    IF OLD.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finished offers cannot be altered.', MYSQL_ERRNO = 5008;
    END IF;
END//
DELIMITER ;

-- Trigger to combine quantities when item is inserted into vehicle (manually)
DELIMITER //
CREATE TRIGGER CombineQuantitiesVehicle
AFTER INSERT ON VehicleItems
FOR EACH ROW
BEGIN
    DECLARE existing_quantity INT;

    -- Check if negative quantity
    IF NEW.Quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot be negative.', MYSQL_ERRNO = 5009;
    END IF;

    -- Check if the item already exists in the vehicle
    SELECT Quantity INTO existing_quantity
    FROM VehicleItems
    WHERE VehicleID = NEW.VehicleID AND ItemID = NEW.ItemID;

    -- If the item already exists 
    IF existing_quantity IS NOT NULL THEN
        UPDATE VehicleItems
        SET Quantity = existing_quantity + NEW.Quantity
        WHERE VehicleID = NEW.VehicleID AND ItemID = NEW.ItemID;
    END IF;
END//
DELIMITER ;

-- Trigger to combine quantities when item is inserted into warehouse (manually)
DELIMITER //
CREATE TRIGGER CombineQuantitiesWarehouse
AFTER INSERT ON Warehouse
FOR EACH ROW
BEGIN
    DECLARE existing_quantity INT;

    -- Check if negative quantity
    IF NEW.Quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot be negative.', MYSQL_ERRNO = 5009;
    END IF;

    -- Check if the item already exists in the warehouse
    SELECT Quantity INTO existing_quantity
    FROM Warehouse
    WHERE ItemID = NEW.ItemID;
    
    -- If the item already exists, update the quantity
    IF existing_quantity IS NOT NULL THEN
        UPDATE Warehouse
        SET Quantity = existing_quantity + NEW.Quantity
        WHERE ItemID = NEW.ItemID;
    END IF;
END//
DELIMITER ;

-- Trigger to prevent extracting more quantity than exists in the warehouse
DELIMITER //
CREATE TRIGGER PreventExtractingMoreThanExistsWarehouse
BEFORE UPDATE ON Warehouse
FOR EACH ROW
BEGIN
    DECLARE existing_quantity INT;

    SELECT Quantity INTO existing_quantity
    FROM Warehouse
    WHERE ItemID = NEW.ItemID;

    IF NEW.Quantity > existing_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot be more than exists.', MYSQL_ERRNO = 5010;
    END IF;
END//
DELIMITER ;

-- Trigger to prevent extracting more quantity than exists in the vehicle
DELIMITER //
CREATE TRIGGER PreventExtractingMoreThanExistsVehicle
BEFORE UPDATE ON VehicleItems
FOR EACH ROW
BEGIN
    DECLARE existing_quantity INT;

    SELECT Quantity INTO existing_quantity
    FROM VehicleItems
    WHERE VehicleID = NEW.VehicleID AND ItemID = NEW.ItemID;

    IF NEW.Quantity > existing_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot be more than exists.', MYSQL_ERRNO = 5010;
    END IF;
END//
DELIMITER ;
