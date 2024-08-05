<?php
session_start();
include 'database.php';

// Define your secret key
$secret_key = 'your-very-secure-and-random-secret-key';
$encryption_key = base64_encode($secret_key);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Decrypt the incoming data
    $encrypted_data = $_POST['data'];
    $decrypted_data = decrypt($encrypted_data, $encryption_key);
    $credentials = json_decode($decrypted_data, true);

    $username = $credentials['username'];
    $password = $credentials['password'];

    $query = "SELECT * FROM Users WHERE Username = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param('s', $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 1) {
        $user = $result->fetch_assoc();
        if (password_verify($password, $user['Password'])) {
            $_SESSION['user_id'] = $user['UserID'];
            $_SESSION['username'] = $user['Username'];
            $_SESSION['role'] = $user['Role'];

            // Set cookies for authentication with 10-minute expiration
            setcookie('user_id', $user['UserID'], time() + (10 * 60), "/", "", true, true);
            setcookie('username', $user['Username'], time() + (10 * 60), "/", "", true, true);
            setcookie('role', $user['Role'], time() + (10 * 60), "/", "", true, true);

            // Determine redirect URL based on role
            $redirectUrl = 'dashboard.php';
            if ($user['Role'] == 'Administrator') {
                $redirectUrl = 'admin.html';
            }

            // Prepare the success response
            $response = json_encode(['success' => true, 'redirect' => $redirectUrl]);
            $encrypted_response = encrypt($response, $encryption_key);
            echo json_encode(['data' => $encrypted_response]);
        } else {
            $response = json_encode(['success' => false, 'message' => 'Invalid password']);
            $encrypted_response = encrypt($response, $encryption_key);
            echo json_encode(['data' => $encrypted_response]);
        }
    } else {
        $response = json_encode(['success' => false, 'message' => 'Invalid username']);
        $encrypted_response = encrypt($response, $encryption_key);
        echo json_encode(['data' => $encrypted_response]);
    }
}

function encrypt($data, $key) {
    $encryption_key = base64_decode($key);
    $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length('aes-256-cbc'));
    $encrypted = openssl_encrypt($data, 'aes-256-cbc', $encryption_key, 0, $iv);
    return base64_encode($encrypted . '::' . $iv);
}

function decrypt($data, $key) {
    $encryption_key = base64_decode($key);
    list($encrypted_data, $iv) = explode('::', base64_decode($data), 2);
    return openssl_decrypt($encrypted_data, 'aes-256-cbc', $encryption_key, 0, $iv);
}
?>
