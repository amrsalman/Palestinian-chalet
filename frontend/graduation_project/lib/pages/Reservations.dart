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

// ReservationsScreen widget
class ReservationsScreen extends StatelessWidget {
  // Manually added list of chalets
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
    // Filter the list to include only chalets with the name 'Amer'
    final chaletsNamedAmer = allChalets.where((chalet) => chalet.name == 'Amer').toList();

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () => Navigator.of(context).pop(),
          
        ),
        title: Text('Reservations ', style: TextStyle(color: Colors.redAccent),),
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

// ChaletListItem widget
class ChaletListItem extends StatelessWidget {
  final Chalet chalet;

  ChaletListItem({required this.chalet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              chalet.photo,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chalet.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Total Price: ${chalet.price}'),
                  Text('Client Name: ${chalet.clientName}'),
                  Text('City: ${chalet.city}'),
                  
                  Text('Date: ${chalet.date}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
