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
  Set<Polyline> _polylines = {};
  late GoogleMapController mapController;
  final LatLng initialPosition = LatLng(32.22762559426675, 35.22060314459795);

  @override
  void initState() {
    super.initState();
    _addInitialMarker();
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 8,
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
