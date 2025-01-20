import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import './seatselectionpage.dart';
import './seatselectionpage.dart';


class ShowtimeDetailsPage extends StatelessWidget {
  final int movieId;
  final String movieTitle;

  const ShowtimeDetailsPage({
    Key? key,
    required this.movieId,
    required this.movieTitle,
  }) : super(key: key);

  Future<List<dynamic>> fetchShowtimeDetails() async {
    final response = await http.post(
      Uri.parse("http://localhost/cinema_app/get_showtime_details.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"movie_id": movieId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        return data['data'];
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception("Failed to fetch showtime details.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Showtimes for $movieTitle"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchShowtimeDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No showtimes available."));
          } else {
            final showtimes = snapshot.data!;
            return ListView.builder(
              itemCount: showtimes.length,
              itemBuilder: (context, index) {
                final showtime = showtimes[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(showtime['room_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Start Time: ${showtime['start_time']}"),
                        Text("Base Price: \$${showtime['base_price']}"),
                        Text("Showtime Price: \$${showtime['showtime_price']}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatSelectionPage(
                              roomName: showtime['room_name'],
                              basePrice: showtime['base_price'] is String
                                  ? double.parse(showtime['base_price'])
                                  : showtime['base_price'].toDouble(),
                              showtimePrice:
                                  showtime['showtime_price'] is String
                                      ? double.parse(showtime['showtime_price'])
                                      : showtime['showtime_price'].toDouble(),
                            ),
                          ),
                        );
                      },
                      child: const Text("Select"),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
