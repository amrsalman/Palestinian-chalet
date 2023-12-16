import 'package:flutter/material.dart';
import 'package:graduation_project/pages/HomePage.dart'; // Your existing import
import 'package:graduation_project/pages/PostScreen.dart'; // Import PostScreen

class SearchScreen extends StatefulWidget {
  final List<Chalet> allChalets;

  SearchScreen({Key? key, required this.allChalets}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List<Chalet> searchResults = [];

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery.toLowerCase();
      searchResults = widget.allChalets.where((chalet) {
        return chalet.name.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Chalets'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.redAccent), // Red accent label style
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                Chalet chalet = searchResults[index];
                return ListTile(
                  leading: Image.file(chalet.photo, width: 100, fit: BoxFit.cover),
                  title: Text(chalet.name),
                  subtitle: Text('\$${chalet.price}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostScreen(chalet: chalet),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
