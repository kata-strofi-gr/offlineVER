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

// Get the JSON input
$data = json_decode(file_get_contents('php://input'), true);

$latitude = $data['latitude'];
$longitude = $data['longitude'];

// Prepare and execute the update statement
$sql = "UPDATE BaseLocation SET Latitude = ?, Longitude = ? WHERE BaseID = 1"; // Assuming there's only one base

$stmt = $conn->prepare($sql);
$stmt->bind_param('dd', $latitude, $longitude);

$response = [];

if ($stmt->execute()) {
    $response['success'] = true;
} else {
    $response['success'] = false;
    $response['error'] = $stmt->error;
}

echo json_encode($response);

$conn->close();
?>
