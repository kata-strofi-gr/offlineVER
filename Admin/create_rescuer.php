<?php
header('Content-Type: application/json');

// Include the database configuration file
include '../db_config.php';

// Retrieve base location from the database
$baseLocationQuery = "SELECT Latitude, Longitude FROM BaseLocation LIMIT 1";
$result = $conn->query($baseLocationQuery);

if ($result->num_rows > 0) {
    $baseLocation = $result->fetch_assoc();
    $base_latitude = $baseLocation['Latitude'];
    $base_longitude = $baseLocation['Longitude'];
} else {
    die(json_encode(['success' => false, 'message' => 'Base location not found']));
}

// Retrieve data from POST request
$username = $_POST['username'];
$password = $_POST['password'];

// Calculate vehicle's latitude and longitude with offset (125% of the base location)
$latitude = $base_latitude + 0.00001;
$longitude = $base_longitude + 0.00001;

try {
    // Call the stored procedure to create a new rescuer
    $stmt = $conn->prepare("CALL CreateNewRescuer(?, ?, ?, ?)");
    $stmt->bind_param("ssdd", $username, $password, $latitude, $longitude);
    $stmt->execute();

    echo json_encode(['success' => true, 'message' => 'Rescuer account created successfully']);
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    $stmt->close();
    $conn->close();
}
