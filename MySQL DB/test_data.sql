USE kata_strofh;

-- Insert sample data into Administrator table
INSERT INTO Administrator (Username, Password) VALUES 
('admin1', 'password1'),
('admin2', 'password2');

-- Insert sample data into Rescuer table
INSERT INTO Rescuer (Username, Password, Location) VALUES 
('rescuer1', 'password1', 'Location1'),
('rescuer2', 'password2', 'Location2'),
('rescuer3', 'password3', 'Location3');

-- Insert sample data into Citizen table
INSERT INTO Citizen (Username, Password, Name, Phone, Location) VALUES 
('citizen1', 'password1', 'John Doe', '1234567890', 'LocationA'),
('citizen2', 'password2', 'Jane Doe', '0987654321', 'LocationB'),
('citizen3', 'password3', 'Alice Smith', '1112223333', 'LocationC');

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
INSERT INTO Requests (CitizenID, ItemID, Quantity, Status, DateCreated) VALUES 
(1, 1, 10, 'PENDING', NOW()), -- John Doe requesting Rice
(2, 2, 5, 'PENDING', NOW()),  -- Jane Doe requesting Aspirin
(3, 3, 2, 'PENDING', NOW()),  -- Alice Smith requesting Blanket
(1, 2, 3, 'PENDING', NOW()),  -- John Doe requesting Aspirin
(2, 3, 1, 'PENDING', NOW()),  -- Jane Doe requesting Blanket
(3, 1, 5, 'PENDING', NOW());  -- Alice Smith requesting Rice

-- Insert sample data into Offers table
INSERT INTO Offers (CitizenID, ItemID, Quantity, Status, DateCreated) VALUES 
(1, 1, 15, 'PENDING', NOW()), -- John Doe offering Rice
(2, 2, 8, 'PENDING', NOW()),  -- Jane Doe offering Aspirin
(3, 3, 4, 'PENDING', NOW()),  -- Alice Smith offering Blanket
(1, 3, 10, 'PENDING', NOW()), -- John Doe offering Blanket
(2, 1, 7, 'PENDING', NOW()),  -- Jane Doe offering Rice
(3, 2, 2, 'PENDING', NOW());  -- Alice Smith offering Aspirin

-- Insert sample data into Vehicles table
INSERT INTO Vehicles (RescuerID, CurrentLoad) VALUES 
(1, 0), -- Vehicle for rescuer1
(2, 0), -- Vehicle for rescuer2
(3, 0); -- Vehicle for rescuer3

-- Insert sample data into Announcements table
INSERT INTO Announcements (AdminID, ItemID, DateCreated, Message) VALUES 
(1, 1, NOW(), 'New shipment of rice available.'),
(2, 2, NOW(), 'Aspirin is now in stock.'),
(1, 3, NOW(), 'Warm blankets available for winter.');



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
