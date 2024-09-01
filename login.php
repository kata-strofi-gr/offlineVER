<?php
header('Content-Type: application/json');

// Include the database configuration file
include 'db_config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $inputUsername = $_POST['username'];
    $inputPassword = $_POST['password'];

    error_log("Received login request for username: " . $inputUsername);

    $sql = "SELECT UserID, Password, Role FROM Users WHERE Username = ?";
    $stmt = $conn->prepare($sql);
    
    if ($stmt === false) {
        error_log("SQL prepare failed: " . $conn->error);
        die(json_encode(['success' => false, 'message' => 'Database error']));
    }

    $stmt->bind_param('s', $inputUsername);
    $stmt->execute();
    $stmt->store_result();
    
    error_log("Number of rows found: " . $stmt->num_rows);

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($userID, $storedPassword, $role);
        $stmt->fetch();
        
        error_log("Fetched user data: userID=" . $userID . ", role=" . $role);

        if ($inputPassword === $storedPassword) {
            error_log("Password verification successful for username: " . $inputUsername);
            echo json_encode(['success' => true, 'role' => $role, 'userID' => $userID]);
        } else {
            error_log("Password verification failed for username: " . $inputUsername);
            echo json_encode(['success' => false, 'message' => 'Invalid password']);
        }
    } else {
        error_log("Username not found: " . $inputUsername);
        echo json_encode(['success' => false, 'message' => 'Username not found']);
    }
    $stmt->close();
} else {
    error_log("Invalid request method: " . $_SERVER['REQUEST_METHOD']);
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}

$conn->close();
?>

