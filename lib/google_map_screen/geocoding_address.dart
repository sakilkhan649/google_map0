import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:googlemap/google_map_screen/userCurrentlocation.dart';

class GeocodingAddress extends StatefulWidget {
  const GeocodingAddress({super.key});

  @override
  State<GeocodingAddress> createState() => _GeocodingAddressState();
}

class _GeocodingAddressState extends State<GeocodingAddress> {
  String address = "";
  String latlong = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Geocoding Address"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(latlong, style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text(address, style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // 1. Forward geocoding
                    List<Location> locations = await locationFromAddress(
                      "Gronausestraat 710, Enschede",
                    );

                    double lat = locations.last.latitude;
                    double lng = locations.last.longitude;

                    // 2. Reverse geocoding using same coordinates
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      23.87462176238409,
                      90.40070635151017,
                    );

                    Placemark place = placemarks.last;

                    setState(() {
                      latlong = "Latitude: $lat\nLongitude: $lng";
                      address =
                          "Country: ${place.country}\nCity: ${place.locality}\nStreet: ${place.street}";
                    });
                  } catch (e) {
                    setState(() {
                      latlong = "";
                      address = "Error: ${e.toString()}";
                      print(e.toString());
                    });
                  }
                },
                child: Text("Convert Address"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Usercurrentlocation(),
                    ),
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
      ),
    );
  }
}
