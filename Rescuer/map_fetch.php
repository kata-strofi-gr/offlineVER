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

$vehicle_sql = "
    SELECT 
        Latitude + 0.0001 AS VehicleLat,
        Longitude + 0.0001 AS VehicleLng,
        GROUP_CONCAT(DISTINCT req.RequestID) AS AssignedRequests,
        GROUP_CONCAT(DISTINCT off.OfferID) AS AssignedOffers
    FROM Vehicles v
    LEFT JOIN Requests req ON req.RescuerID = v.RescuerID AND req.Status = 'INPROGRESS'
    LEFT JOIN Offers off ON off.RescuerID = v.RescuerID AND off.Status = 'INPROGRESS'
    WHERE v.RescuerID = $rescuer_id
    GROUP BY v.Latitude, v.Longitude
";

$vehicle_result = $conn->query($vehicle_sql);

// assume single vehicle!
$vehicle;
if ($vehicle_result->num_rows > 0) {
    while ($row = $vehicle_result->fetch_assoc()) {
        $vehicle = $row;
    }
}

$unclaimed_and_owned_offers_sql = "
        SELECT 
        off.OfferID, 
        off.CitizenID, 
        off.DateCreated, 
        off.DateAssignedVehicle,
        off.Status,
        cit.Name, 
        cit.Surname, 
        cit.Phone,
        cit.Latitude, 
        cit.Longitude,
        GROUP_CONCAT(offitems.ItemID) AS ItemIDs,
        GROUP_CONCAT(items.Name SEPARATOR ', ') AS ItemNames,
        GROUP_CONCAT(offitems.Quantity SEPARATOR ', ') AS ItemQuantities
    FROM Offers off
    JOIN Citizen cit on cit.CitizenID = off.CitizenID
    LEFT JOIN OfferItems offitems on off.OfferID = offitems.OfferID
    LEFT JOIN Items on offitems.ItemID = Items.ItemID
    WHERE off.RescuerID is null or off.RescuerID = $rescuer_id
    GROUP BY off.OfferID, 
        off.CitizenID, 
        off.DateCreated, 
        off.Status,
        cit.Name, 
        cit.Surname, 
        cit.Phone,
        cit.Latitude, 
        cit.Longitude

";

$unclaimed_and_owned_offers_result = $conn->query($unclaimed_and_owned_offers_sql);
$unclaimed_and_owned_offers = [];
$offerOffsets = []; // for unstacking offers from the same citizen

if ($unclaimed_and_owned_offers_result->num_rows > 0) {
    while ($row = $unclaimed_and_owned_offers_result->fetch_assoc()) {
        $citizenID = $row['CitizenID'];

        // Increment the offset for this citizen's offers
        if (!isset($offerOffsets[$citizenID])) {
            $offerOffsets[$citizenID] = 0;
        }
        $offerOffsets[$citizenID] += 1;

        // Apply the offset for offers
        $row['Latitude'] += $offerOffsets[$citizenID] * 0.0000678;
        $row['Longitude'] += $offerOffsets[$citizenID] * 0.0000570;

        $unclaimed_and_owned_offers[] = $row;
    }
}


$unclaimed_and_owned_requests_sql = "
    SELECT 
        req.RequestID, 
        req.CitizenID, 
        req.DateCreated, 
        req.DateAssignedVehicle,
        req.Status,
        cit.Name, 
        cit.Surname, 
        cit.Phone,
        cit.Latitude, 
        cit.Longitude,
        GROUP_CONCAT(reqItems.ItemID) AS ItemIDs,
        GROUP_CONCAT(items.Name SEPARATOR ', ') AS ItemNames,
        GROUP_CONCAT(reqItems.Quantity SEPARATOR ', ') AS ItemQuantities
    FROM Requests req
    JOIN Citizen cit on cit.CitizenID = req.CitizenID
    LEFT JOIN RequestItems reqitems on req.RequestID = reqitems.RequestID
    LEFT JOIN Items on reqitems.ItemID = Items.ItemID
    WHERE req.RescuerID is null or req.RescuerID = $rescuer_id
    GROUP BY req.RequestID, 
        req.RequestID, 
        req.CitizenID, 
        req.DateCreated, 
        req.Status,
        cit.Name, 
        cit.Surname, 
        cit.Phone,
        cit.Latitude, 
        cit.Longitude
";

$unclaimed_and_owned_requests_result = $conn->query($unclaimed_and_owned_requests_sql);
$unclaimed_and_owned_requests = [];
$requestOffsets = []; // for unstacking requests from the same citizen

if ($unclaimed_and_owned_requests_result->num_rows > 0) {
    while ($row = $unclaimed_and_owned_requests_result->fetch_assoc()) {
        $citizenID = $row['CitizenID'];

        // Increment the offset for this citizen's requests
        if (!isset($requestOffsets[$citizenID])) {
            $requestOffsets[$citizenID] = 0;
        }
        $requestOffsets[$citizenID] += 1;

        // Apply the offset for requests
        $row['Latitude'] += $requestOffsets[$citizenID] * 0.0000608;
        $row['Longitude'] += $requestOffsets[$citizenID] * 0.00006555;

        $unclaimed_and_owned_requests[] = $row;
    }
}

// Combine all data into one response
$response = [
    'base' => $base_location,
    'vehicle' => $vehicle,
    'requests' => $unclaimed_and_owned_requests,
    'offers' => $unclaimed_and_owned_offers,
];

echo json_encode($response);
$conn->close();
