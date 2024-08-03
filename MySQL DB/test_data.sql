USE kata_strofh;

-- Insert sample data into Administrator table
INSERT INTO Administrator (Username, Password) VALUES 
('admin1', 'password1'),
('admin2', 'password2');

-- Insert sample data into Rescuer table
INSERT INTO Rescuer (Username, Password) VALUES 
('rescuer1', 'password1'),
('rescuer2', 'password2'),
('rescuer3', 'password3');

-- Insert sample data into Citizen table
INSERT INTO Citizen (Username, Password, Name, Surname, Phone, Latitude, Longitude)
VALUES
('citizen1', 'password1', 'John', 'Doe', '1234567890', 40.712776, -74.005974),
('citiczen2', 'passcword2', 'Jacne', 'Smith', '0987624321', 33.052235, -118.243683),
('citizen2', 'password2', 'Jane', 'Smith', '0987654321', 34.052235, -118.243683);

-- Insert sample data into Items table
INSERT INTO Items (Category, Name, Description) VALUES 
('Food', 'Rice', 'A staple food item'),
('Medicine', 'Aspirin', 'Pain relief medicine'),
('Clothing', 'Blanket', 'Warm blanket for cold weather');

-- Insert sample data into Warehouse table
INSERT INTO Warehouse (ItemID, Quantity) VALUES 
(1, 100), -- Rice
(2, 50),  -- Aspirin
(3, 75);  -- Blanket


-- Insert sample data into Requests table
INSERT INTO Requests (CitizenID, Status, DateCreated) VALUES 
(1, 'PENDING', NOW()), -- John Doe requesting Rice
(2, 'PENDING', NOW()),  -- Jane Doe requesting Aspirin
(3, 'PENDING', NOW()),  -- Alice Smith requesting Blanket
(1, 'PENDING', NOW()),  -- John Doe requesting Aspirin
(2, 'PENDING', NOW()),  -- Jane Doe requesting Blanket
(3, 'PENDING', NOW());  -- Alice Smith requesting Rice

INSERT INTO RequestItems (RequestID, ItemID, Quantity) VALUES
(1, 1, 10), -- John Doe requesting 10 units of Rice
(2, 2, 5),  -- Jane Doe requesting 5 units of Aspirin
(3, 3, 3),  -- Alice Smith requesting 3 units of Blanket
(4, 2, 7),  -- John Doe requesting 7 units of Aspirin
(5, 3, 10), -- Jane Doe requesting 10 units of Blanket
(6, 1, 15); -- Alice Smith requesting 15 units of Rice

INSERT INTO RequestItems (RequestID, ItemID, Quantity) VALUES
(1, 1, 10); -- John Doe requesting 10 units of Rice


-- Insert sample data into Offers table
INSERT INTO Offers (CitizenID, Status, DateCreated) VALUES 
(1, 'PENDING', NOW()), -- John Doe offering Rice
(2, 'PENDING', NOW()),  -- Jane Doe offering Aspirin
(3, 'PENDING', NOW()),  -- Alice Smith offering Blanket
(1, 'PENDING', NOW()), -- John Doe offering Blanket
(2, 'PENDING', NOW()),  -- Jane Doe offering Rice
(3, 'PENDING', NOW());  -- Alice Smith offering Aspirin

INSERT INTO OfferItems (OfferID, ItemID, Quantity) VALUES
(1, 1, 20), -- John Doe offering 20 units of Rice
(2, 2, 10),  -- Jane Doe offering 10 units of Aspirin
(3, 3, 5),  -- Alice Smith offering 5 units of Blanket
(4, 3, 7),  -- John Doe offering 7 units of Blanket
(5, 1, 15), -- Jane Doe offering 15 units of Rice
(6, 2, 20); -- Alice Smith offering 20 units of Aspirin

-- Insert sample data into Vehicles table
INSERT INTO Vehicles (RescuerID, Latitude, Longitude) VALUES 
(1, 37.774929, -122.419418), -- Rescuer 1 in San Francisco
(2, 34.052235, -118.243683), -- Rescuer 2 in Los Angeles
(3, 40.712776, -74.005974);  -- Rescuer 3 in New York

-- Insert sample data into VehicleItems table
INSERT INTO VehicleItems (VehicleID, ItemID, Quantity) VALUES
(1, 1, 10), -- Vehicle 1 carrying 10 units of Item 1
(1, 2, 5),  -- Vehicle 1 carrying 5 units of Item 2
(2, 3, 7),  -- Vehicle 2 carrying 7 units of Item 3
(2, 1, 15), -- Vehicle 2 carrying 15 units of Item 1
(3, 2, 20), -- Vehicle 3 carrying 20 units of Item 2
(3, 3, 10); -- Vehicle 3 carrying 10 units of Item 3

-- Insert sample data into Announcements table
INSERT INTO Announcements (AdminID, DateCreated) VALUES 
(1, '2023-01-01 10:00:00'), -- Admin 1 created an announcement on January 1, 2023
(2, '2023-02-15 14:30:00'); -- Admin 2 created an announcement on February 15, 2023


-- Insert sample data into AnnouncementItems table
INSERT INTO AnnouncementItems (AnnouncementID, ItemID, Quantity) VALUES
(1, 1, 10), -- Announcement 1 includes 10 units of Item 1
(1, 2, 50), -- Announcement 1 includes 50 units of Item 2
(2, 3, 75), -- Announcement 2 includes 75 units of Item 3
(2, 1, 150); -- Announcement 2 includes 150 units of Item 1

-- Test entry for CreateNewRequest procedure
CALL CreateNewRequest(1, '[{"item_id": 7, "quantity": 5}, {"item_id": 2, "quantity": 3}]', 'INPROGRESS');



-- Insert sample data into RequestLogs table
-- Logs can be generated based on updates to Requests

UPDATE Requests SET Status = 'INPROGRESS' WHERE RequestID = 1;
UPDATE Requests SET Status = 'INPROGRESS' WHERE RequestID = 2;



-- Insert sample data into OfferLogs table
-- Logs can be generated based on updates to Offers
UPDATE Offers SET Status = 'INPROGRESS' WHERE OfferID = 1;
UPDATE Offers SET Status = 'INPROGRESS' WHERE OfferID = 2;




-- Example of requests being assigned to rescuers
CALL AssignRequest(1, 1); -- Assigning first request to rescuer1
CALL AssignRequest(2, 1); -- Assigning second request to rescuer1
CALL AssignRequest(3, 1); -- Assigning third request to rescuer1
CALL AssignRequest(4, 1); -- Assigning fourth request to rescuer1

-- This next assignment should trigger the task limit check
CALL AssignRequest(5, 1); -- Attempting to assign fifth request to rescuer1

-- Example of offers being assigned to rescuers
CALL AssignOffer(1, 2); -- Assigning first offer to rescuer1
CALL AssignOffer(2, 2); -- Assigning second offer to rescuer1
CALL AssignOffer(3, 2); -- Assigning third offer to rescuer1
CALL AssignOffer(4, 2); -- Assigning fourth offer to rescuer1
-- This next assignment should trigger the task limit check
CALL AssignOffer(5, 2); -- Attempting to assign fifth offer to rescuer1

-- Example of changing request status
CALL ChangeRequestStatus(1, 'INPROGRESS'); -- Changing status of the first request to INPROGRESS
CALL ChangeRequestStatus(2, 'INPROGRESS'); -- Changing status of the second request to INPROGRESS
CALL ChangeRequestStatus(3, 'INPROGRESS'); -- Changing status of the third request to INPROGRESS
CALL ChangeRequestStatus(4, 'INPROGRESS'); -- Changing status of the fourth request to INPROGRESS

-- Example of changing offer status
CALL ChangeOfferStatus(1, 'PENDING'); -- Changing status of the first offer to INPROGRESS
CALL ChangeOfferStatus(2, 'PENDING'); -- Changing status of the second offer to INPROGRESS
CALL ChangeOfferStatus(3, 'INPROGRESS'); -- Changing status of the third offer to INPROGRESS
CALL ChangeOfferStatus(4, 'INPROGRESS'); -- Changing status of the fourth offer to INPROGRESS


CALL CreateNewRequest(1, '[{"name": "Water", "quantity": 10}, {"name": "Food", "quantity": 5}]', 'PENDING');
CALL CreateNewOffer(1, '[{"name": "Water", "quantity": 10}, {"name": "Food", "quantity": 5}]', 'PENDING');
CALL CreateAnnouncement(1, '[{"name": "Water", "quantity": 10}, {"name": "Food", "quantity": 5}]');
