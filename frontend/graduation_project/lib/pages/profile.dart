import 'package:flutter/material.dart';
import 'package:graduation_project/model/user.dart';
import 'package:graduation_project/pages/edit_profilePage.dart';
import 'package:graduation_project/utils/User_preferneces.dart';
import 'package:graduation_project/widgets/AppBar_widget.dart';
import 'package:graduation_project/widgets/Button_widget.dart';
import 'package:graduation_project/widgets/Profile_widget.dart';
import 'package:graduation_project/widgets/Number_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for json.decode

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late SharedPreferences prefs;
  String? token;
  String? username;
  Map<String, dynamic>? userData; // Store user data received from the backend

  @override
  void initState() {
    super.initState();
    initPreferences();
  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();

    // Retrieve the token from shared preferences
    token = prefs.getString('token');
    print('token: ${token}');
    username = prefs.getString('username');
    if (token == null || username == null) {
      // Handle the case where the token is not available
      // You might want to redirect the user to the login screen
      return;
    }

    // Fetch user data from the backend using the username
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/$username'));
    if (response.statusCode == 200) {
      // Parse the response and update your UI with the user details
      userData = json.decode(response.body);
    } else {
      // Handle errors
      print('Failed to load user data');
    }

    setState(() {});
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: buildAppBar(context),
      
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 135, // Adjust the size to fit your design
            child: Center(
              child: CircleAvatar(
                radius: 64, // The radius of the circle
                backgroundColor: Colors.redAccent, // The background color of the circle
                child: Icon(
                  Icons.person,
                  size: 70, // The size of the icon inside the circle
                  color: Colors.white, // The color of the icon
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
             NumbersWidget(),
          const SizedBox(height: 24),
          // Display user data in the UI
          if (userData != null) ...[
            buildUserInfo('User Name', userData!['username'], Icons.person),
            const SizedBox(height: 24),
            buildUserInfo('Birthday', userData!['date_of_birth'], Icons.cake),
            const SizedBox(height: 24),
            buildUserInfo('Phone', userData!['phone'], Icons.phone),
            const SizedBox(height: 24),
            buildUserInfo('Email', userData!['email'], Icons.email),
            // Add more fields as needed
          ],
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ElevatedButton(
              child: Text('Edit Profile'),
              onPressed: () async {
                // Navigate to the edit profile page
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
                // Reload user data after editing
                await initPreferences();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                onPrimary: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildUserInfo(String title, String data, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
