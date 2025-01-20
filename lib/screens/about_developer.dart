import 'package:flutter/material.dart';

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Developers", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDeveloperCard(
            name: "Yohanis Haylu",
            role: "Frontend",
            imageUrl: "https://pics.craiyon.com/2024-09-09/NRXjnmN4RceV6zDEk_NbZQ.webp", // Replace with actual image URL
          ),
          const SizedBox(height: 16),
          _buildDeveloperCard(
            name: "Bereket Bahiru",
            role: "Database",
            imageUrl: "https://www.shutterstock.com/image-vector/vector-illustration-cool-mysterious-angry-600nw-2299949697.jpg", // Replace with actual image URL
          ),
          const SizedBox(height: 16),
          _buildDeveloperCard(
            name: "Hassu Mohammod",
            role: "Integration",
            imageUrl: "https://static.vecteezy.com/system/resources/thumbnails/033/662/051/small/cartoon-lofi-young-manga-style-girl-while-listening-to-music-in-the-rain-ai-generative-photo.jpg", // Replace with actual image URL
          ),
          const SizedBox(height: 16),
          _buildDeveloperCard(
            name: "Usman Semir",
            role: "Developer",
            imageUrl: "https://www.shutterstock.com/image-vector/vector-illustration-cool-mysterious-angry-600nw-2299949697.jpg", // Replace with actual image URL
          ),
          const SizedBox(height: 16),
          _buildDeveloperCard(
            name: "Tsine Misge",
            role: "Developer",
            imageUrl: "https://pics.craiyon.com/2024-09-09/NRXjnmN4RceV6zDEk_NbZQ.webp", // Replace with actual image URL
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String name,
    required String role,
    required String imageUrl,
  }) {
    return Container(
      width: 200, // Increased width of the circular container
      height: 200, // Increased height of the circular container
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black, // Circle background color
        border: Border.all(color: Colors.red, width: 3), // Thicker red border
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 120, // Increased avatar width
              height: 120, // Increased avatar height
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            role,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ],
      ),
    );
  }
}