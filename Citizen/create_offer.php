<?php
header('Content-Type: application/json');

// Include the database configuration file
include '../db_config.php';

$citizen_id = rtrim($_POST['citizen_id']);
$items = rtrim($_POST['items']);
$quantities = rtrim($_POST['quantities']);

// error_log("citizen_id: $citizen_id, items: $items, quantities: $quantities");
// Call the stored procedure
try {
    // Call the stored procedure to create a new rescuer and a vehicle
    $stmt = $conn->prepare("CALL CreateNewOffer(?, ?, ?)");
    $stmt->bind_param("iss", $citizen_id, $items, $quantities);
    $stmt->execute();

    echo json_encode(['success' => true, 'message' => 'Request created succesfuly']);
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
} finally {
    $stmt->close();
    $conn->close();
}

?>