import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/pages/Reservations.dart';
import 'package:graduation_project/pages/EditChalet.dart'; // Import EditChalet screen

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.calendar; // Calendar icon for the action button

  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.edit), // Edit icon
      color: Colors.redAccent,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditChalet()), // Navigate to EditChalet screen
        );
      },
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReservationsScreen()), // Navigate to ReservationsScreen
          );
        },
        icon: Icon(icon),
        color: Colors.redAccent,
      ),
    ],
  );
}