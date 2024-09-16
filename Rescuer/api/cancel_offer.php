<?php
// Connect to the database
include '../../db_config.php';  // Adjust the path to your DB connection file

// Get the POST data
$data = json_decode(file_get_contents("php://input"), true);
$task_id = $data['task_id'];

// Check if task ID is provided
if (empty($task_id)) {
    echo json_encode(['error' => 'No task ID provided.']);
    exit;
}


// Call the stored procedure to cancel the request
$stmt = $conn->prepare("CALL CancelOffer(?)");
$stmt->bind_param("i", $task_id);

if ($stmt->execute()) {
    echo json_encode(['message' => 'Request canceled successfully.']);
} else {
    echo json_encode(['error' => 'Failed to cancel request.']);
}

$stmt->close();
$conn->close();
?>
