import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Chalet {
  final String name;
  final String location;
  final int nomber_of_rome;
  final int prise;
  final bool swimmingPool;
  final String nameuser;
  final String description;
  final double latitude;
  final double longitude;
  final String mainImage;

  Chalet({
    required this.name,
    required this.location,
    required this.nomber_of_rome,
    required this.prise,
    required this.swimmingPool,
    required this.nameuser,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.mainImage,
  });
}

Future<List<Chalet>> fetchChaletData() async {
  final prefs = await SharedPreferences.getInstance();

  final String? token = prefs.getString('token') ?? '';
  print('token: $token');

  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/api/v1/chales'),
    headers: {'Authorization': '$token'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> chaletsData = json.decode(response.body);
    print(response.body);
    List<Chalet> chalets = chaletsData
        .map((chaletMap) => Chalet(
              name: chaletMap['name'],
              location: chaletMap['location'],
              nomber_of_rome: chaletMap['nomber_of_rome'],
              prise: chaletMap['prise'],
              swimmingPool: chaletMap['swimmingPool'],
              nameuser: chaletMap['nameuser'],
              description: chaletMap['description'],
              latitude: chaletMap['gps']['coordinates'][0],
              longitude: chaletMap['gps']['coordinates'][1],
              mainImage: chaletMap['main_image'],
            ))
        .toList();
    return chalets;
  } else {
    throw Exception('Failed to load chalet data');
  }
}

class Maps extends StatefulWidget {

  
  @override
  State<Maps> createState() => _MapshState();
}

class _MapshState extends State<Maps> {
  List<Chalet> chalets = [];
  var myMarkers = HashSet<Marker>();
  Set<Polyline> _polylines = {};
  late GoogleMapController mapController;
  final LatLng initialPosition =
      LatLng(32.22762559426675, 35.22060314459795);

  @override
  void initState() {
    super.initState();
    _addInitialMarker();
    _fetchAndAddChaletMarkers();
  }

  void _addInitialMarker() {
    setState(() {
      myMarkers.add(
        Marker(
          markerId: MarkerId('initial_position'),
          position: initialPosition,
          infoWindow: InfoWindow(
            title: 'Initial Position',
            snippet:
                'Lat: ${initialPosition.latitude}, Lng: ${initialPosition.longitude}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarkers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(
            title: 'Selected Location',
            snippet:
                'Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}',
          ),
        ),
      );
    });
  }

  void _fetchAndAddChaletMarkers() async {
    try {
      List<Chalet> chalets = await fetchChaletData();
      for (Chalet chalet in chalets) {
        myMarkers.add(
          Marker(
            markerId: MarkerId(chalet.name),
            position:
                LatLng(chalet.latitude, chalet.longitude),
            infoWindow: InfoWindow(
              title: chalet.name,
              snippet: 'Price: \$${chalet.prise}',
              
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          ),
        );
      }
    } catch (e) {
      print('Error fetching chalet data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: myMarkers,
        polylines: _polylines,
        onTap: _handleTap,
      ),
    );
  }
}
