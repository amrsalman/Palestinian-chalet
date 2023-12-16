import 'package:flutter/material.dart';
import 'package:graduation_project/pages/HomePage.dart'; // Your existing import
import 'package:graduation_project/pages/PostScreen.dart'; // Import the PostScreen

class FavoritesScreen extends StatelessWidget {
  final List<Chalet> favoriteChalets;

  FavoritesScreen({Key? key, required this.favoriteChalets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Chalets'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoriteChalets.length,
        itemBuilder: (context, index) {
          Chalet chalet = favoriteChalets[index];
          return ListTile(
            leading: Image.file(chalet.photo, width: 100, fit: BoxFit.cover),
            title: Text(chalet.name),
            subtitle: Text('\$${chalet.price}'),
            trailing: chalet.hasSwimmingPool 
                      ? Icon(Icons.pool, color: Colors.redAccent)
                      : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostScreen(chalet: chalet),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
