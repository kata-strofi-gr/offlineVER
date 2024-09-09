<?php
header('Content-Type: application/json');

// Get the citizen name from the URL
if (isset($_SERVER['PATH_INFO'])) {
    $rescuer_id = trim($_SERVER['PATH_INFO'], '/'); // Trim leading and trailing slashes
} else {
    echo json_encode(['error' => 'No rescuer ID provided']);
}

// Include the database configuration file
include '../db_config.php';

// Fetch base location
$base_sql = "
    SELECT BaseName, Latitude, Longitude
    FROM BaseLocation
    LIMIT 1;
";

$base_result = $conn->query($base_sql);
$base_location = $base_result->fetch_assoc();

// Simplified vehicle query with corrected syntax
$vehicles_sql = "
    SELECT 
        v.VehicleID,
        u.Username AS RescuerUsername,
        v.Latitude + 0.0001 AS VehicleLat,
        v.Longitude + 0.0001 AS VehicleLng,
        IFNULL(SUM(vi.Quantity), 0) AS `Load`,
        COUNT(DISTINCT req.RequestID) AS RequestCount,
        COUNT(DISTINCT off.OfferID) AS OfferCount,
        GROUP_CONCAT(DISTINCT req.RequestID) AS AssignedRequests,
        GROUP_CONCAT(DISTINCT off.OfferID) AS AssignedOffers
    FROM Vehicles v
    JOIN Rescuer r ON v.RescuerID = r.RescuerID
    JOIN Users u ON r.UserID = u.UserID
    LEFT JOIN VehicleItems vi ON v.VehicleID = vi.VehicleID
    LEFT JOIN Requests req ON req.RescuerID = r.RescuerID AND req.Status IN ('PENDING', 'INPROGRESS')
    LEFT JOIN Offers off ON off.RescuerID = r.RescuerID AND off.Status IN ('PENDING', 'INPROGRESS')
    GROUP BY v.VehicleID, u.Username, v.Latitude, v.Longitude;
";