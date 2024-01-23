import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  int id;
  String username;
  String notificationMessage;
  String title;
  bool isNew;

  User(this.id, this.username, this.notificationMessage, this.title, {this.isNew = true});
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<User> users = [];
  late SharedPreferences prefs;
  String? token;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }
  // Function to fetch notifications from the server
  Future<void> fetchNotifications() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');

    if (token == null || username == null) {
      return;
    }
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/api/v1/notifications/$username"),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          users = data.map((item) => User(
            item['id'],
            item['user'],
            item['message'],
            item['title'], // Provide a value for the 'title' parameter
            isNew: true,
          )).toList() as List<User>; // Explicitly cast to List<User>
        });
      } else {
        // Handle error
        print("Failed to fetch notifications. Status code: ${response.statusCode}");
      }
    } catch (error) {
      // Handle error
      print("Error fetching notifications: $error");
    }
  }

 

void _removeNotification(int index, int notificationId) async {
  try {
    // Make an HTTP request to delete the notification on the server
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8080/api/v1/notifications/delete/$notificationId"),
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      // If the server successfully deletes the notification, remove it locally
      setState(() {
        users.removeAt(index);
      });
    } else {
      // Handle error if the server request fails
      print("Failed to delete notification. Status code: ${response.statusCode}");
    }
  } catch (error) {
    // Handle error if there's an exception during the HTTP request
    print("Error deleting notification: $error");
  }
}

  void _showBookingDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Message: ${user.notificationMessage}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.notifications, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'Notifications',
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Add this line to hide the back button
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Dismissible(
            key: Key(user.id.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
              padding: EdgeInsets.only(right: 20),
            ),
            onDismissed: (direction) {
               // Call the updated _removeNotification method with the notification ID
                _removeNotification(index, user.id);
            },
            direction: DismissDirection.endToStart,
            child: Card(
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text(user.title),
                subtitle: Text(user.notificationMessage),
                trailing: user.isNew ? Text('NEW', style: TextStyle(color: Colors.redAccent)) : null,
                onTap: () {
                  if (user.isNew) {
                    setState(() {
                      user.isNew = false;
                    });
                  }
                  _showBookingDialog(user);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
