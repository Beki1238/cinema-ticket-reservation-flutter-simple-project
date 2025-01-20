import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String duration;
  final String releaseDate;
  final VoidCallback onTrailerTap;

  const MovieCard({
    super.key,
    required this.title,
    required this.duration,
    required this.releaseDate,
    required this.onTrailerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Duration: $duration\nRelease Date: $releaseDate"),
            trailing: ElevatedButton(
              onPressed: onTrailerTap,
              child: const Text("Trailer"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Booking $title")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Book"),
          ),
        ],
      ),
    );
  }
}
