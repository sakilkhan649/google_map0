import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'addMarkar_screen.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _completer = Completer();
  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(23.777719262426036, 90.40575122170915),
    zoom: 14.4546,
  ); //initial position

  static const CameraPosition _position = CameraPosition(
    target: LatLng(23.793433121747395, 90.27225485106028),
    zoom: 14.4546,
  ); //destination position

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _completer.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_position));
  } //destination position method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GoogleMapScreen"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: GoogleMap(
                initialCameraPosition: _cameraPosition,
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
                  MaterialPageRoute(builder: (context) => AddmarkarScreen()),
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
        onPressed: () {
          _goToLocation(); //destination position call
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
