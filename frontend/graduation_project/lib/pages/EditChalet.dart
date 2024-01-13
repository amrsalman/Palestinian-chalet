import 'package:flutter/material.dart';

// Chalet class definition
class Chalet {
  String name;
  String price;
  String photo;
  String rooms;
  String city;
  String date;

  Chalet({
    required this.name,
    required this.price,
    required this.photo,
    required this.rooms,
    required this.city,
    required this.date,
  });
}

// ReservationsScreen widget
class EditChalet extends StatefulWidget {
  @override
  State<EditChalet> createState() => _EditChaletState();
}

class _EditChaletState extends State<EditChalet> {
  final List<Chalet> allChalets = [
    Chalet(
      name: 'Amer',
      price: '200',
      photo: 'assets/images/img1.jpg',
      rooms: '4',
      city: 'City A',
      date: '2024-01-05',
    ),
    Chalet(
      name: 'Amer',
      price: '250',
      photo: 'assets/images/img2.jpg', // Replace with your asset or network image
      rooms: '4',
      city: 'City B',
    
      date: '2024-01-06',
    ),
    Chalet(
      name: 'Amer',
      price: '300',
      photo: 'assets/images/img3.jpg', // Replace with your asset or network image
      rooms: '5',
      city: 'City C',
  
      date: '2024-01-07',
    ),
    Chalet(
      name: 'Omar',
      price: '350',
      photo: 'assets/images/img4.jpg', // Replace with your asset or network image
      rooms: '5',
      city: 'City D',

      date: '2024-01-08',
    ),
  ];

  void _updateChalet(Chalet updatedChalet, int index) {
    setState(() {
      allChalets[index] = updatedChalet;
    });
  }

 @override
  Widget build(BuildContext context) {
    List<Chalet> chaletsNamedAmer = allChalets.where((chalet) => chalet.name == 'Amer').toList();

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
            onUpdate: (updatedChalet) => _updateChalet(updatedChalet, allChalets.indexOf(chaletsNamedAmer[index])),
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
  void _showEditDialog() {
    final TextEditingController _nameController = TextEditingController(text: widget.chalet.name);
    final TextEditingController _priceController = TextEditingController(text: widget.chalet.price);
    final TextEditingController _roomsController = TextEditingController(text: widget.chalet.rooms);
    final TextEditingController _cityController = TextEditingController(text: widget.chalet.city);
    final TextEditingController _dateController = TextEditingController(text: widget.chalet.date);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Chalet'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Chalet Name')),
                TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Price')),
                TextField(controller: _roomsController, decoration: InputDecoration(labelText: 'Rooms')),
                TextField(controller: _cityController, decoration: InputDecoration(labelText: 'City')),
                TextField(controller: _dateController, decoration: InputDecoration(labelText: 'Date')),
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
                  name: _nameController.text,
                  price: _priceController.text,
                  photo: widget.chalet.photo,
                  rooms: _roomsController.text,
                  city: _cityController.text,
                  date: _dateController.text,
                ));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
