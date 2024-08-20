<?php
$servername = "localhost";
$username = "root";
$password = "0r35t1s21802!";
$dbname = "kata_strofh";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

header('Content-Type: application/json');

// Fetch base location
$base_sql = "
    SELECT BaseName, Latitude, Longitude
    FROM BaseLocation
    LIMIT 1;
";

$base_result = $conn->query($base_sql);
$base_location = $base_result->fetch_assoc();

// Fetch vehicles with only necessary information
$vehicles_sql = "
    SELECT 
        v.VehicleID,
        u.Username AS RescuerUsername,
        v.Latitude + 0.0001 AS VehicleLat,
        v.Longitude + 0.0001 AS VehicleLng
    FROM Vehicles v
    JOIN Rescuer r ON v.RescuerID = r.RescuerID
    JOIN Users u ON r.UserID = u.UserID;
";

$vehicles_result = $conn->query($vehicles_sql);

$vehicles = [];
if ($vehicles_result->num_rows > 0) {
    while ($row = $vehicles_result->fetch_assoc()) {
        $vehicles[] = $row;
    }
}

// Initialize counters for requests and offers
$requestOffsets = [];
$offerOffsets = [];

// Fetch requests excluding 'FINISHED'
$requests_sql = "
    SELECT 
        req.RequestID,
        c.CitizenID,
        c.Name,
        c.Phone,
        req.Status,
        req.DateCreated,
        req.DateAssignedVehicle,
        req.RescuerID,
        u.Username AS RescuerUsername,
        c.Latitude AS RequestLat,
        c.Longitude AS RequestLng
    FROM Requests req
    JOIN Citizen c ON req.CitizenID = c.CitizenID
    LEFT JOIN Rescuer r ON req.RescuerID = r.RescuerID
    LEFT JOIN Users u ON r.UserID = u.UserID
    WHERE req.Status IN ('PENDING', 'INPROGRESS');
";

$requests_result = $conn->query($requests_sql);

$requests = [];
if ($requests_result->num_rows > 0) {
    while ($row = $requests_result->fetch_assoc()) {
        $citizenID = $row['CitizenID'];
        if (!isset($requestOffsets[$citizenID])) {
            $requestOffsets[$citizenID] = 0;
        }
        $requestOffsets[$citizenID] += 1;
        // Apply the offset for requests
        $row['RequestLat'] += $requestOffsets[$citizenID] * 0.00010;
        $row['RequestLng'] += $requestOffsets[$citizenID] * 0.00010;

        $requests[] = $row;
    }
}

// Fetch offers excluding 'FINISHED'
$offers_sql = "
    SELECT 
        off.OfferID,
        c.CitizenID,
        c.Name,
        c.Phone,
        off.Status,
        off.DateCreated,
        off.DateAssignedVehicle,
        off.RescuerID,
        u.Username AS RescuerUsername,
        c.Latitude AS OfferLat,
        c.Longitude AS OfferLng
    FROM Offers off
    JOIN Citizen c ON off.CitizenID = c.CitizenID
    LEFT JOIN Rescuer r ON off.RescuerID = r.RescuerID
    LEFT JOIN Users u ON r.UserID = u.UserID
    WHERE off.Status IN ('PENDING', 'INPROGRESS');
";

$offers_result = $conn->query($offers_sql);

$offers = [];
if ($offers_result->num_rows > 0) {
    while ($row = $offers_result->fetch_assoc()) {
        $citizenID = $row['CitizenID'];
        if (!isset($offerOffsets[$citizenID])) {
            $offerOffsets[$citizenID] = 0;
        }
        $offerOffsets[$citizenID] += 1;


        // Apply the offset for offers
        $row['OfferLat'] += $offerOffsets[$citizenID] * 0.00011;  // Slightly larger offset than requests
        $row['OfferLng'] += $offerOffsets[$citizenID] * 0.00011;

        $offers[] = $row;
    }
}

// Combine all data into one response
$response = [
    'base' => $base_location,
    'vehicles' => $vehicles,
    'requests' => $requests,
    'offers' => $offers,
];

echo json_encode($response);

$conn->close();
?>