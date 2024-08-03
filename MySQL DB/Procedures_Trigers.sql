USE kata_strofh;

-- Procedure to create a new request 
DELIMITER //
CREATE PROCEDURE CreateNewRequest(
    IN citizen_id INT,
    IN item_details JSON
)
BEGIN
    DECLARE item_count INT;
    DECLARE total_items INT;
    DECLARE new_request_id INT;

    -- Calculate the number of items to be checked
    SET total_items = JSON_LENGTH(item_details);

    -- Create a temporary table to store item IDs and quantities
    CREATE TEMPORARY TABLE TempItems (
        ItemID INT,
        Quantity INT
    );

    -- Insert item IDs and quantities into the temporary table
    INSERT INTO TempItems (ItemID, Quantity)
    SELECT i.ItemID, jt.quantity
    FROM Items i
    JOIN JSON_TABLE(item_details, "$[*]" COLUMNS (
        item_name VARCHAR(255) PATH "$.item_name",
        quantity INT PATH "$.quantity"
    )) AS jt
    ON i.Name = jt.item_name;

    -- Check existence of all items by their IDs in the temporary table
    SELECT COUNT(*) INTO item_count
    FROM TempItems ti
    JOIN Items i ON ti.ItemID = i.ItemID;

    -- If not all items exist, raise an error
    IF item_count <> total_items THEN
        DROP TEMPORARY TABLE TempItems;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist', MYSQL_ERRNO = 4001;
    END IF;

    -- Step 2: Insert a new request with status 'PENDING'
    INSERT INTO Requests (CitizenID, Status, DateCreated)
    VALUES (citizen_id, 'PENDING', NOW());

    -- Retrieve the new request ID
    SET new_request_id = LAST_INSERT_ID();

    -- Step 3: Associate items with the new request
    INSERT INTO RequestItems (RequestID, ItemID, Quantity)
    SELECT new_request_id, ItemID, Quantity
    FROM TempItems;
    -- Drop the temporary table
    DROP TEMPORARY TABLE TempItems;

END //
DELIMITER ;


-- Procedure to create a new offer

DELIMITER //
CREATE PROCEDURE CreateNewOffer(
    IN citizen_id INT,
    IN items JSON
)
BEGIN
    DECLARE offerID INT;
    DECLARE item_count INT;
    DECLARE total_items INT;

    -- Calculate the number of items to be checked
    SET total_items = JSON_LENGTH(items);

    -- Create a temporary table to store item IDs and quantities
    CREATE TEMPORARY TABLE TempItems (
        ItemID INT,
        Quantity INT
    );

    -- Insert item IDs and quantities into the temporary table
    INSERT INTO TempItems (ItemID, Quantity)
    SELECT i.ItemID, jt.quantity
    FROM Items i
    JOIN JSON_TABLE(items, "$[*]" COLUMNS (
        item_name VARCHAR(255) PATH "$.name",
        quantity INT PATH "$.quantity"
    )) AS jt
    ON i.Name = jt.item_name;

    -- Check existence of all items by their IDs in the temporary table
    SELECT COUNT(*) INTO item_count
    FROM TempItems ti
    JOIN Items i ON ti.ItemID = i.ItemID;

    -- If not all items exist, raise an error
    IF item_count <> total_items THEN
        DROP TEMPORARY TABLE TempItems;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist', MYSQL_ERRNO = 4001;
    END IF;

    -- Step 2: Insert a new offer with the provided status
    INSERT INTO Offers (CitizenID, Status, DateCreated)
    VALUES (citizen_id, 'PENDING', NOW());

    -- Retrieve the new offer ID
    SET offerID = LAST_INSERT_ID();

    -- Step 3: Associate items with the new offer
    INSERT INTO OfferItems (OfferID, ItemID, Quantity)
    SELECT offerID, ItemID, Quantity
    FROM TempItems;

    -- Drop the temporary table
    DROP TEMPORARY TABLE TempItems;
END //
DELIMITER ;


-- Procedure to create a new announcement
DELIMITER //
CREATE PROCEDURE CreateNewAnnouncement(
    IN AdminID INT,
    IN items JSON
)
BEGIN
    DECLARE announcementID INT;
    DECLARE item_count INT;
    DECLARE total_items INT;

    -- Calculate the number of items to be checked
    SET total_items = JSON_LENGTH(items);

    -- Create a temporary table to store item IDs and quantities
    CREATE TEMPORARY TABLE TempItemsAnn (
        ItemID INT,
        Quantity INT
    );

    -- Insert item IDs and quantities into the temporary table
    INSERT INTO TempItemsAnn (ItemID, Quantity)
    SELECT i.ItemID, jt.quantity
    FROM Items i
    JOIN JSON_TABLE(items, "$[*]" COLUMNS (
        item_name VARCHAR(255) PATH "$.name",
        quantity INT PATH "$.quantity"
    )) AS jt
    ON i.Name = jt.item_name;

    -- Check existence of all items by their IDs in the temporary table
    SELECT COUNT(*) INTO item_count
    FROM TempItemsAnn ti
    JOIN Items i ON ti.ItemID = i.ItemID;

    -- If not all items exist, raise an error
    IF item_count <> total_items THEN
        DROP TEMPORARY TABLE TempItemsAnn;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist', MYSQL_ERRNO = 4001;
    END IF;

    -- Step 2: Insert a new offer with the provided status
    INSERT INTO Announcements (AdminID, DateCreated)
    VALUES (AdminID, NOW());

    -- Retrieve the new offer ID
    SET announcementID = LAST_INSERT_ID();

    -- Step 3: Associate items with the new offer
    INSERT INTO AnnouncementItems (AnnouncementID, ItemID, Quantity)
    SELECT announcementID, ItemID, Quantity
    FROM TempItemsAnn;

    -- Drop the temporary table
    DROP TEMPORARY TABLE TempItemsAnn;

END //
DELIMITER ;


-- Procedure to create a new rescuer
DELIMITER //
CREATE PROCEDURE CreateNewRescuer(
    IN username VARCHAR(50),
    IN password VARCHAR(255)
)
BEGIN
    INSERT INTO Rescuer (Username, Password)
    VALUES (username, password);
END //
DELIMITER ;

-- Procedure to create a new citizen
DELIMITER //
CREATE PROCEDURE CreateNewCitizen(
    IN username VARCHAR(50),
    IN password VARCHAR(255),
    IN name VARCHAR(100),
    IN surname VARCHAR(100),
    IN phone VARCHAR(15),
    IN latitude DECIMAL(10, 8),
    IN longitude DECIMAL(11, 8)
)
BEGIN
    INSERT INTO Citizen (Username, Password, Name, Surname, Phone, Latitude, Longitude)
    VALUES (username, password, name, surname, phone, latitude, longitude);
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
    UPDATE Offers SET RescuerID = p_RescuerID, Status = 'INPROGRESS', DateAssigned = NOW() 
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
    IN offerID INT
)
BEGIN
    UPDATE Offers
    SET Status = 'PENDING', DateAssignedVehicle = NULL, RescuerID = NULL
    WHERE OfferID = offerID;
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
    IN offerID INT
)
BEGIN
    UPDATE Offers
    SET Status = 'FINISHED'
    WHERE OfferID = offerID;
END //


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
            SET MESSAGE_TEXT = 'Rescuer has reached the maximum number of tasks.';
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
            SET MESSAGE_TEXT = 'Rescuer has reached the maximum number of tasks.';
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
        SET MESSAGE_TEXT = 'In-progress requests cannot be reassigned to another rescuer.';
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
        SET MESSAGE_TEXT = 'In-progress offers cannot be reassigned to another rescuer.';
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
        SET MESSAGE_TEXT = 'Pending requests cannot be marked as finished.';
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
        SET MESSAGE_TEXT = 'Pending offers cannot be marked as finished.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER PreventFinishedRequestAlteration
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    IF OLD.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finished requests cannot be altered.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER PreventFinishedOfferAlteration
BEFORE UPDATE ON Offers
FOR EACH ROW
BEGIN
    IF OLD.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finished offers cannot be altered.';
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





