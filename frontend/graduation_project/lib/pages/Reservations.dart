import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Chalet {
  //final String name;
  final String clientName;
  final String chaletName;
  final int totalPrice;
  final String startDate;
  final String endDate;

  Chalet({
    //required this.name,
    required this.clientName,
    required this.chaletName,
    required this.totalPrice,
    required this.startDate,
    required this.endDate,
  });
  Chalet.fromJson(Map<String, dynamic> json)
      : //name = json['name'],
        clientName = json['usernamr'],
        chaletName = json['name'],
        totalPrice = json['total_prise'],
        startDate = json['date'],
        endDate = json['end'];
}

class ReservationsScreen extends StatefulWidget {

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  List<Chalet> chalets = [];
  late SharedPreferences prefs;
  String? token;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');

    if (token == null || username == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/Reservations/${username}'),
        headers: {'Authorization': '$token'},
        );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        List<dynamic> data = json.decode(response.body);
        List<Chalet> fetchedChalets = data.map((item) => Chalet.fromJson(item)).toList();

        setState(() {
          chalets = fetchedChalets;
        });
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load chalets');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(allChalets: chalets),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chaletsNamedAmer = chalets.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.redAccent),
            onPressed: () => _showSearch(context),
          ),
        ],
        title: Text(
          'Reservations',
          style: TextStyle(color: Colors.redAccent),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chaletsNamedAmer.length,
        itemBuilder: (context, index) {
          return ChaletListItem(chalet: chaletsNamedAmer[index]);
        },
      ),
    );
  }
}

class ChaletListItem extends StatelessWidget {
  final Chalet chalet;

  ChaletListItem({required this.chalet});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.home, size: 32, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  'Chalet Name: ${chalet.chaletName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 24, color: Colors.redAccent),
                SizedBox(width: 8),
                Text('Client Name: ${chalet.clientName}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.attach_money, size: 24, color: Colors.redAccent),
                SizedBox(width: 8),
                Text('Total Price: ${chalet.totalPrice}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 24, color: Colors.redAccent),
                SizedBox(width: 8),
                Text('Start Date: ${chalet.startDate}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 24, color: Colors.redAccent),
                SizedBox(width: 8),
                Text('End Date: ${chalet.endDate}', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<Chalet> allChalets;

  CustomSearchDelegate({required this.allChalets});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Chalet> filteredChalets = allChalets.where((chalet) {
      return chalet.clientName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredChalets.length,
      itemBuilder: (context, index) {
        return ChaletListItem(chalet: filteredChalets[index]);
      },
    );
  }
   @override
  Widget buildSuggestions(BuildContext context) {
    List<Chalet> suggestedChalets = allChalets.where((chalet) {
      return chalet.clientName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestedChalets.length,
      itemBuilder: (context, index) {
        return ChaletListItem(chalet: suggestedChalets[index]);
      },
    );
  }
}
