import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  final String baseUrl = "http://localhost/cinema_app";

  Future<List<Movie>> fetchNowPlayingMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies_now_playing.php'));

    if (response.statusCode == 200) {
      List movies = jsonDecode(response.body);
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<List<Movie>> fetchComingSoonMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies_coming_soon.php'));

    if (response.statusCode == 200) {
      List movies = jsonDecode(response.body);
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load coming soon movies');
    }
  }

  Future<List<Movie>> fetchAllMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies_all.php'));

    if (response.statusCode == 200) {
      List movies = jsonDecode(response.body);
      return movies.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load all movies');
    }
  }
}
