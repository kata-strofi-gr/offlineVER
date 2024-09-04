<?php
session_start();
session_unset();    // Unset all session variables
session_destroy();  // Destroy the session
setcookie('admin_id', '', time() - 3600, "/", "", true, true);  // Expire the admin_id cookie

echo 'Logged out successfully';
?>
