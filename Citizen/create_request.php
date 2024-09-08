<?php
header('Content-Type: application/json');

// Include the database configuration file
include '../db_config.php';

// TODO: multiple items
$citizen_id = rtrim($_POST['citizen_id']);
$items = rtrim($_POST['items']);
$people = rtrim($_POST['people']);
$quantity = $people * 10; //TODO: quantity per person

// Call the stored procedure
try {
    // Call the stored procedure to create a new rescuer and a vehicle
    $stmt = $conn->prepare("CALL CreateNewRequest(?, ?, ?, ?)");
    $stmt->bind_param("iiss", $citizen_id, $people, $items, $quantity);
    $stmt->execute();

    echo json_encode(['success' => true, 'message' => 'Request created succesfuly']);
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    $stmt->close();
    $conn->close();
}

?>