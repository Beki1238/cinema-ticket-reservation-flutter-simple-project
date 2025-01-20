import 'package:flutter/material.dart';
//import 'dart:convert';
//import 'package:flutter/material.dart';

class SeatSelectionPage extends StatefulWidget {
  final String roomName;
  final double basePrice;
  final double showtimePrice;

  const SeatSelectionPage({
    Key? key,
    required this.roomName,
    required this.basePrice,
    required this.showtimePrice,
  }) : super(key: key);

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final int totalSeats = 36; // Total number of seats
  final List<int> bookedSeats = [1, 2, 3]; // Mocked booked seats
  final List<int> temporarilyBookedSeats = [4, 5, 6]; // Mocked temp seats
  List<int> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats - ${widget.roomName}'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Seat Color Info Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seat Color Definitions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                _buildLegend('Green', 'Available for selection', Colors.green),
                _buildLegend('Gray', 'Temporarily booked', Colors.grey),
                _buildLegend('Red', 'Fully booked', Colors.red),
                _buildLegend('Yellow', 'Selected by you', Colors.yellow),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Seats Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: totalSeats,
              itemBuilder: (context, index) {
                int seatNumber = index + 1;
                return GestureDetector(
                  onTap: () => _toggleSeatSelection(seatNumber),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _getSeatColor(seatNumber),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Text(
                      '$seatNumber',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Total Price and Book Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _onBookSeats,
                  child: Text('Book Selected Seats'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, String description, Color color) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          color: color,
          margin: EdgeInsets.only(right: 8),
        ),
        Expanded(
          child: Text(
            '$label: $description',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Color _getSeatColor(int seatNumber) {
    if (bookedSeats.contains(seatNumber)) {
      return Colors.red; // Fully booked
    } else if (temporarilyBookedSeats.contains(seatNumber)) {
      return Colors.grey; // Temporarily booked
    } else if (selectedSeats.contains(seatNumber)) {
      return Colors.yellow; // Selected by the user
    } else {
      return Colors.green; // Available
    }
  }

  void _toggleSeatSelection(int seatNumber) {
    if (bookedSeats.contains(seatNumber) || temporarilyBookedSeats.contains(seatNumber)) {
      return; // Cannot select booked or temporarily booked seats
    }

    setState(() {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        selectedSeats.add(seatNumber);
      }
    });
  }

  double _calculateTotalPrice() {
    return selectedSeats.length * (widget.basePrice + widget.showtimePrice);
  }

  void _onBookSeats() {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one seat.')),
      );
      return;
    }

    // Mock booking process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Seats booked successfully!')),
    );

    setState(() {
      bookedSeats.addAll(selectedSeats);
      selectedSeats.clear();
    });
  }
}
