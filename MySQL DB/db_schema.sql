
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
    Location VARCHAR(100) NOT NULL,
    UNIQUE INDEX (Username)
) ENGINE=InnoDB;

-- Citizen Table
CREATE TABLE Citizen (
    CitizenID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Location VARCHAR(100) NOT NULL,
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
    ItemID INT,
    Quantity INT NOT NULL,
    Status ENUM('PENDING', 'INPROGRESS', 'FINISHED') NOT NULL,
    DateCreated DATETIME NOT NULL,
    DateAssignedVehicle DATETIME,
    RescuerID INT,
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE SET NULL,
    INDEX (CitizenID),
    INDEX (RescuerID),
    INDEX (Status),
    INDEX (ItemID),
    INDEX (DateCreated),
    INDEX (DateAssignedVehicle)
) ENGINE=InnoDB;


-- Offers Table
CREATE TABLE Offers (
    OfferID INT AUTO_INCREMENT PRIMARY KEY,
    CitizenID INT,
    ItemID INT,
    Quantity INT NOT NULL,
    Status ENUM('PENDING', 'INPROGRESS', 'FINISHED') NOT NULL,
    DateCreated DATETIME NOT NULL,
    DateAssigned DATETIME,
    RescuerID INT,
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE SET NULL,
    INDEX (CitizenID),
    INDEX (RescuerID),
    INDEX (Status),
    INDEX (ItemID),
    INDEX (DateCreated),
    INDEX (DateAssigned)
) ENGINE=InnoDB;

-- Vehicles Table
CREATE TABLE Vehicles (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    RescuerID INT,
    CurrentLoad INT NOT NULL,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE CASCADE,
    INDEX (RescuerID)
) ENGINE=InnoDB;


-- Announcements Table
CREATE TABLE Announcements (
    AnnouncementID INT AUTO_INCREMENT PRIMARY KEY,
    AdminID INT,
    ItemID INT,
    DateCreated DATETIME NOT NULL,
    Message TEXT NOT NULL,
    FOREIGN KEY (AdminID) REFERENCES Administrator(AdminID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    INDEX (AdminID),
    INDEX (ItemID),
    INDEX (DateCreated)
) ENGINE=InnoDB;

CREATE TABLE RequestLogs (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    RequestID INT,
    CitizenID INT,
    ItemID INT,
    Quantity INT,
    Status VARCHAR(20),
    DateCreated DATETIME,
    DateAssigned DATETIME,
    RescuerID INT,
    ChangeDate DATETIME,
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID) ON DELETE CASCADE,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE SET NULL,
    INDEX (RequestID),
    INDEX (CitizenID),
    INDEX (ItemID),
    INDEX (Status),
    INDEX (DateCreated),
    INDEX (DateAssigned),
    INDEX (RescuerID),
    INDEX (ChangeDate)
) ENGINE=InnoDB;


-- Create OfferLogs Table for auditing changes in offers
CREATE TABLE OfferLogs (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    OfferID INT,
    CitizenID INT,
    ItemID INT,
    Quantity INT,
    Status VARCHAR(20),
    DateCreated DATETIME,
    DateAssigned DATETIME,
    RescuerID INT,
    ChangeDate DATETIME,
    FOREIGN KEY (OfferID) REFERENCES Offers(OfferID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE,
    FOREIGN KEY (CitizenID) REFERENCES Citizen(CitizenID) ON DELETE CASCADE,
    FOREIGN KEY (RescuerID) REFERENCES Rescuer(RescuerID) ON DELETE SET NULL,
    INDEX (OfferID),
    INDEX (CitizenID),
    INDEX (ItemID),
    INDEX (Status),
    INDEX (DateCreated),
    INDEX (DateAssigned),
    INDEX (RescuerID),
    INDEX (ChangeDate)
) ENGINE=InnoDB;


DROP DATABASE kata_strofh;
