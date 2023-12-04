

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/HomePage.dart';
import 'package:graduation_project/pages/Maps.dart';
import 'package:graduation_project/pages/favouret.dart';
import 'package:graduation_project/pages/notificationpage.dart';
import 'package:graduation_project/pages/profile.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({
    Key? key,
  }) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int index =2;
  final Screens = [
    Favouret(),
    Maps(),
    Homepage(),
    NotificationPage(),
    Profile(),
];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.favorite,
        color: Colors.redAccent,
        size: 30,
      ),
      Icon(
        Icons.location_on,
        color: Colors.redAccent,
        size: 30,
      ),
      Icon(
        Icons.home,
        color: Colors.redAccent,
        size: 30,
      ),
      Icon(
        Icons.notifications,
        color: Colors.redAccent,
        size: 30,
      ),
      Icon(
        Icons.person,
        color: Colors.redAccent,
        size: 30,
      ),
    ];

    return Scaffold(
        extendBody: true,
        //backgroundColor: Colors.white,
        
        body: Screens[index],
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            color: Colors.white,
            buttonBackgroundColor: Colors.black87,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            height: 60,
            items: items,
            index: index,
            onTap: (index) => setState(() => this.index = index),
          ),
        ));
  }
}
