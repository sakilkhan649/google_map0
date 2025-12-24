import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/utils/image/images.dart';
import 'custom_info_place.dart';

class CustomMarkar extends StatefulWidget {
  const CustomMarkar({super.key});

  @override
  State<CustomMarkar> createState() => _CustomMarkarState();
}

class _CustomMarkarState extends State<CustomMarkar> {
  final Completer<GoogleMapController> _completer = Completer();

  final CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(23.8017531667528, 90.43260825148754),
    zoom: 14.14,
  );

  final List<Marker> _markerList = [];

  final List<LatLng> _listLatLng = const [
    LatLng(23.8017531667528, 90.43260825148754),
    LatLng(23.795470570291073, 90.41372550210008),
    LatLng(23.8185576185972, 90.40222419110954),
    LatLng(23.79719831460473, 90.39295447777386),
  ];

  final List<String> imageAssets = [
    AppImages.sakilImage,
    AppImages.sakilImage,
    AppImages.sakilImage,
    AppImages.sakilImage,
  ];

  final List<String> tile = [
    "Mirpur 10",
    "Mirpur 11",
    "Mirpur 12",
    "Mirpur 13",
  ];

  final List<String> subtitle = [
    "Dhaka Mirpur 10",
    "Dhaka Mirpur 11",
    "Dhaka Mirpur 12",
    "Dhaka Mirpur 13",
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final List<Marker> markers = [];

    for (int i = 0; i < imageAssets.length; i++) {
      final Uint8List icon = await getBytesFromAsset(imageAssets[i], 100);

      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _listLatLng[i],
          icon: BitmapDescriptor.fromBytes(icon),
          infoWindow: InfoWindow(title: tile[i], snippet: subtitle[i]),
        ),
      );
    }

    setState(() {
      _markerList.clear();
      _markerList.addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Marker"), centerTitle: true),
      body: Column(
        children: [
          SizedBox(
            height: 600,
            child: GoogleMap(
              markers: Set.of(_markerList),
              initialCameraPosition: _cameraPosition,
              onMapCreated: (controller) {
                _completer.complete(controller);
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomInfoPlace(),
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
