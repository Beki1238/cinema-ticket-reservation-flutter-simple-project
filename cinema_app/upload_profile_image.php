<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include "db_connection.php";

$user_id = $_POST['user_id'];

if (isset($_FILES['profile_image'])) {
    $target_dir = "uploads/";
    $file_name = basename($_FILES['profile_image']['name']);
    $target_file = $target_dir . uniqid() . "_" . $file_name;

    if (move_uploaded_file($_FILES['profile_image']['tmp_name'], $target_file)) {
        $url = "http://your-server/$target_file"; // Replace with your server URL

        $sql = "UPDATE customer SET profile_image_url = ? WHERE id = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("si", $url, $user_id);

        if ($stmt->execute()) {
            echo json_encode(["success" => true, "profile_image_url" => $url]);
        } else {
            echo json_encode(["success" => false, "message" => $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Failed to upload image"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "No image uploaded"]);
}

$conn->close();
?>
