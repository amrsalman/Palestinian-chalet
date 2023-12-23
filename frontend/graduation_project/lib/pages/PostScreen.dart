import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/home_app_bar.dart';
import 'package:graduation_project/pages/HomePage.dart'; // Adjust the import path as needed

class PostScreen extends StatelessWidget {
  final Chalet chalet;

  PostScreen({required this.chalet});
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime.now(), // Current date
      lastDate: DateTime(2101), // Some future date
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // change the background color
            colorScheme: ColorScheme.light(
              primary: Colors.redAccent, // header background color
              onPrimary: Colors.white, // header text color
              surface: Colors.white, // body background color
              onSurface: Colors.black, // body text color
            ),
            // button colors
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      _showBookingDialog(context, pickedDate);
    }
  }

  // This function shows the booking confirmation dialog
  void _showBookingDialog(BuildContext context, DateTime bookingDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Text('Do you want to book for: ${bookingDate.toLocal()}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Book'),
              onPressed: () {
                // Handle the booking logic
                Navigator.of(context).pop();
                // Show a confirmation message or take other actions
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Handle favorite logic
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Handle share logic
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              chalet.path,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chalet.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${chalet.position.latitude},${chalet.position.longitude}', // Replace with actual location
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '4.9 (6.8K reviews)', // Replace with actual ratings
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${chalet.city}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '\$${chalet.price} / day',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${chalet.description}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'What we offer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Example amenities icons and text
                  Wrap(
                    spacing: 10, // space between icons
                    children: [
                      Chip(
                        avatar: Icon(Icons.bed, size: 20),
                        label: Text(
                          '${chalet.numberOfRooms} ',
                        ),
                      ),
                      if (chalet
                          .hasSwimmingPool) // Only display if hasSwimmingPool is true
                        Chip(
                          avatar: Icon(Icons.pool, size: 20),
                          label: Text('Pool'),
                        ),
                      // ... other amenities chips
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent, // Background color
                        onPrimary: Colors.white, // Text color
                        minimumSize: Size(double.infinity, 56), // Button size
                      ),
                      onPressed: () => _selectDate(context),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
