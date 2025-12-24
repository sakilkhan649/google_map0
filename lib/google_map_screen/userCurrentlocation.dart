import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'custom_markar.dart';

class Usercurrentlocation extends StatefulWidget {
  const Usercurrentlocation({super.key});

  @override
  State<Usercurrentlocation> createState() => _UsercurrentlocationState();
}

class _UsercurrentlocationState extends State<Usercurrentlocation> {
  final Completer<GoogleMapController> _completer = Completer();
  final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(23.87451389302188, 90.39963167389556),
    zoom: 14.1445,
  );

  List<Marker> _markers = [];
  List<Marker> _markersList = [
    Marker(
      markerId: MarkerId("1"),
      infoWindow: InfoWindow(title: "Dhaka", snippet: "Dhaka uttra"),
      position: LatLng(23.87451389302188, 90.39963167389556),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _markers.addAll(_markersList);
    getUserCurrentLocation();
    LoadData();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((e, error) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  LoadData() {
    getUserCurrentLocation().then((value) async {
      print("Latitude:${value.latitude}");
      print(value.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        value.latitude,
        value.longitude,
      );

      setState(() {
        print(placemarks.last.country);
        print(placemarks.last.locality);
        print(placemarks.last.street);
      });
      _markers.add(
        Marker(
          markerId: MarkerId("2"),
          infoWindow: InfoWindow(
            title: placemarks.last.country,
            snippet: placemarks.last.street,
          ),
          position: LatLng(value.latitude, value.longitude),
        ),
      );

      GoogleMapController controller = await _completer.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 14.1445,
            target: LatLng(value.latitude, value.longitude),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usercurrentlocation"), centerTitle: true),
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
                myLocationEnabled: false,
                markers: Set.of(_markers),
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
                  MaterialPageRoute(builder: (context) => CustomInfoPlace()),
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
          LoadData();
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
