USE kata_strofh;

-- Test entry to create a new rescuer
CALL CreateNewRescuer('john_dwoe', 'securepassword123', 23.79206500, 23.79188600);
CALL CreateNewRescuer('Sjanec_doe', 'securepassworcd456',38.04616300, 23.79643000);
CALL CreateNewRescuer('ssmitDh', 'securepassword789', 38.04459300, 23.78110400);

-- Test entry to create a new citizen
CALL CreateNewCitizen('jane_doce', 'securepassword456', 'Jane', 'Doe', '123-456-7890', 38.04161800, 23.78762700);
CALL CreateNewCitizen('john_dose', 'securepassword123', 'John', 'Doe', '987-654-3210', 38.03932500, 23.79466300);
CALL CreateNewCitizen('alixce_smith', 'securepassword789', 'Alice', 'Smith', '555-555-5555', 38.04173700, 23.79206500);

-- Test entry to create a new admin
CALL CreateNewAdmin('admin_user', 'adminpassword');
CALL CreateNewAdmin('admin_muser2', 'adminpassword2');
CALL CreateNewAdmin('admin_user3', 'adminpassword3');

-- Insert test data into Category table
INSERT INTO Category (CategoryName) VALUES
('Food'),
('Medicine'),
('Clothing');

-- Insert test data into Items table
INSERT INTO Items (CategoryID, Name, DetailName, DetailValue) VALUES
(1, 'Rice', 'volume', '1kg bag of rice'),
(1, 'Bread', 'quantity', '1 loaf of bread'),
(2, 'Aspirin', 'Pack of', '4'),
(2, 'Band-Aid', 'Pack of', '10'),
(3, 'Shirt', 'Size', 'M'),
(3, 'Jacket', 'Size', 'L');


-- Insert test data into Warehouse table
INSERT INTO Warehouse (ItemID, Quantity) VALUES
(1, 100), -- 100 units of Rice
(2, 50),  -- 50 units of Bread
(3, 70),  -- 70 units of Aspirin
(4, 33),  -- 33 units of Band-Aid
(5, 33),  -- 33 units of Shirt
(6, 696969); -- 696969 units of Jacket


-- Insert sample data into Requests table
INSERT INTO Requests (CitizenID,NumberofPeople,Status, DateCreated) VALUES 
(1,1, 'PENDING', NOW()), -- John Doe requesting Rice
(2,1, 'PENDING', NOW()),  -- Jane Doe requesting Aspirin
(3,1, 'PENDING', NOW()),  -- Alice Smith requesting Blanket
(1,1, 'PENDING', NOW()),  -- John Doe requesting Aspirin
(2,1, 'PENDING', NOW()),  -- Jane Doe requesting Blanket
(3,1, 'PENDING', NOW());  -- Alice Smith requesting Rice

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
(1, 37.774929, -12.419418), -- Rescuer 1 in San Francisco
(2, 34.052235, -18.243683), -- Rescuer 2 in Los Angeles
(3, 40.712776, -4.005974);  -- Rescuer 3 in New York

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

-- Insert initial base location
INSERT INTO BaseLocation (BaseName, Latitude, Longitude)
VALUES ('Main Base', 38.04035147, 23.78224611);

-- Insert sample data into AnnouncementItems table
INSERT INTO AnnouncementItems (AnnouncementID, ItemID, Quantity) VALUES
(1, 1, 10), -- Announcement 1 includes 10 units of Item 1
(1, 2, 50), -- Announcement 1 includes 50 units of Item 2
(2, 3, 75), -- Announcement 2 includes 75 units of Item 3
(2, 1, 150); -- Announcement 2 includes 150 units of Item 1


-- Test entry for CreateNewRequest procedure


CALL CreateNewRequest(
    2,      
    10,               -- Citizen ID
    'Rice,Rice,Rice,Blanket,Blanket,Blanket,Blanket', -- Comma-separated item names
    '100,50,70,33,33,696969,4'             -- Corresponding quantities
);

-- Test entry for CreateNewOffer procedure
CALL CreateNewOffer(
    2,                      -- Citizen ID
    'Rice,Blanket,Blanket', -- Comma-separated item names
    '69,5,3'           -- Corresponding quantities
);

-- Test entry for CreateAnnouncement procedure
CALL CreateNewAnnouncement(1, 
    'Rice,Aspirin,Blanket', -- Comma-separated item names
    '100,50,70'             -- Corresponding quantities
);



-- Example of requests being assigned to rescuers
CALL AssignRequest(1, 2); -- Assigning first request to rescuer1
CALL AssignRequest(1, 3); -- Assigning second request to rescuer1
CALL AssignRequest(1, 3); -- Assigning third request to rescuer1
CALL AssignRequest(89, 1); -- Assigning fourth request to rescuer1

-- This next assignment should trigger the task limit check
CALL AssignRequest(1, 1); -- Attempting to assign fifth request to rescuer1

-- Example of offers being assigned to rescuers
CALL AssignOffer(30, 3); -- Assigning first offer to rescuer1
CALL AssignOffer(2, 3); -- Assigning second offer to rescuer1
CALL AssignOffer(3, 3); -- Assigning third offer to rescuer1
CALL AssignOffer(4, 3); -- Assigning fourth offer to rescuer1
-- This next assignment should trigger the task limit check
CALL AssignOffer(4, 3); -- Attempting to assign fifth offer to rescuer1

CALL CancelRequest(1);

CALL CancelOffer(1);

CALL FinishRequest(89);

CALL FinishOffer(30);





