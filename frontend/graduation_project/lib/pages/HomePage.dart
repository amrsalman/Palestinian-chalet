import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/Favorites.dart';
import 'package:graduation_project/pages/search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project/pages/PostScreen.dart';
import 'package:graduation_project/widgets/home_app_bar.dart';
import 'package:path/path.dart' as path;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Chalet {
  String name;
  String price;
  File photo;
  String numberOfRooms;
  LatLng position;
  bool hasSwimmingPool;
  bool isFavorite;

  Chalet({
    required this.name,
    required this.price,
    required this.photo,
    required this.numberOfRooms,
    required this.position,
    required this.hasSwimmingPool,
     this.isFavorite = false, // Initialize as false by default
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'photo': photo.path,
      'numberOfRooms': numberOfRooms,
      'position': {'latitude': position.latitude, 'longitude': position.longitude},
      'hasSwimmingPool': hasSwimmingPool,
       'isFavorite': isFavorite,
    };
  }

  factory Chalet.fromMap(Map<String, dynamic> map) {
    return Chalet(
      name: map['name'],
      price: map['price'],
      photo: File(map['photo']),
      numberOfRooms: map['numberOfRooms'],
      position: LatLng(
        map['position']['latitude'],
        map['position']['longitude'],
      ),
      hasSwimmingPool: map['hasSwimmingPool'],
       isFavorite: map['isFavorite'] ?? false, // Default to false if null
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Chalet> chalets = [];

  @override
  void initState() {
    super.initState();
    _loadChalets();
  }
  List<Chalet> getFavoriteChalets() {
    return chalets.where((chalet) => chalet.isFavorite).toList();
  }

  Future<void> _loadChalets() async {
    final prefs = await SharedPreferences.getInstance();
    final chaletData = prefs.getStringList('chalets') ?? [];
    List<Chalet> loadedChalets = chaletData.map((chaletString) {
      return Chalet.fromMap(json.decode(chaletString));
    }).toList();

    setState(() {
      chalets = loadedChalets;
    });
  }

  Future<void> _addChalet(String name, String price, File photo, String numberOfRooms, LatLng position, bool hasSwimmingPool) async {
    final newChalet = Chalet(
      name: name, 
      price: price, 
      photo: photo,
      numberOfRooms: numberOfRooms,
      position: position,
      hasSwimmingPool: hasSwimmingPool,
    );
    setState(() {
      chalets.add(newChalet);
    });
    await _saveChalet(newChalet);
  }
  Future<void> _saveChalet(Chalet chalet) async {
    final prefs = await SharedPreferences.getInstance();
    final chaletData = prefs.getStringList('chalets') ?? [];
    chaletData.add(json.encode(chalet.toMap()));
    await prefs.setStringList('chalets', chaletData);
  }

  Future<void> _removeChalet(Chalet chalet) async {
    setState(() {
      chalets.remove(chalet);
    });
    await _saveChalets();
  }

  Future<void> _saveChalets() async {
    final prefs = await SharedPreferences.getInstance();
    final chaletData = chalets.map((chalet) => json.encode(chalet.toMap())).toList();
    await prefs.setStringList('chalets', chaletData);
  }


  Future<void> _showAddChaletDialog() async {
  String chaletName = '';
  String chaletPrice = '';
  String numberOfRooms = '';
  LatLng position = LatLng(0, 0); // Default position, you might want to add UI to select position
  bool hasSwimmingPool = false;
  XFile? image;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(  // Use StatefulBuilder to manage the dialog's internal state
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Add New Chalet'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  
                TextField(
                  onChanged: (value) => chaletName = value,
                  decoration: InputDecoration(hintText: "Enter chalet name"),
                ),
                TextField(
                  onChanged: (value) => chaletPrice = value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter chalet price"),
                ),
                TextField(
                  onChanged: (value) => numberOfRooms = value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter number of rooms"),
                ),
                 CheckboxListTile(
                    title: Text("Has Swimming Pool"),
                    value: hasSwimmingPool,
                    onChanged: (bool? value) {
                      setState(() {
                        hasSwimmingPool = value!;
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text('Select Photo'),
                    onPressed: () async {
                      image = await _pickImage();
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () async {
                  if (image != null) {
                    File imageFile = await _saveImageToFile(image!);
                    _addChalet(chaletName, chaletPrice, imageFile, numberOfRooms, position, hasSwimmingPool);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
  Future<void> _confirmDeleteChalet(Chalet chalet) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this chalet?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _removeChalet(chalet);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<XFile?> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<File> _saveImageToFile(XFile image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
    return savedImage;
  }
  void _toggleFavorite(Chalet chalet) async {
    setState(() {
      chalet.isFavorite = !chalet.isFavorite;
    });
    await _saveChalets();
  }
   void _navigateToFavoritesScreen() {
    List<Chalet> favoriteChalets = getFavoriteChalets();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(favoriteChalets: favoriteChalets),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: HomeAppBar(  onFavoritePressed: _navigateToFavoritesScreen,
        onSearchPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(allChalets: chalets),
            ),
          );
        },),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: chalets.map((chalet) => Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                     Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  chalet.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: chalet.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                _toggleFavorite(chalet);;
                },
              ),
            ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostScreen(chalet: chalet),
                          ),
                        );
                      },
                      onLongPress: () => _confirmDeleteChalet(chalet),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: FileImage(chalet.photo),
                            fit: BoxFit.cover,
                            opacity: 0.8,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chalet.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${chalet.price}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              )).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 65),
        child: FloatingActionButton(
          onPressed: _showAddChaletDialog,
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
    );
    
  }
}


