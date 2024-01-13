import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NumberOfReservations extends StatefulWidget {
  @override
  _NumberOfReservationsState createState() => _NumberOfReservationsState();
}

class _NumberOfReservationsState extends State<NumberOfReservations> {
  List<Chalet> myBookedChalets = [];
  late SharedPreferences prefs;
  String? token;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchMyBookedChalets();
  }

  Future<void> fetchMyBookedChalets() async {
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
          myBookedChalets = data.map((chaletJson) => Chalet.fromJson(chaletJson)).toList();
        });
      } else {
        print('Failed to fetch booked chalets. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching booked chalets: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Your Reservations', style: TextStyle(color: Colors.redAccent)),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: myBookedChalets.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return ChaletGridItem(chalet: myBookedChalets[index]);
        },
      ),
    );
  }
}

class Chalet {
  final String name;
  final int price;
  final String photo;
  final String clientName;
  final String city;
  final String date;

  Chalet({
    required this.name,
    required this.price,
    required this.photo,
    required this.clientName,
    required this.city,
    required this.date,
  });

  factory Chalet.fromJson(Map<String, dynamic> json) {
     String mainImage = json['chalet']['main_image'];

    if (mainImage.startsWith(
        r"C:\project\Palestinian-chalet\frontend\graduation_project\")) {
      mainImage = mainImage
          .substring(
              r"C:\project\Palestinian-chalet\frontend\graduation_project\"
                  .length)
          .replaceAll('\\', '/');
    }

    return Chalet(
      name: json['chalet']['name'],
      price: json['total_prise'],
      photo: mainImage,
      clientName: json['chalet']['owner'],
      city: json['chalet']['location'],
      date: json['date'],
    );
  }
}

// ChaletGridItem widget
class ChaletGridItem extends StatelessWidget {
  final Chalet chalet;

  ChaletGridItem({required this.chalet});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3, // Give more space to the image
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                chalet.photo,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 4, // Adjust space for text
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Better spacing for text
                children: [
                  Text(chalet.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Price: ${chalet.price}', style: TextStyle(fontSize: 14,)),
                  Text('Owner: ${chalet.clientName}', style: TextStyle(fontSize: 14)),
                  Text('City: ${chalet.city}', style: TextStyle(fontSize: 14)),
                  Text('Date: ${chalet.date}', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}