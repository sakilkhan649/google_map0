import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/utils/image/images.dart';

class CustomInfoPlace extends StatefulWidget {
  const CustomInfoPlace({super.key});

  @override
  State<CustomInfoPlace> createState() => _CustomInfoPlaceState();
}

class _CustomInfoPlaceState extends State<CustomInfoPlace> {
  final Completer<GoogleMapController> _completer = Completer();
  final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(23.8017531667528, 90.43260825148754),
    zoom: 14.1445,
  );

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  List<Marker> _markers = <Marker>[];
  List<LatLng> _listLatLng = [
    LatLng(23.8017531667528, 90.43260825148754),
    LatLng(23.795470570291073, 90.41372550210008),
    LatLng(23.8185576185972, 90.40222419110954),
    LatLng(23.79719831460473, 90.39295447777386),
  ];

  final List imagePlace = [
    AppImages.mirpur,
    AppImages.mirpur,
    AppImages.mirpur,
    AppImages.mirpur,
  ];
  final List<dynamic> placeTitle = [
    "Mirpur 10",
    "Mirpur 11",
    "Mirpur 12",
    "Mirpur 13",
  ];
  final List<dynamic> placeSubtitle = [
    "Dhaka Mirpur 10",
    "Dhaka Mirpur 11",
    "Dhaka Mirpur 12",
    "Dhaka Mirpur 13",
  ];

  @override
  void initState() {
    super.initState();
    LoadData();
  }

  LoadData() {
    for (int i = 0; i < _listLatLng.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.defaultMarker,
          position: _listLatLng[i],
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePlace[i]),
                          fit: BoxFit.fitWidth,
                          filterQuality: FilterQuality.high,
                        ),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(child: Text(placeTitle[i])),
                          Spacer(),
                          Text("120km"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
      appBar: AppBar(title: Text("CustomInfoPlace"), centerTitle: true),
      body: Stack(
        children: [
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 100,
            width: 300,
            offset: 35,
          ),
         Container(
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: GoogleMap(
            markers: Set.of(_markers),
            initialCameraPosition: _cameraPosition,
            onTap: (position){
              _customInfoWindowController.hideInfoWindow!();
            },
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController=controller;
            },
            onCameraMove: (position){
              _customInfoWindowController.onCameraMove!();
            },
          ),
        ),
      ]
      ),
    );
  }
}
