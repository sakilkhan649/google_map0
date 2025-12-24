import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geocoding_address.dart';

class AddmarkarScreen extends StatefulWidget {
  const AddmarkarScreen({super.key});

  @override
  State<AddmarkarScreen> createState() => _AddmarkarScreenState();
}

class _AddmarkarScreenState extends State<AddmarkarScreen> {
  final Completer<GoogleMapController> _completer =
      Completer(); //map controller

  final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(23.87624161047219, 90.37922760125844),
    zoom: 14.4547,
  ); //initial position

  final List<Marker> _markers = [];

  final List<Marker> _markerList = [
    Marker(
      markerId: MarkerId("1"),
      infoWindow: InfoWindow(title: "Title", snippet: "subtitle"),
      position: LatLng(23.87624161047219, 90.37922760125844),
    ), //depolt Marker
    Marker(
      markerId: MarkerId("2"),
      infoWindow: InfoWindow(title: "Abdullahpur", snippet: "Abdullahpur"),
      position: LatLng(23.66201528111182, 90.3601040867226),
    ), //depolt Marker
    Marker(
      markerId: MarkerId("3"),
      infoWindow: InfoWindow(
        title: "House building",
        snippet: "House building",
      ),
      position: LatLng(23.87464138399251, 90.40093165704262),
    ), //depolt Marker
  ];
  @override
  void initState() {
    super.initState();
    _markers.addAll(_markerList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AddmarkarScreen"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: GoogleMap(
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: false,
                markers: Set.of(_markers), //marker ui te dekhar jonno
                initialCameraPosition: _cameraPosition,

                onMapCreated: (GoogleMapController controller) {
                  _completer.complete(controller);
                }, //smoth kaj korar jonno
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeocodingAddress()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await _completer.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(23.66201528111182, 90.3601040867226),
                zoom: 14.4547,
              ), //destination position
            ),
          );
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
