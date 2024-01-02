import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/home_app_bar.dart';
import 'package:graduation_project/pages/HomePage.dart'; // Adjust the import path as needed
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  final Chalet chalet;

  PostScreen({required this.chalet});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Booking confirmation',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                        'Start Date: ${startDate!.toLocal().toString().split(' ')[0]}'), // Only date part
                  ],
                ),
                SizedBox(height: 20),
                // Section for End Date
                Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                        'End Date: ${endDate!.toLocal().toString().split(' ')[0]}'), // Only date part
                  ],
                ),
                SizedBox(height: 20),
                // Section for Total Price
                Row(
                  children: <Widget>[
                    Icon(Icons.attach_money, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('\$${bookingPrice?.toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 20),
                // Display booking details (start date, end date, price, etc.)
                // Use startDate, endDate, bookingPrice, or relevant variables here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: Text('Book this session'),
              onPressed: () async {
                Navigator.of(context).pop(true);
                final prefs = await SharedPreferences.getInstance();
                final String? user = prefs.getString('username');
                final String? token = prefs.getString('token');
                if (user == null) {
                  // Handle the case where the user is not logged in
                  return;
                }
                final String apiUrl =
                    'http://10.0.2.2:8080/api/v1/bookchalet'; // Replace with your API URL
                final Map<String, dynamic> requestData = {
                  'username': user, // Replace with actual username
                  'name': widget.chalet
                      .name, // Assuming widget.chalet contains chalet details
                  'date':
                      startDate!.toIso8601String(), // Convert date to string
                  'end': endDate!.toIso8601String(), // Convert date to string
                };

                final http.Response response = await http.post(
                  Uri.parse(apiUrl),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': '$token',
                  },
                  body: jsonEncode(requestData),
                );

                if (response.statusCode == 201) {
                  final Map<String, dynamic> data = json.decode(response.body);
                  print('Booking successful');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Booking successful'),
                    ),
                  );
                  // Handle success, update UI, show success message, etc.
                } else {
                  final Map<String, dynamic> responseData =
                      json.decode(response.body);
                  final errorMessage = responseData['error'];
                  print(errorMessage);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                    ),
                  );
                  // Handle failure, update UI, show error message, etc.
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                onPrimary: Colors.white,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed) {
      // Handle post-booking actions or UI updates if needed
    }
  }

  DateTime? startDate;
  DateTime? endDate;
  double? bookingPrice;
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDateRange != null) {
      startDate = pickedDateRange.start;
      endDate = pickedDateRange.end;
      setState(() {
        _calculateBookingPrice();
        // Call the confirmation dialog after state update
        _showConfirmationDialog();
      });
    }
  }

  void _calculateBookingPrice() {
    if (startDate != null && endDate != null) {
      final int days = endDate!.difference(startDate!).inDays + 1;
      final double? chaletPrice = double.tryParse(widget.chalet.price);
      if (chaletPrice != null && days > 0) {
        bookingPrice = days * chaletPrice;
      } else {
        bookingPrice = null;
      }
    } else {
      bookingPrice = null;
    }
  }

  // This function shows the booking confirmation dialog
  void _showBookingDialog(
    BuildContext context,
    DateTime bookingDate,
  ) {
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
              widget.chalet.path, // Use widget.chalet here
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
                    widget.chalet.name,
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
                        '${widget.chalet.position.longitude},${widget.chalet.position.latitude}', // Replace with actual location
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
                    '${widget.chalet.city}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '\$${widget.chalet.price} / day',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${widget.chalet.description}',
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
                          '${widget.chalet.numberOfRooms} ',
                        ),
                      ),
                      if (widget.chalet
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
                      onPressed: () => _selectDateRange(context),
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
