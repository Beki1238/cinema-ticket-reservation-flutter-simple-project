import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.red)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.red),
            title: const Text("Dark Mode", style: TextStyle(color: Colors.red)),
            trailing: Switch(
              value: true, // Replace with a dynamic value
              onChanged: (value) {
                // Add your dark mode logic here
              },
            ),
          ),
          const Divider(color: Colors.red),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.red),
            title: const Text("Notifications", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Add notification settings logic here
            },
          ),
          const Divider(color: Colors.red),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.red),
            title: const Text("Language", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Add language selection logic here
            },
          ),
        ],
      ),
    );
  }
}
