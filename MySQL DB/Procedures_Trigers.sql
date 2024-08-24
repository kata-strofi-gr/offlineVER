USE kata_strofh;

-- Procedure to create a new request 
DELIMITER //
CREATE PROCEDURE CreateNewRequest(
    IN citizen_id INT,
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
    INSERT INTO Requests (CitizenID,Status,DateCreated)
    VALUES (citizen_id,'PENDING',NOW());

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
END;

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
END;
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
END;

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

END //
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
END //
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
END //
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
END;
//
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
END;
//

-- Procedure to Cancel a Request
DELIMITER //
CREATE PROCEDURE CancelRequest (
    IN reqID INT
)
BEGIN
    UPDATE Requests
    SET Status = 'PENDING', DateAssignedVehicle = NULL, RescuerID = NULL
    WHERE RequestID = reqID;
END //

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
END //
DELIMITER ;

-- Procedure to Mark a Request as Finished
DELIMITER //
CREATE PROCEDURE FinishRequest (
    IN reqID INT
)
BEGIN
    UPDATE Requests
    SET Status = 'FINISHED'
    WHERE RequestID = reqID;
END //
DELIMITER ;

-- Procedure to Mark an Offer as Finished
DELIMITER //
CREATE PROCEDURE FinishOffer (
    IN p_offerID INT
)
BEGIN
    UPDATE Offers
    SET Status = 'FINISHED'
    WHERE OfferID = p_offerID;
END //
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
END //
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
END //
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
END //
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
END //
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
END //
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
END //
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
END //
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
END //
DELIMITER ;


-- for log tables we may use them to add functionality to the system

/* -- Trigger to log changes in Requests table
DELIMITER //
CREATE TRIGGER AfterRequestUpdate
AFTER UPDATE ON Requests
FOR EACH ROW
BEGIN
    INSERT INTO RequestHistory (RequestID, ChangeType, OldStatus, NewStatus, OldRescuerID, NewRescuerID)
    VALUES (OLD.RequestID, 'Update', OLD.Status, NEW.Status, OLD.RescuerID, NEW.RescuerID);
END //
DELIMITER ;

-- Trigger to log insertions in Requests table
DELIMITER //
CREATE TRIGGER AfterRequestInsert
AFTER INSERT ON Requests
FOR EACH ROW
BEGIN
    INSERT INTO RequestHistory (RequestID, ChangeType, NewStatus, NewRescuerID)
    VALUES (NEW.RequestID, 'Insert', NEW.Status, NEW.RescuerID);
END //
DELIMITER ;

-- Trigger to log deletions in Requests table
DELIMITER //
CREATE TRIGGER AfterRequestDelete
AFTER DELETE ON Requests
FOR EACH ROW
BEGIN
    INSERT INTO RequestHistory (RequestID, ChangeType, OldStatus, OldRescuerID)
    VALUES (OLD.RequestID, 'Delete', OLD.Status, OLD.RescuerID);
END //
DELIMITER ;

-- Trigger to log changes in Offers table
DELIMITER //
CREATE TRIGGER AfterOfferUpdate
AFTER UPDATE ON Offers
FOR EACH ROW
BEGIN
    INSERT INTO OfferHistory (OfferID, ChangeType, OldStatus, NewStatus, OldRescuerID, NewRescuerID)
    VALUES (OLD.OfferID, 'Update', OLD.Status, NEW.Status, OLD.RescuerID, NEW.RescuerID);
END //
DELIMITER ;

-- Trigger to log insertions in Offers table
DELIMITER //
CREATE TRIGGER AfterOfferInsert
AFTER INSERT ON Offers
FOR EACH ROW
BEGIN
    INSERT INTO OfferHistory (OfferID, ChangeType, NewStatus, NewRescuerID)
    VALUES (NEW.OfferID, 'Insert', NEW.Status, NEW.RescuerID);
END //
DELIMITER ;

-- Trigger to log deletions in Offers table
DELIMITER //
CREATE TRIGGER AfterOfferDelete
AFTER DELETE ON Offers
FOR EACH ROW
BEGIN
    INSERT INTO OfferHistory (OfferID, ChangeType, OldStatus, OldRescuerID)
    VALUES (OLD.OfferID, 'Delete', OLD.Status, OLD.RescuerID);
END //
DELIMITER ; */





