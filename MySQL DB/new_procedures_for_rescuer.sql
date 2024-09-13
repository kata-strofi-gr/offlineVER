USE kata_strofh;


DELIMITER //

-- Trigger to sum up quantities of same items in the same request

CREATE TRIGGER request_items_sum
AFTER INSERT ON RequestItems
FOR EACH ROW
BEGIN
    DECLARE v_ExistingQuantity INT;

    -- Check if the item already exists in the current request
    IF EXISTS (SELECT 1 FROM RequestItems WHERE RequestID = NEW.RequestID AND ItemID = NEW.ItemID AND RequestItemID != NEW.RequestItemID) THEN
        -- Get the existing quantity of the item in the request
        SELECT Quantity INTO v_ExistingQuantity 
        FROM RequestItems 
        WHERE RequestID = NEW.RequestID AND ItemID = NEW.ItemID;
        
        -- Update the quantity of the existing item
        UPDATE RequestItems 
        SET Quantity = v_ExistingQuantity + NEW.Quantity
        WHERE RequestID = NEW.RequestID AND ItemID = NEW.ItemID;

        -- Delete the new record as it's now summed into the existing item
        DELETE FROM RequestItems WHERE RequestItemID = NEW.RequestItemID;
    END IF;
END //

DELIMITER ;


DELIMITER //

-- Trigger to sum up quantities of same items in the same announcement

CREATE TRIGGER announcement_items_sum
AFTER INSERT ON AnnouncementItems
FOR EACH ROW
BEGIN
    DECLARE v_ExistingQuantity INT;

    -- Check if the item already exists in the current announcement
    IF EXISTS (SELECT 1 FROM AnnouncementItems WHERE AnnouncementID = NEW.AnnouncementID AND ItemID = NEW.ItemID AND AnnouncementItemID != NEW.AnnouncementItemID) THEN
        -- Get the existing quantity of the item in the announcement
        SELECT Quantity INTO v_ExistingQuantity 
        FROM AnnouncementItems 
        WHERE AnnouncementID = NEW.AnnouncementID AND ItemID = NEW.ItemID;
        
        -- Update the quantity of the existing item
        UPDATE AnnouncementItems 
        SET Quantity = v_ExistingQuantity + NEW.Quantity
        WHERE AnnouncementID = NEW.AnnouncementID AND ItemID = NEW.ItemID;

        -- Delete the new record as it's now summed into the existing item
        DELETE FROM AnnouncementItems WHERE AnnouncementItemID = NEW.AnnouncementItemID;
    END IF;
END //

DELIMITER ;


DELIMITER //

-- Trigger to sum up quantities of same items in the same offer
CREATE TRIGGER offer_items_sum
AFTER INSERT ON OfferItems
FOR EACH ROW
BEGIN
    DECLARE v_ExistingQuantity INT;

    -- Check if the item already exists in the current offer
    IF EXISTS (SELECT 1 FROM OfferItems WHERE OfferID = NEW.OfferID AND ItemID = NEW.ItemID AND OfferItemID != NEW.OfferItemID) THEN
        -- Get the existing quantity of the item in the offer
        SELECT Quantity INTO v_ExistingQuantity 
        FROM OfferItems 
        WHERE OfferID = NEW.OfferID AND ItemID = NEW.ItemID;
        
        -- Update the quantity of the existing item
        UPDATE OfferItems 
        SET Quantity = v_ExistingQuantity + NEW.Quantity
        WHERE OfferID = NEW.OfferID AND ItemID = NEW.ItemID;

        -- Delete the new record as it's now summed into the existing item
        DELETE FROM OfferItems WHERE OfferItemID = NEW.OfferItemID;
    END IF;
END //

DELIMITER ;


-- test triggers 
INSERT INTO RequestItems (RequestID, ItemID, Quantity) VALUES (1, 1, 10), (1, 1, 5);