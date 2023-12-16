import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project/widgets/home_app_bar.dart';
import 'package:graduation_project/pages/HomePage.dart'; // Adjust the import path as needed

class PostScreen extends StatelessWidget {
  final Chalet chalet;

  PostScreen({required this.chalet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chalet Details'),
      ),
      body: Column(
        children: [
          // Image in the upper half of the screen
          Expanded(
            flex: 1,
            child: Image.file(
              chalet.photo,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          // Details in the bottom half
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chalet.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${chalet.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    
                    onPressed: () {
                      // Handle booking logic
                    },
                    child: Text('Book Now'),
                  ),
                  SizedBox(height: 20), // Additional spacing at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
