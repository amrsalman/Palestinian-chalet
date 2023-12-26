import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/home_app_bar.dart';
import 'package:graduation_project/pages/HomePage.dart'; // Adjust the import path as needed



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
  void _showConfirmationDialog() {
  showDialog(
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
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
            children: <Widget>[
              // Section for Start Date
              Row(
                children: <Widget>[
                  Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('Start Date: ${startDate!.toLocal().toString().split(' ')[0]}'), // Only date part
                ],
              ),
              SizedBox(height: 20),
              // Section for End Date
              Row(
                children: <Widget>[
                  Icon(Icons.calendar_today, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('End Date: ${endDate!.toLocal().toString().split(' ')[0]}'), // Only date part
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
              // Additional details can be added here
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel',style: TextStyle(color: Colors.redAccent),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Book this session'),
            onPressed: () {
              // Handle the booking confirmation logic
              Navigator.of(context).pop();
              // Optionally, show a final confirmation message or perform further actions
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent, // background
              onPrimary: Colors.white, // foreground
            ),
          ),
        ],
      );
    },
  );
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
  void _showBookingDialog(BuildContext context, DateTime bookingDate , ) {
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
                        '${widget.chalet.position.latitude},${widget.chalet.position.longitude}', // Replace with actual location
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
