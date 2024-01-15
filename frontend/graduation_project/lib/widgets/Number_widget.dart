import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:graduation_project/pages/NumberOFReservations.dart';

class NumbersWidget extends StatefulWidget {
  @override
  _NumbersWidgetState createState() => _NumbersWidgetState();
}

class _NumbersWidgetState extends State<NumbersWidget> {
  int numberOfReservations = 0;
  late SharedPreferences prefs;
  String? token;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchNumberOfReservations();
  }

  Future<void> _fetchNumberOfReservations() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');

    if (token == null || username == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/BookingChales/$username'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          numberOfReservations = data.length;
        });
      } else {
        print('Failed to fetch number of reservations. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching number of reservations: $error');
    }
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, numberOfReservations.toString(), 'Number of reservations'),
        ],
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {
          // Navigate to the NumberOfReservations screen when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NumberOfReservations()),
          );
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
