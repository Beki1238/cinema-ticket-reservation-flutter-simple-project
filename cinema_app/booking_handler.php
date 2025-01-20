<?php
// booking_handler.php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

header("Content-Type: application/json");
$connection = new mysqli("localhost", "root", "", "th_ctms");

if ($connection->connect_error) {
    die(json_encode(["error" => "Database connection failed"]));
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $customer_id = $_POST['customer_id'];
    $showtime_id = $_POST['showtime_id'];
    $room = $_POST['room'];
    $payment_method = $_POST['payment_method'];
    $seats = $_POST['seats'];

    // Check if the customer is logged in
    $checkCustomer = $conn->prepare("SELECT id FROM customers WHERE id = ?");
    $checkCustomer->bind_param("i", $customer_id);
    $checkCustomer->execute();
    $result = $checkCustomer->get_result();

    if ($result->num_rows == 0) {
        echo json_encode(['status' => 'error', 'message' => 'Please log in first.']);
        exit;
    }

    // Calculate the total price based on the room and seats
    $roomPrices = ['vip' => 30, 'main' => 50, 'vvip' => 60];
    $total_price = $roomPrices[$room] * $seats;

    // Insert the booking into the database
    $insertBooking = $conn->prepare("INSERT INTO bookings (customer_id, showtime_id, status, payment_status, total_price, created_at) VALUES (?, ?, 'pending', 'pending', ?, NOW())");
    $insertBooking->bind_param("iid", $customer_id, $showtime_id, $total_price);

    if ($insertBooking->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Booking successful!']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to book. Please try again.']);
    }
}
?>
