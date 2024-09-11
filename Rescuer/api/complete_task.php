<?php

// get id from url
if (isset($_SERVER['PATH_INFO'])) {
    $rescuer_id = trim($_SERVER['PATH_INFO'], '/');
} else {
    echo json_encode(['error' => 'No citizen ID provided']);
}

// Include the database configuration file
include '../../db_config.php';

// Get the JSON input
$data = json_decode(file_get_contents('php://input'), true);

$task_id = $data['task_id'];
$task_type = $data['task_type'];

if ($task_type == 'Request') {
    // Call the stored procedure to complete the task
    $sql = "CALL FinishRequest(?)";
    
} else if ($task_type == 'Offer') {
    // Call the stored procedure to complete the task
    $sql = "CALL FinishOffer(?)";

} else {
    echo json_encode(['error' => 'Invalid task type']);
    $conn->close();
    return;
}

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $task_id);

$response = [];

if ($stmt->execute()) {
    $response['success'] = true;
    // show id in task
    $response['message'] = 'Task id: ' . $task_id . ' completed';
} else {
    $response['success'] = false;
    $response['error'] = $stmt->error;
}

echo json_encode($response);

$conn->close();
?>
