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
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class Chalet {
  String name;
  String price;
  File photo;
  String numberOfRooms;
  LatLng position;
  bool hasSwimmingPool;
  bool isFavorite;
  String path;

  Chalet({
    required this.name,
    required this.price,
    required this.photo,
    required this.numberOfRooms,
    required this.position,
    required this.hasSwimmingPool,
    this.isFavorite = false, // Initialize as false by default
    required this.path,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'photo': photo.path,
      'numberOfRooms': numberOfRooms,
      'position': {
        'latitude': position.latitude,
        'longitude': position.longitude
      },
      'hasSwimmingPool': hasSwimmingPool,
      'isFavorite': isFavorite,
    };
  }

  factory Chalet.fromMap(Map<String, dynamic> map) {
    return Chalet(
      name: map['name'] ?? '',
      price: map['prise'].toString() ??
          '', // Corrected 'prise' to match the Sequelize model
      photo: File(map['main_image'].startsWith(
              r"C:\project\Palestinian-chalet\frontend\graduation_project\")
          ? map['main_image']
              .substring(
                  r"C:\project\Palestinian-chalet\frontend\graduation_project\"
                      .length)
              .replaceAll('\\', '/')
          : map['main_image']),
      numberOfRooms:
          map['nomber_of_rome'].toString() ?? '', // Corrected 'nomber_of_rome'
      position: LatLng(
        map['gps']['coordinates'][1] ??
            0.0, // Adjusted to match the Sequelize model
        map['gps']['coordinates'][0] ??
            0.0, // Adjusted to match the Sequelize model
      ),
      hasSwimmingPool: map['swimmingPool'] ?? false,
      isFavorite: map['isFavorite'] ?? false,

      path: map['main_image'].startsWith(
              r"C:\project\Palestinian-chalet\frontend\graduation_project\")
          ? map['main_image']
              .substring(
                  r"C:\project\Palestinian-chalet\frontend\graduation_project\"
                      .length)
              .replaceAll('\\', '/')
          : map['main_image'],
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

    // Retrieve the token from shared preferences
    final String? token = prefs.getString('token');
    print('token: ${token}');
    if (token == null) {
      // Handle the case where the token is not available
      // You might want to redirect the user to the login screen
      return;
    }

    // Continue with making API requests using the token...
    final String apiUrl =
        'http://10.0.2.2:8080/api/v1/chales'; // Replace with your API URL

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        // Parse and handle the API response...
        final List<dynamic> chaletsData = json.decode(response.body);
        List<Chalet> loadedChalets = chaletsData.map((chaletMap) {
          return Chalet.fromMap(chaletMap);
        }).toList();

        setState(() {
          chalets = loadedChalets;
        });
      } else {
        // Handle API request errors...
        print('Failed to load chalets: ${response.statusCode}');
      }
    } catch (e) {
      // Handle API request exceptions...
      print('Exception during chalet loading: $e');
    }
  }

  Future<void> _addChalet(String name, String price, File photo,
      String numberOfRooms, LatLng position, bool hasSwimmingPool) async {
    final newChalet = Chalet(
        name: name,
        price: price,
        photo: photo,
        numberOfRooms: numberOfRooms,
        position: position,
        hasSwimmingPool: hasSwimmingPool,
        path: "jh");
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
    final chaletData =
        chalets.map((chalet) => json.encode(chalet.toMap())).toList();
    await prefs.setStringList('chalets', chaletData);
  }

  Future<void> _showAddChaletDialog() async {
    String chaletName = '';
    String chaletPrice = '';
    String numberOfRooms = '';
    LatLng position = LatLng(
        0, 0); // Default position, you might want to add UI to select position
    bool hasSwimmingPool = false;
    String latitude = ''; // New variable for latitude
    String longitude = ''; // New variable for longitude
    XFile? image;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage the dialog's internal state
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Add New Chalet',
                style: TextStyle(color: Colors.redAccent),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) => chaletName = value,
                      decoration:
                          InputDecoration(hintText: "Enter chalet name"),
                    ),
                    TextField(
                      onChanged: (value) => chaletPrice = value,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(hintText: "Enter chalet price"),
                    ),
                    TextField(
                      onChanged: (value) => numberOfRooms = value,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(hintText: "Enter number of rooms"),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent, // Background color
                      ),
                      icon: Icon(Icons.map),
                      label: Text('Select Location on Map'),
                      onPressed: () async {
                        final LatLng? result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );

                        if (result != null) {
                          // Check if a result was returned
                          setState(() {
                            latitude = result.latitude.toString();
                            longitude = result.longitude.toString();
                          });
                        }
                      },
                    ),

// Latitude and Longitude text fields
                    TextField(
                      controller: TextEditingController(text: latitude),
                      onChanged: (value) => latitude = value,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(hintText: "Enter latitude"),
                    ),
                    TextField(
                      controller: TextEditingController(text: longitude),
                      onChanged: (value) => longitude = value,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(hintText: "Enter longitude"),
                    ),

                    CheckboxListTile(
                      title: Text("Has Swimming Pool"),
                      value: hasSwimmingPool,
                      onChanged: (bool? value) {
                        setState(() {
                          hasSwimmingPool = value!;
                        });
                      },
                      checkColor: Colors.white, // color of the tick
                      activeColor: Colors.redAccent, // color of the checkbox
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent, // Background color
                      ),
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
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Add', style: TextStyle(color: Colors.redAccent)),
                  onPressed: () async {
                    if (image != null) {
                      File imageFile = await _saveImageToFile(image!);
                      LatLng position = LatLng(
                          double.parse(latitude), double.parse(longitude));
                      _addChalet(chaletName, chaletPrice, imageFile,
                          numberOfRooms, position, hasSwimmingPool);
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
        child: HomeAppBar(
          onFavoritePressed: _navigateToFavoritesScreen,
          onSearchPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(allChalets: chalets),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              children: chalets
                  .map(
                    (chalet) => Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                chalet.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: chalet.isFavorite
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                _toggleFavorite(chalet);
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostScreen(chalet: chalet),
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
                                    image: Image.asset(
                                      chalet.path,
                                    ).image,
                                    fit: BoxFit.cover,
                                    opacity: 0.8,
                                  )),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chalet.name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
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
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  )
                  .toList(),
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

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _selectedPosition = LatLng(32.22762559426675, 35.22060314459795);
  Set<Marker> _markers = {};

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _markers = {
        Marker(
          markerId: MarkerId('selectedPos'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: _selectedPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        onTap: _onMapTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedPosition);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
