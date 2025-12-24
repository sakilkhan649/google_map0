import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/google_map_screen/polyline_home_screen.dart';
import 'package:googlemap/utils/image/images.dart';

class CustomInfoPlace extends StatefulWidget {
  const CustomInfoPlace({super.key});

  @override
  State<CustomInfoPlace> createState() => _CustomInfoPlaceState();
}

class _CustomInfoPlaceState extends State<CustomInfoPlace> {
  final Completer<GoogleMapController> _completer = Completer();

  final CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(23.8017531667528, 90.43260825148754),
    zoom: 14.14,
  );

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final List<Marker> _markers = [];

  final List<LatLng> _listLatLng = const [
    LatLng(23.8017531667528, 90.43260825148754),
    LatLng(23.795470570291073, 90.41372550210008),
    LatLng(23.8185576185972, 90.40222419110954),
    LatLng(23.79719831460473, 90.39295447777386),
  ];

  final List<String> imagePlace = [
    AppImages.placeImage,
    AppImages.placeImage,
    AppImages.placeImage,
    AppImages.placeImage,
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
          position: _listLatLng[i],
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              _buildInfoWindow(i),
              _listLatLng[i],
            );
          },
        ),
      );
    }
  }

  /// 🔹 Custom Info Window Widget (NO OVERFLOW)
  Widget _buildInfoWindow(int i) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                imagePlace[i],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Text(
                    placeTitle[i],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Text("120 km"),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                placeSubtitle[i],
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Info Place"), centerTitle: true),
      body: Column(
        children: [
          Container(
            height: 600,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _cameraPosition,
                  markers: Set.of(_markers),
                  onTap: (_) => _customInfoWindowController.hideInfoWindow!(),
                  onMapCreated: (controller) {
                    _customInfoWindowController.googleMapController =
                        controller;
                    _completer.complete(controller);
                  },
                  onCameraMove: (_) {
                    _customInfoWindowController.onCameraMove!();
                  },
                ),

                /// 🔹 Custom Info Window overlay
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 220, // ✅ image + text height
                  width: 300,
                  offset: 40,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PolylineHomeScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
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
    );
  }
}
