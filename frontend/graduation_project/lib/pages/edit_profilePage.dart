import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project/widgets/Button_widget.dart';
import 'package:graduation_project/widgets/TextField_widget.dart';

class USER {
  final String username;
  final String email;
  final String fname;
  final String lname;
  final String dateOfBirth;
  final String phone;

  USER({
    required this.username,
    required this.email,
    required this.fname,
    required this.lname,
    required this.dateOfBirth,
    required this.phone,
  });

  USER copy({
    String? username,
    String? email,
    String? fname,
    String? lname,
    String? dateOfBirth,
    String? phone,
  }) =>
      USER(
        username: username ?? this.username,
        email: email ?? this.email,
        fname: fname ?? this.fname,
        lname: lname ?? this.lname,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        phone: phone ?? this.phone,
      );

  static USER fromJson(Map<String, dynamic> json) => USER(
        username: json['username'],
        email: json['email'],
        fname: json['fname'],
        lname: json['lname'],
        dateOfBirth: json['date_of_birth'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'fname': fname,
        'lname': lname,
        'date_of_birth': dateOfBirth,
        'phone': phone,
      };
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late USER user;
  late SharedPreferences prefs;
  late String? token;
  late String? username;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    initPreferences();
  }

  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print('token: ${token}');
    username = prefs.getString('username');
    if (token == null || username == null) {
      return;
    }

    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/$username'));
    if (response.statusCode == 200) {
      userData = json.decode(response.body);
      print(userData!['fname']);
    } else {
      print('Failed to load user data');
    }

    // Initialize the user object with default values
    user = USER(
      username: username!,
      email: '',
      fname: '',
      lname: '',
      dateOfBirth: '',
      phone: '',
    );

    // If user data is available, update the user object
    if (userData != null) {
      user = user.copy(
        email: userData!['email'],
        fname: userData!['fname'],
        lname: userData!['lname'],
        dateOfBirth: userData!['date_of_birth'],
        phone: userData!['phone'],
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context){ 
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Edit Profile ',
            style: TextStyle(color: Colors.redAccent),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            if (userData != null) ...[
            TextFieldWidget(
              label: 'First Name',
              text: userData!['fname'] ?? '',
              onChanged: (firstname) {
                setState(() {
                  user = user.copy(fname: firstname);
                });
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Last Name',
              text: userData!['lname'] ?? '',
              onChanged: (lastname) {
                setState(() {
                  user = user.copy(lname: lastname);
                });
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: userData!['email'] ?? '',
              onChanged: (email) {
                setState(() {
                  user = user.copy(email: email);
                });
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Date of Birth',
              text: userData!['date_of_birth'] ?? '',
              onChanged: (dob) {
                setState(() {
                  user = user.copy(dateOfBirth: dob);
                });
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Mobile Number',
              text: userData!['phone'] ?? '',
              onChanged: (mobile) {
                setState(() {
                  user = user.copy(phone: mobile);
                });
              },
            ),],
            const SizedBox(height: 24),
            ButtonWidget(
              text: 'Save',
              onClicked: () async {
                if (user != null) {
                  final success = await updateUserOnServer();
                  if (success) {
                    Navigator.of(context).pop();
                  } else {
                    print('Failed to update user data');
                  }
                } else {
                  print('User is null. Cannot update.');
                }
              },
            ),
          ],
        ),
      );
  }
  Future<bool> updateUserOnServer() async {
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:8080/api/v1/user/$username'),
      body: jsonEncode(user.toJson()), // Encode the user data as JSON
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }
}
