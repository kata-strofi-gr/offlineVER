<?php
// db_config.php

$host = 'localhost';
$db = 'kata_strofhh';
$user = 'root';
$pass = '0r35t1s21802!';
$charset = 'utf8mb4';

$conn = new mysqli($host, $user, $pass, $db);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['success' => false, 'message' => 'Connection failed: ' . $conn->connect_error]));
}
?>
