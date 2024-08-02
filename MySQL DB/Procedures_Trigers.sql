USE kata_strofh;

-- Procedure to create a new requestcheck_warehouse_before_assign_request
DELIMITER //
CREATE PROCEDURE CreateNewRequest(
    IN citizenID INT,
    IN itemName VARCHAR(100),
    IN quantity INT,
    IN status ENUM('PENDING', 'INPROGRESS', 'FINISHED')
)
BEGIN
    DECLARE itemID INT;
    DECLARE requestID INT;
    
    SELECT ItemID INTO itemID FROM Items WHERE Name = itemName;
    IF itemID IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Item not found';
    ELSE
        INSERT INTO Requests (CitizenID, Status, DateCreated)
        VALUES (citizenID, status, NOW());
        
        SET requestID = LAST_INSERT_ID();
        
        INSERT INTO RequestItems (RequestID, ItemID, Quantity)
        VALUES (requestID, itemID, quantity);
    END IF;
END //



-- Procedure to create a new offer
DELIMITER //
CREATE PROCEDURE CreateOffer (
    IN p_CitizenID INT,
    IN p_Item VARCHAR(100),
    IN p_Quantity INT
)
BEGIN
    INSERT INTO Offers (CitizenID, Item, Quantity, Status, DateCreated) 
    VALUES (p_CitizenID, p_Item, p_Quantity, 'Pending', NOW());
END;
//
DELIMITER ;

-- Procedure to assign a request to a rescuer
DELIMITER //
CREATE PROCEDURE AssignRequest (
    IN p_RequestID INT,
    IN p_RescuerID INT
)
BEGIN
    UPDATE Requests SET RescuerID = p_RescuerID, Status = 'INPROGRESS', DateAssignedVehicle = NOW() WHERE RequestID = p_RequestID;
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
    UPDATE Offers SET RescuerID = p_RescuerID, Status = 'INPROGRESS', DateAssigned = NOW() WHERE OfferID = p_OfferID;
END;
//

-- Procedure to change the status of a request  
DELIMITER //
CREATE PROCEDURE ChangeRequestStatus (
    IN p_RequestID INT,
    IN p_Status VARCHAR(20)
)
BEGIN
    IF p_Status = 'PENDING' THEN
        UPDATE Requests 
        SET Status = p_Status, DateAssignedVehicle = NULL, RescuerID = NULL
        WHERE RequestID = p_RequestID;
    ELSE
        UPDATE Requests 
        SET Status = p_Status
        WHERE RequestID = p_RequestID;
    END IF;
END;
//
DELIMITER ;

-- Procedure to change the status of an offer
DELIMITER //
CREATE PROCEDURE ChangeOfferStatus (
    IN p_OfferID INT,
    IN p_Status VARCHAR(20)
)
BEGIN
    IF p_Status = 'PENDING' THEN
        UPDATE Offers 
        SET Status = p_Status, DateAssigned = NULL, RescuerID = NULL
        WHERE OfferID = p_OfferID;
    ELSE
        UPDATE Offers 
        SET Status = p_Status
        WHERE OfferID = p_OfferID;
    END IF;
END;
//
DELIMITER ;
 
-- Trigger to check warehouse quantity before assigning a request
DELIMITER //
CREATE TRIGGER check_warehouse_before_assign_request
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    IF NEW.Status = 'INPROGRESS' THEN
        IF (SELECT Quantity FROM Warehouse WHERE ItemID = NEW.ItemID) < NEW.Quantity THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough items in the warehouse to fulfill the request';
        END IF;
    END IF;
END;
//

-- Trigger to log changes in requests table
DELIMITER //
CREATE TRIGGER log_requests_changes
AFTER UPDATE ON Requests
FOR EACH ROW
BEGIN
    INSERT INTO RequestLogs (RequestID, CitizenID, ItemID, Quantity, Status, DateCreated, DateAssigned, RescuerID, ChangeDate)
    VALUES (NEW.RequestID, NEW.CitizenID, NEW.ItemID, NEW.Quantity, NEW.Status, NEW.DateCreated, NEW.DateAssignedVehicle, NEW.RescuerID, NOW());
END;
//

-- Trigger to log changes in offers table
DELIMITER //
CREATE TRIGGER log_offers_changes
AFTER UPDATE ON Offers
FOR EACH ROW
BEGIN
    INSERT INTO OfferLogs (OfferID, CitizenID, ItemID, Quantity, Status, DateCreated, DateAssigned, RescuerID, ChangeDate)
    VALUES (NEW.OfferID, NEW.CitizenID, NEW.ItemID, NEW.Quantity, NEW.Status, NEW.DateCreated, NEW.DateAssigned, NEW.RescuerID, NOW());
END;
//

-- Trigger to prevent rescuer assignment if they have reached the task limit for requests
DELIMITER //
CREATE TRIGGER prevent_rescuer_task_overload
BEFORE UPDATE ON Requests
FOR EACH ROW
BEGIN
    IF NEW.Status = 'INPROGRESS' THEN
        SET @taskCount = (SELECT COUNT(*) FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS') +
                         (SELECT COUNT(*) FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS');
        IF @taskCount >= 4 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rescuer has reached the task limit';
        END IF;
    END IF;
END;
//
DELIMITER ;

-- Trigger to prevent rescuer assignment if they have reached the task limit for offers
DELIMITER //
CREATE TRIGGER prevent_rescuer_task_overload_offers
BEFORE UPDATE ON Offers
FOR EACH ROW
BEGIN
    IF NEW.Status = 'INPROGRESS' THEN
        SET @taskCount = (SELECT COUNT(*) FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS') +
                         (SELECT COUNT(*) FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS');
        IF @taskCount >= 4 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rescuer has reached the task limit';
        END IF;
    END IF;
END;
//
DELIMITER ;




