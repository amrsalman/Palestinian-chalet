import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Chalet class definition
class Chalet {
  String name;
  int price;
  String photo;
  int rooms;
  String city;
  bool date;

  Chalet({
    required this.name,
    required this.price,
    required this.photo,
    required this.rooms,
    required this.city,
    required this.date,
  });
  
    factory Chalet.fromJson(Map<String, dynamic> json) {
  String mainImage = json['main_image'];

  if (mainImage.startsWith(
      r"C:\project\Palestinian-chalet\frontend\graduation_project\")) {
    mainImage = mainImage
        .substring(
            r"C:\project\Palestinian-chalet\frontend\graduation_project\"
                .length)
        .replaceAll('\\', '/');
  }

  return Chalet(
    name: json['name'],
    price: json['prise'],
    photo: mainImage,
    rooms: json['nomber_of_rome'],
    city: json['location'],
    date: json['done'],
  );
}

}

// ReservationsScreen widget
class EditChalet extends StatefulWidget {
  @override
  State<EditChalet> createState() => _EditChaletState();
}

class _EditChaletState extends State<EditChalet> {
  late SharedPreferences prefs;
  String? token;
  String? username;
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/chales/user/';
  List<Chalet> allChalets = [];

  @override
  void initState() {
    super.initState();
    _fetchChalets();
  }

  
  Future<void> _fetchChalets() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');

    if (token == null || username == null) {
      return;
    }
    print(token);
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/v1/chales/user/${username}'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        print("/////////////////////////////////////////////////////////////////////");
        // Assuming your Git API returns a JSON array, parse it and update the chalets list
        List<dynamic> chaletsJson = json.decode(response.body);
        List<Chalet> chalets = chaletsJson.map((json) => Chalet.fromJson(json)).toList();

        setState(() {
          allChalets = chalets;
        });
        print(chaletsJson);
        print(allChalets);
      } else {
        // Handle error response
        print("###################################################");
        print('Failed to fetch chalets: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      print("###################################################");
      print('Error fetching chalets: $error');
    }
  }

  void _updateChalet(Chalet updatedChalet, int index, BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');

    if (token == null || username == null) {
      return;
    }
    try {
      var response = await http.patch(
        Uri.parse('http://10.0.2.2:8080/api/v1/chales/edit/${updatedChalet.name}/nameuser/$username'),
        headers: {'Authorization': '$token'},
        body: {
          //'name': updatedChalet.name,
          'location': updatedChalet.city,
          'nomber_of_rome': updatedChalet.rooms.toString(),
          'prise': updatedChalet.price.toString(),
          // Add other fields as needed
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          allChalets[index] = updatedChalet;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chalet updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update chalet. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error updating chalet: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


 @override
  Widget build(BuildContext context) {
    List<Chalet> chaletsNamedAmer = allChalets;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit Chalets ',style: TextStyle(color: Colors.redAccent),),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: chaletsNamedAmer.length,
        itemBuilder: (context, index) {
          return ChaletListItem(
            chalet: chaletsNamedAmer[index],
            onUpdate: (updatedChalet) => _updateChalet(updatedChalet, allChalets.indexOf(chaletsNamedAmer[index]), context),
          );
        },
      ),
    );
  }
}
// ChaletListItem widget
class ChaletListItem extends StatefulWidget {
  final Chalet chalet;
  final Function(Chalet) onUpdate;

  ChaletListItem({required this.chalet, required this.onUpdate});

  @override
  State<ChaletListItem> createState() => _ChaletListItemState();
}

class _ChaletListItemState extends State<ChaletListItem> {
  late SharedPreferences prefs;
  String? token;
  String? username;
  
  void _showEditDialog() {
    //final TextEditingController _nameController = TextEditingController(text: widget.chalet.name);
    final TextEditingController _priceController = TextEditingController(text: widget.chalet.price.toString());
    final TextEditingController _roomsController = TextEditingController(text: widget.chalet.rooms.toString());
    final TextEditingController _cityController = TextEditingController(text: widget.chalet.city);
    //final TextEditingController _dateController = TextEditingController(text: widget.chalet.date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Chalet'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Chalet Name')),
                Text('Chalet Name: ${widget.chalet.name}'),
                Text('Is Activ: ${widget.chalet.date}'),
                TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price')),
                TextField(controller: _roomsController, decoration: InputDecoration(labelText: 'Rooms')),
                TextField(controller: _cityController, decoration: InputDecoration(labelText: 'City')),
                
                //TextField(controller: _dateController, decoration: InputDecoration(labelText: 'Date')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              style: TextButton.styleFrom(primary: Colors.redAccent),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save Changes'),
              style: TextButton.styleFrom(primary: Colors.redAccent),
              onPressed: () {
                widget.onUpdate(Chalet(
                  name: widget.chalet.name, // Use the current name
                  price: int.parse(_priceController.text),
                  photo: widget.chalet.photo,
                  rooms: int.parse(_roomsController.text),
                  city: _cityController.text,
                  date: widget.chalet.date, // Use the current name
                ));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              style: TextButton.styleFrom(primary: Colors.redAccent),
              onPressed: () {
                _deleteChalet();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

    void _deleteChalet() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');

    if (token == null || username == null) {
      return;
    }

    try {
      var response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/api/v1/chales/delete/${widget.chalet.name}/nameuser/$username'),
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        // Delete successful, you may want to update the UI or navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chalet deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Delete failed, handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete chalet. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Handle exceptions
      print('Error deleting chalet: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showEditDialog,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                widget.chalet.photo,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.chalet.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Price per day : ${widget.chalet.price}'),
                    Text('Number of rooms : ${widget.chalet.rooms}'),
                    Text('City: ${widget.chalet.city}'),
                    Text('Is Activ: ${widget.chalet.date}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
