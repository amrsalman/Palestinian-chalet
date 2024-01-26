import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/pages/Reservations.dart';
import 'package:graduation_project/pages/EditChalet.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.edit), // Edit icon
      color: Colors.redAccent,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditChalet()),
        );
      },
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: IconButton(
      icon: Icon(CupertinoIcons.calendar), // Reservation icon
      color: Colors.redAccent,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReservationsScreen()),
        );
      },
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(Icons.logout), // Logout icon
        color: Colors.redAccent,
        onPressed: () {
          Navigator.of(context).pop(); // Or implement your logout logic
        },
      ),
    ],
  );
}