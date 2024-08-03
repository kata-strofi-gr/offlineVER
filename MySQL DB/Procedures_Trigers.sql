USE kata_strofh;

-- Procedure to create a new requestcheck_warehouse_before_assign_request
DELIMITER //

CREATE PROCEDURE CreateNewRequest(
    IN citizenID INT,
    IN items JSON,
    IN status ENUM('PENDING', 'INPROGRESS', 'FINISHED')
)
BEGIN
    DECLARE requestID INT;
    DECLARE itemID INT;
    DECLARE itemName VARCHAR(100);
    DECLARE itemQuantity INT;
    DECLARE itemIndex INT DEFAULT 0;
    DECLARE itemsCount INT;

    -- Insert the new request
    INSERT INTO Requests (CitizenID, Status, DateCreated)
    VALUES (citizenID, status, NOW());

    SET requestID = LAST_INSERT_ID();

    -- Get the count of items in the JSON array
    SET itemsCount = JSON_LENGTH(items);

    -- Loop through the items array
    WHILE itemIndex < itemsCount DO
        -- Extract item details
        SET itemName = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', itemIndex, '].name')));
        SET itemQuantity = CAST(JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', itemIndex, '].quantity'))) AS UNSIGNED);

        -- Get item ID from item name
        SELECT ItemID INTO itemID FROM Items WHERE Name = itemName;

        -- Check if item exists
        IF itemID IS NULL THEN
            SIGNAL SQLSTATE '45000' 
             SET MESSAGE_TEXT = 'Item not found', MYSQL_ERRNO = 4001;
        ELSE
            INSERT INTO RequestItems (RequestID, ItemID, Quantity) VALUES (requestID, itemID, itemQuantity);
        END IF;

        SET itemIndex = itemIndex + 1;
    END WHILE;
END //

DELIMITER ;




-- Procedure to create a new offer
DELIMITER //
CREATE PROCEDURE CreateNewOffer(
    IN citizenID INT,
    IN items JSON,
    IN status ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED')
)
BEGIN
    DECLARE offerID INT;
    DECLARE itemID INT;
    DECLARE itemName VARCHAR(100);
    DECLARE itemQuantity INT;
    DECLARE itemIndex INT DEFAULT 0;
    DECLARE itemsCount INT;
    
    -- Insert the new offer
    INSERT INTO Offers (CitizenID, Status, DateCreated)
    VALUES (citizenID, status, NOW());
    
    SET offerID = LAST_INSERT_ID();
    
    -- Get the count of items in the JSON array
    SET itemsCount = JSON_LENGTH(items);
    
    -- Loop through the items array
    WHILE itemIndex < itemsCount DO
        -- Extract item details
        SET itemName = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', itemIndex, '].name')));
        SET itemQuantity = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', itemIndex, '].quantity')));
        
        -- Get item ID from item name
        SELECT ItemID INTO itemID FROM Items WHERE Name = itemName;
        
        IF itemID IS NULL THEN
            SIGNAL SQLSTATE '45000' 
             SET MESSAGE_TEXT = 'Item not found', MYSQL_ERRNO = 4001;
        ELSE
            -- Insert into OfferItems
            INSERT INTO OfferItems (OfferID, ItemID, Quantity)
            VALUES (offerID, itemID, itemQuantity);
        END IF;
        
        SET itemIndex = itemIndex + 1;
    END WHILE;
END //
DELIMITER ;


-- Procedure to create a new announcement

DELIMITER //
CREATE PROCEDURE CreateAnnouncement(
    IN adminID INT,
    IN items JSON
)
BEGIN
    DECLARE announcementID INT;
    DECLARE itemID INT;
    DECLARE itemName VARCHAR(100);
    DECLARE itemQuantity INT;
    DECLARE itemIndex INT DEFAULT 0;
    DECLARE itemsCount INT;
    
    -- Insert the new announcement
    INSERT INTO Announcements (AdminID, DateCreated)
    VALUES (adminID, NOW());
    
    SET announcementID = LAST_INSERT_ID();
    
    -- Get the count of items in the JSON array
    SET itemsCount = JSON_LENGTH(items);
    
    -- Loop through the items array
    WHILE itemIndex < itemsCount DO
        -- Extract item details
        SET itemName = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', itemIndex, '].name')));
        SET itemQuantity = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', itemIndex, '].quantity')));
        
        -- Get item ID from item name
        SELECT ItemID INTO itemID FROM Items WHERE Name = itemName;
        
        IF itemID IS NULL THEN
            SIGNAL SQLSTATE '45000' 
             SET MESSAGE_TEXT = 'Item not found', MYSQL_ERRNO = 4001;
        ELSE
            -- Insert into AnnouncementItems
            INSERT INTO AnnouncementItems (AnnouncementID, ItemID, Quantity)
            VALUES (announcementID, itemID, itemQuantity);
        END IF;
        
        SET itemIndex = itemIndex + 1;
    END WHILE;
END //
DELIMITER ;

-- Procedure to create a new rescuer
DELIMITER //
CREATE PROCEDURE CreateNewRescuer(
    IN username VARCHAR(50),
    IN password VARCHAR(255),
    IN latitude DECIMAL(10, 8),
    IN longitude DECIMAL(11, 8)
)
BEGIN
    INSERT INTO Rescuer (Username, Password, Latitude, Longitude)
    VALUES (username, password, latitude, longitude);
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

-- Procedure to change the status of a request  
DELIMITER //
CREATE PROCEDURE ChangeRequestStatus(
    IN requestID INT,
    IN newStatus ENUM('PENDING', 'INPROGRESS', 'FINISHED')
)
BEGIN
    DECLARE oldStatus ENUM('PENDING', 'INPROGRESS', 'FINISHED');
    SELECT Status INTO oldStatus FROM Requests WHERE RequestID = requestID;

    IF oldStatus = 'INPROGRESS' AND newStatus = 'PENDING' THEN
        UPDATE Requests
        SET Status = newStatus, DateAssignedVehicle = NULL, RescuerID = NULL
        WHERE RequestID = requestID;
    ELSE
        UPDATE Requests
        SET Status = newStatus
        WHERE RequestID = requestID;
    END IF;

    INSERT INTO RequestLog (RequestID, ChangeType, OldStatus, NewStatus)
    VALUES (requestID, 'Status Change', oldStatus, newStatus);
END //
DELIMITER ;


-- Procedure to change the status of an offer
DELIMITER //
CREATE PROCEDURE ChangeOfferStatus(
    IN offerID INT,
    IN newStatus ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED')
)
BEGIN
    DECLARE oldStatus ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED');
    SELECT Status INTO oldStatus FROM Offers WHERE OfferID = offerID;

    IF oldStatus = 'ACCEPTED' AND newStatus = 'PENDING' THEN
        UPDATE Offers
        SET Status = newStatus, DateAssigned = NULL, RescuerID = NULL
        WHERE OfferID = offerID;
    ELSE
        UPDATE Offers
        SET Status = newStatus
        WHERE OfferID = offerID;
    END IF;

    INSERT INTO OfferLog (OfferID, ChangeType, OldStatus, NewStatus)
    VALUES (offerID, 'Status Change', oldStatus, newStatus);
END //
DELIMITER ;

 
-- Trigger to check warehouse quantity before assigning a request
DELIMITER //
CREATE TRIGGER BeforeInsertRequestItem
BEFORE INSERT ON RequestItems
FOR EACH ROW
BEGIN
    DECLARE availableQty INT;
    SELECT Quantity INTO availableQty FROM Warehouse WHERE ItemID = NEW.ItemID;
    IF availableQty < NEW.Quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough items in the warehouse';
    END IF;
END //
DELIMITER ;



-- Trigger to prevent rescuer assignment if they have reached the task limit for requests
DELIMITER //
CREATE TRIGGER BeforeAssignRescuerRequest
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    DECLARE requestCount INT;
    DECLARE offerCount INT;
    IF NEW.RescuerID IS NOT NULL THEN
        SELECT COUNT(*) INTO requestCount FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS';
        SELECT COUNT(*) INTO offerCount FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'ACCEPTED';
        IF (requestCount + offerCount) >= 4 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rescuer has reached the maximum task limit';
        END IF;
    END IF;
END //
DELIMITER ;

-- Trigger to prevent rescuer assignment if they have reached the task limit for offers
DELIMITER //
CREATE TRIGGER BeforeAssignRescuerOffer
BEFORE UPDATE ON Offers
FOR EACH ROW
BEGIN
    DECLARE requestCount INT;
    DECLARE offerCount INT;
    IF NEW.RescuerID IS NOT NULL THEN
        SELECT COUNT(*) INTO requestCount FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS';
        SELECT COUNT(*) INTO offerCount FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'ACCEPTED';
        IF (requestCount + offerCount) >= 4 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rescuer has reached the maximum task limit';
        END IF;
    END IF;
END //
DELIMITER ;

-- Trigger to log changes in Requests table
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
DELIMITER ;





