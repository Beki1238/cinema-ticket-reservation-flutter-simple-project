import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static Future<Map<String, dynamic>?> fetchUserDetails(int userId) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/cinema_app/fetch_user.php"), // Update with your server URL
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return {
            'name': data['data']['name'],
            'email': data['data']['email'],
            'profile_image_url': data['data']['profile_image_url'],
          };
        } else {
          print("Error: ${data['message']}");
          return null;
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Network Error: $e");
      return null;
    }
  }
}
