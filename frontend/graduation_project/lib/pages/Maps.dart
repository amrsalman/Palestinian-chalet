import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapshState();
}

class _MapshState extends State<Maps> {
  var myMarkers = HashSet<Marker>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: LatLng(32.232672, 35.251136), zoom: 19),
        onMapCreated: (GoogleMapController googleMapController) {
          setState(() {
            myMarkers.add(
              Marker(markerId: MarkerId('1'),
              position: LatLng(32.232672, 35.251136),
              ),
              
            );
          });
        },
          markers:myMarkers,
      ),
    
    );
  }
}
