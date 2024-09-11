<?php
header('Content-Type: application/json');

if (isset($_SERVER['PATH_INFO'])) {
    $rescuer_id = trim($_SERVER['PATH_INFO'], '/'); // Trim leading and trailing slashes
} else {
    echo json_encode(['error' => 'No rescuer ID provided']);
}


include '../../db_config.php';

$data = json_decode(file_get_contents('php://input'), true);

$task_id = $data['task_id'];
$task_type = $data['task_type'];

?>