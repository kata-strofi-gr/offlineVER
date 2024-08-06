<?php
$servername = "localhost";
$username = "root";
$password = "0r35t1s21802!";
$dbname = "kata_strofh";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>

