import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './custom_app_bar.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = []; // List to hold movies fetched from the API
  bool isLoading = true; // Loading state for the movie data

  @override
  void initState() {
    super.initState();
    fetchMovies(); // Fetch movies on initialization
  }

  Future<void> fetchMovies() async {
    final url = "http://localhost/cinema_app/movies_all.php"; // Replace with your actual API endpoint
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          movies = json.decode(response.body);
          isLoading = false; // Data fetched successfully
        });
      } else {
        print("Failed to fetch movies: ${response.statusCode}");
        setState(() {
          isLoading = false; // Stop loading if there's an error
        });
      }
    } catch (e) {
      print("Error fetching movies: $e");
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Triangle Hotel Cinema', style: TextStyle(color: Colors.white)),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      // ),
      appBar: CustomAppBar("Triangle Hotel Cinema"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cinema service description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                 Text(
                  "Dire Dawa",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome to Triangle Hotel Cinema",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  "Experience the best of cinema in the heart of the Dire Dawa. Enjoy comfortable seating, "
                  "state-of-the-art sound, and visuals for an unforgettable movie experience Triangle Hotel.",
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  "Address: Triangle Hotel, Orbit , DireDawa",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          // Display movie grid or a loading indicator
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loading spinner
                : movies.isEmpty
                    ? const Center(child: Text("No movies available"))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two items per row
                          childAspectRatio: 0.6, // Height greater than width
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return _buildMovieCard(
                            imageUrl: movie["image_url"], // Replace with your DB field for image
                            title: movie["title"], // Replace with your DB field for title
                            genre: movie["genre"], // Replace with your DB field for genre
                            duration: movie["duration"], // Replace with your DB field for duration
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard({
    required String imageUrl,
    required String title,
    required String genre,
    required String duration,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 300, // Increased height for long images
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Image failed to load'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              genre,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              duration,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle booking action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Book'),
            ),
          ),
        ],
      ),
    );
  }
}
