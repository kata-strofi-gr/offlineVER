
CREATE DATABASE IF NOT EXISTS kata_strofh
    DEFAULT CHARACTER SET = 'utf8mb4'
    DEFAULT COLLATE = 'utf8mb4_unicode_ci';

USE kata_strofh;

-- Administrator Table
CREATE TABLE Administrator (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(60) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    UNIQUE INDEX (Username)
) ENGINE=InnoDB;


-- Rescuer Table
CREATE TABLE Rescuer (
    RescuerID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    UNIQUE INDEX (Username)
) ENGINE=InnoDB;

-- Citizen Table
CREATE TABLE Citizen (
    CitizenID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Surname VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Latitude DECIMAL(10, 8) NOT NULL,
    Longitude DECIMAL(11, 8) NOT NULL,
    UNIQUE INDEX (Username)
) ENGINE=InnoDB;

-- Items Table
CREATE TABLE Items (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    Category VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    UNIQUE INDEX (Name)
) ENGINE=InnoDB;

-- Warehouse Table
CREATE TABLE Warehouse (
    ItemID INT,
    Quantity INT NOT NULL,
    PRIMARY KEY (ItemID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Requests Table
CREATE TABLE Requests (
    RequestID INT AUTO_INCREMENT PRIMARY KEY,
    CitizenID INT,
    Status ENUM('PENDING', 'INPROGRESS', 'FINISHED') NOT NULL,
    DateCreated DATETIME NOT NULL,
    DateAssignedVehicle DATETIME,
    RescuerID INT,
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID) ON DELETE CASCADE,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE SET NULL,
    INDEX (CitizenID),
    INDEX (RescuerID),
    INDEX (Status),
    INDEX (DateCreated),
    INDEX (DateAssignedVehicle)
) ENGINE=InnoDB;

-- RequestItems Table to handle multiple items per request
CREATE TABLE RequestItems (
    RequestItemID INT AUTO_INCREMENT PRIMARY KEY,
    RequestID INT,
    ItemID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    INDEX (RequestID),
    INDEX (ItemID)
) ENGINE=InnoDB;

-- Offers Table
CREATE TABLE Offers (
    OfferID INT AUTO_INCREMENT PRIMARY KEY,
    CitizenID INT,
    Status ENUM('PENDING', 'INPROGRESS', 'FINISHED') NOT NULL,
    DateCreated DATETIME NOT NULL,
    DateAssigned DATETIME,
    RescuerID INT,
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID) ON DELETE CASCADE,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE SET NULL,
    INDEX (CitizenID),
    INDEX (RescuerID),
    INDEX (Status),
    INDEX (DateCreated),
    INDEX (DateAssigned)
) ENGINE=InnoDB;

-- OfferItems Table to handle multiple items per offer
CREATE TABLE OfferItems (
    OfferItemID INT AUTO_INCREMENT PRIMARY KEY,
    OfferID INT,
    ItemID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (OfferID) REFERENCES Offers(OfferID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    INDEX (OfferID),
    INDEX (ItemID)
) ENGINE=InnoDB;

-- Vehicles Table
CREATE TABLE Vehicles (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    RescuerID INT,
    Latitude DECIMAL(10, 8) NOT NULL,
    Longitude DECIMAL(11, 8) NOT NULL,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE CASCADE,
    INDEX (RescuerID)
) ENGINE=InnoDB;

-- VehicleItems Table to handle multiple items per vehicle
CREATE TABLE VehicleItems (
    VehicleItemID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleID INT,
    ItemID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    INDEX (VehicleID),
    INDEX (ItemID)
) ENGINE=InnoDB;


-- Announcements Table
CREATE TABLE Announcements (
    AnnouncementID INT AUTO_INCREMENT PRIMARY KEY,
    AdminID INT,
    DateCreated DATETIME NOT NULL,
    FOREIGN KEY (AdminID) REFERENCES Administrator(AdminID) ON DELETE CASCADE,
    INDEX (AdminID),
    INDEX (DateCreated)
) ENGINE=InnoDB;

-- AnnouncementItems Table to handle multiple items per announcement
CREATE TABLE AnnouncementItems (
    AnnouncementItemID INT AUTO_INCREMENT PRIMARY KEY,
    AnnouncementID INT,
    ItemID INT,
    Quantity INT NOT NULL,
    FOREIGN KEY (AnnouncementID) REFERENCES Announcements(AnnouncementID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    INDEX (AnnouncementID),
    INDEX (ItemID)
) ENGINE=InnoDB;

-- RequestHistory Table
CREATE TABLE RequestHistory (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    RequestID INT,
    ChangeType VARCHAR(50),
    ChangeTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    OldStatus ENUM('PENDING', 'INPROGRESS', 'FINISHED'),
    NewStatus ENUM('PENDING', 'INPROGRESS', 'FINISHED'),
    OldRescuerID INT,
    NewRescuerID INT,
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID)
) ENGINE=InnoDB;

-- OfferHistory Table
CREATE TABLE OfferHistory (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    OfferID INT,
    ChangeType VARCHAR(50),
    ChangeTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    OldStatus ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED'),
    NewStatus ENUM('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED'),
    OldRescuerID INT,
    NewRescuerID INT,
    FOREIGN KEY (OfferID) REFERENCES Offers(OfferID)
) ENGINE=InnoDB;


DROP DATABASE kata_strofh;
