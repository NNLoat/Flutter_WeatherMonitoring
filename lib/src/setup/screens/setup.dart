import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_app/src/landing/screens/landing.dart';
import '/src/home/screens/home.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SetupState();
  }
}

class _SetupState extends State<Setup> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Position? _position;

  void _getLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  void _movePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "We need to access your location",
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Image(
                  image: const AssetImage('assets/images/map_location.png'),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const Text(
                      "Your location will allow us to get the weather data on the location that you located. You will see a pop up windows to ask for locaiton permission, so please grant the access. Thanks",
                      textAlign: TextAlign.center),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: _position != null
                        ? Text(
                            "Your Location is: \n$_position",
                            textAlign: TextAlign.center,
                          )
                        : const Text("No location yet")),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.08,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: const Text("Permit location access"),
                  onPressed: () => _getLocation(),
                ),
                const SizedBox(
                  height: 10,
                ),
                _position != null
                    ? MaterialButton(
                        minWidth: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.08,
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text("Next"),
                        onPressed: () => _movePage(),
                      )
                    : MaterialButton(
                        minWidth: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.08,
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        onPressed: null,
                        child: const Text("Next"),
                      )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
