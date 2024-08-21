<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');
$servername = "localhost";
$username = "root";
$password = "0r35t1s21802!";
$dbname = "kata_strofh";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Database connection failed: ' . $conn->connect_error]));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $inputUsername = $_POST['username'];
    $inputPassword = $_POST['password'];
    $firstName = $_POST['firstName'];
    $lastName = $_POST['lastName'];
    $phoneNumber = $_POST['phoneNumber'];
    $latitude = isset($_POST['latitude']) ? $_POST['latitude'] : null;
    $longitude = isset($_POST['longitude']) ? $_POST['longitude'] : null;


    $stmt = $conn->prepare("CALL CreateNewCitizen(?, ?, ?, ?, ?, ?, ?)");
    if ($stmt === false) {
        die(json_encode(['success' => false, 'message' => 'Prepare failed: ' . $conn->error]));
    }

    $stmt->bind_param('sssssss', $inputUsername, $inputPassword, $firstName, $lastName, $phoneNumber, $latitude, $longitude);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'User registered successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Execute failed: ' . $stmt->error]);
    }

    $stmt->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}

$conn->close();
?>