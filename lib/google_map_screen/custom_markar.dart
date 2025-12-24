import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/image/images.dart';
import 'custom_info_place.dart';


class CustomMarkar extends StatefulWidget {
  CustomMarkar({super.key});

  @override
  State<CustomInfoPlace> createState() => _CustomInfoPlaceState();
}

class _CustomInfoPlaceState extends State<CustomInfoPlace> {
  final Completer<GoogleMapController> _completer = Completer();
  final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(23.8017531667528, 90.43260825148754),
    zoom: 14.1445,
  );

  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  List<Marker> _markers = [];
  List<LatLng> _listLatLng = [
    LatLng(23.8017531667528, 90.43260825148754),
    LatLng(23.795470570291073, 90.41372550210008),
    LatLng(23.8185576185972, 90.40222419110954),
    LatLng(23.79719831460473, 90.39295447777386),
  ];

  final List<String> imagePlace = [
    AppImages.mirpur,
    AppImages.mirpur,
    AppImages.mirpur,
    AppImages.mirpur,
  ];
  final List<String> placeTitle = [
    "Mirpur 10",
    "Mirpur 11",
    "Mirpur 12",
    "Mirpur 13",
  ];
  final List<String> placeSubtitle = [
    "Dhaka Mirpur 10",
    "Dhaka Mirpur 11",
    "Dhaka Mirpur 12",
    "Dhaka Mirpur 13",
  ];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    for (int i = 0; i < _listLatLng.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: _listLatLng[i],
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.asset(
                        imagePlace[i],
                        height: 100,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                      child: Row(
                        children: [
                          Text(placeTitle[i], style: TextStyle(fontWeight: FontWeight.bold)),
                          Spacer(),
                          Text("120km", style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(placeSubtitle[i]),
                    ),
                  ],
                ),
              ),
              _listLatLng[i],
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Info Window"), centerTitle: true),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _cameraPosition,
            markers: Set.of(_markers),
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (controller) {
              _completer.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 150,
            width: 300,
            offset: 50,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }
}
