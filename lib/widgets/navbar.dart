import 'package:flutter/material.dart';
//import '../utils/session_manager.dart';
import '../screens/profile.dart';
import '../screens/feedback.dart';
import '../screens/settings.dart';
import '../screens/help.dart';
import '../screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../utils/session_manager.dart';


class NavBar extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onLogout;

  const NavBar({
    Key? key,
    required this.isLoggedIn,
    required this.onLogout, String? userName, String? userEmail,
  }) : super(key: key);

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userName': prefs.getString('userName') ?? 'Guest',
      'userEmail': prefs.getString('userEmail') ?? 'guest@example.com',
      'userImageUrl': prefs.getString('userImageUrl') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, String>>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userName = snapshot.data!['userName'];
          final userEmail = snapshot.data!['userEmail'];
          final userImageUrl = snapshot.data!['userImageUrl'];

          return ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  userName!,
                  style: const TextStyle(color: Colors.red),
                ),
                accountEmail: Text(
                  userEmail!,
                  style: const TextStyle(color: Colors.red),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.red,
                  backgroundImage:
                      userImageUrl!.isNotEmpty ? NetworkImage(userImageUrl) : null,
                ),
                decoration: const BoxDecoration(color: Colors.black),
              ),
              _buildNavItem(Icons.person, "Profile", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }),
              _buildNavItem(Icons.feedback, "Feedback", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackPage()),
                );
              }),
              _buildNavItem(Icons.settings, "Settings", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              }),
              _buildNavItem(Icons.help, "Help", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              }),
              _buildNavItem(
                isLoggedIn ? Icons.logout : Icons.login,
                isLoggedIn ? "Log Out" : "Log In",
                () {
                  if (isLoggedIn) {
                    _showLogoutDialog(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onLogout();
              },
              child: const Text("Log Out", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  ListTile _buildNavItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title, style: const TextStyle(color: Colors.red)),
      onTap: onTap,
    );
  }
}
