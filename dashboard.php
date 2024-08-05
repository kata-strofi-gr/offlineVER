<?php
session_start();
if (!isset($_SESSION['user_id']) && (!isset($_COOKIE['user_id']) || !isset($_COOKIE['username']))) {
    header('Location: start.html');
    exit;
}

// Set session variables if cookies are set
if (!isset($_SESSION['user_id']) && isset($_COOKIE['user_id']) && isset($_COOKIE['username'])) {
    $_SESSION['user_id'] = $_COOKIE['user_id'];
    $_SESSION['username'] = $_COOKIE['username'];
    $_SESSION['role'] = $_COOKIE['role'];

    // Refresh cookie expiration time
    setcookie('user_id', $_COOKIE['user_id'], time() + (10 * 60), "/", "", true, true);
    setcookie('username', $_COOKIE['username'], time() + (10 * 60), "/", "", true, true);
    setcookie('role', $_COOKIE['role'], time() + (10 * 60), "/", "", true, true);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="dashboard.css">
</head>
<body>
    <h1>Welcome, <?php echo htmlspecialchars($_SESSION['username']); ?>!</h1>
    <p>Role: <?php echo htmlspecialchars($_SESSION['role']); ?></p>
    <a href="#" id="logoutButton">Logout</a>

    <!-- Logout Functionality -->
    <script>
    document.getElementById('logoutButton').addEventListener('click', function(e) {
        e.preventDefault();
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'logout.php', true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                window.location.href = 'start.html';
            }
        };
        xhr.send();
    });
    </script>
</body>
</html>
