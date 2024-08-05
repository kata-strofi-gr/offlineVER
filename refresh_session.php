<?php
session_start();

if (isset($_SESSION['user_id'])) {
    // Refresh cookie expiration time
    setcookie('user_id', $_SESSION['user_id'], time() + (10 * 60), "/", "", true, true);
    setcookie('username', $_SESSION['username'], time() + (10 * 60), "/", "", true, true);
    setcookie('role', $_SESSION['role'], time() + (10 * 60), "/", "", true, true);
}
?>
