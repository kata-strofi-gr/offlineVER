<?php
session_start();
header('Content-Type: application/json');
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "kata_strofh";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    error_log("Database connection failed: " . $conn->connect_error);
    die(json_encode(['success' => false, 'message' => 'Database connection failed']));
}

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
        $stmt->bind_result($userID, $hashedPassword, $role);
        $stmt->fetch();
        
        error_log("Fetched user data: userID=" . $userID . ", role=" . $role);
        error_log("Stored hashed password: " . $hashedPassword);

        if (($inputPassword === $storedPassword)) {
            error_log("Password verification successful for username: " . $inputUsername);

            // Set session variables
            $_SESSION['loggedin'] = true;
            $_SESSION['username'] = $inputUsername;
            $_SESSION['role'] = $role;
            $_SESSION['last_activity'] = time(); // record login time

            // Set a cookie for session management
            setcookie("username", $inputUsername, time() + (10 * 60), "/"); // 10-minute expiration

            echo json_encode(['success' => true, 'role' => $role]);
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
