import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'custom_markar.dart';

class PolylineHomeScreen extends StatefulWidget {
  const PolylineHomeScreen({super.key});

  @override
  State<PolylineHomeScreen> createState() => _PolylineHomeScreenState();
}

class _PolylineHomeScreenState extends State<PolylineHomeScreen> {
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(23.84375821272476, 90.40339726500484),
    zoom: 14.4547,
  );

  final Completer<GoogleMapController> _completer = Completer();

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> points = [
    LatLng(23.84375821272476, 90.40339726500484),
    LatLng(23.860607926498794, 90.3884305403483),
    LatLng(23.83297476382733, 90.39461034923873),
    LatLng(23.83171857102894, 90.41984456887471),
  ];

  List<Map<String, dynamic>> names = [
    {
      'title': "Airport",
      'subtitle': "Hazrat Shahjalal International Airport",
      'latlng': LatLng(23.84375821272476, 90.40339726500484),
    },
    {
      'title': "BAF Shaheen",
      'subtitle': "BAF Shaheen College Kurmitola",
      'latlng': LatLng(23.83281774039285, 90.4081715965261),
    },
    {
      'title': "Dakshin",
      'subtitle': "Dakshin Khan",
      'latlng': LatLng(23.852712035065224, 90.42563410437991),
    },
    {
      'title': "Bepari",
      'subtitle': "Bepari Market",
      'latlng': LatLng(23.838799910110087, 90.38651700474679),
    },
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < names.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: names[i]['latlng'],
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: names[i]['title'],
            snippet: names[i]['subtitle'],
          ),
        ),
      );
      _polylines.add(
        Polyline(
          polylineId: PolylineId(i.toString()),
          points: points,
          color: Colors.blue,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          patterns: [PatternItem.dot],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PolylineHomeScreen"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 600,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  _completer.complete(controller);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomMarkar()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
