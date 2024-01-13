import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

// Chalet class definition
class Chalet {
  final String name;
  final String price;
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
}

class NumberOfReservations extends StatelessWidget {
  final List<Chalet> allChalets = [
    Chalet(
      name: 'Amer',
      price: '200',
      photo: 'assets/images/img1.jpg', // Replace with your asset or network image
      clientName: 'John Doe',
      city: 'City A',
  

      date: '2024-01-05',
    ),
    Chalet(
      name: 'Amer',
      price: '250',
      photo: 'assets/images/img2.jpg', // Replace with your asset or network image
      clientName: 'Jane Smith',
      city: 'City B',
    
      date: '2024-01-06',
    ),
    Chalet(
      name: 'Amer',
      price: '300',
      photo: 'assets/images/img3.jpg', // Replace with your asset or network image
      clientName: 'Alice Johnson',
      city: 'City C',
  
      date: '2024-01-07',
    ),
    Chalet(
      name: 'Omar',
      price: '350',
      photo: 'assets/images/img4.jpg', // Replace with your asset or network image
      clientName: 'Bob Brown',
      city: 'City D',

      date: '2024-01-08',
    ),
  ];

 @override
  Widget build(BuildContext context) {
    final chaletsNamedAmer = allChalets.where((chalet) => chalet.name == 'Amer').toList();

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
          childAspectRatio: 1 / 1.2, // Adjusted aspect ratio for larger images
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: chaletsNamedAmer.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return ChaletGridItem(chalet: chaletsNamedAmer[index]);
        },
      ),
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
            flex: 3, // Adjust space for text
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