import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help", style: TextStyle(color: Colors.red)),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "How can we help you?",
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
    );
  }
}
