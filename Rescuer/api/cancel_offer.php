<?php
// Include the database connection
include '../../db_config.php';

// Get the POST data
$data = json_decode(file_get_contents("php://input"), true);
$task_id = $data['task_id'];

// Check if task ID is provided
if (empty($task_id)) {
    echo json_encode(['error' => 'No task ID provided.']);
    exit;
}

// Prepare the SQL statement to call the CancelOffer procedure
$stmt = $conn->prepare("CALL CancelOffer(?)");
$stmt->bind_param("i", $task_id);

// Execute the query and return the result
if ($stmt->execute()) {
    echo json_encode(['message' => 'Offer canceled successfully.']);
} else {
    echo json_encode(['error' => 'Failed to cancel offer.']);
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
