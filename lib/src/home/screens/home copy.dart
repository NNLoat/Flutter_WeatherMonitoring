//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  Widget buid(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String FetchURL = '';
  Position? pos;
  Map<String, dynamic> jsonData = {};
  Placemark? placemarks;
  final String APIKEY = "cdacf887b7712c59a6608a9904f73ef8";
  final user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    _getUserLocationAndWeather();
    super.initState();
  }

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

  // void _applyData() async {
  //   var jsontmp = await _fetchData();
  //   jsonData = jsontmp;
  //   debugPrint(jsonData.toString());
  // }

  void _getUserLocationAndWeather() async {
    pos = await _determinePosition();
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(pos!.latitude, pos!.longitude);
    var jsontmp = await _fetchData();

    setState(() {
      // this.placemarks = placemarks.elementAt(0);
      jsonData = jsontmp;
    });
  }

  Future<Map<String, dynamic>> _fetchData() async {
    // FetchURL =
    //     "https://api.open-meteo.com/v1/forecast?latitude=${pos!.latitude}&longitude=${pos!.longitude}&current_weather=true&timezone=auto";
    FetchURL =
        "https://api.openweathermap.org/data/2.5/weather?lat=${pos!.latitude}&lon=${pos!.longitude}&units=metric&appid=${APIKEY}";
    final dio = Dio();
    final res = await dio.get(FetchURL,
        options: Options(responseType: ResponseType.plain));
    if (res.statusCode == 200) {
      return jsonDecode(res.data);
    }
    throw Future.error('Error the response data is null');
  }

  // Widget homepage(BuildContext context) {
  //   return ();
  // }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text("Your location is: ${pos.toString()}"),
            const SizedBox(
              height: 10,
            ),
            // jsonData != {}
            //     ? Text("Current weather: ${jsonData['latitude']}")
            //     : const Text("No current Weather"),
            jsonData != {}
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Image.network(
                              'https://openweathermap.org/img/wn/${jsonData['weather'][0]['icon']}@2x.png')),
                      FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          "${jsonData['name']}",
                          style: WeatherTextStyle.weatherMain,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text("${jsonData['main']['temp']}°",
                          style: WeatherTextStyle.weatherSecondary,
                          textAlign: TextAlign.center),
                      Text('${jsonData['weather'][0]['description']}',
                          style: WeatherTextStyle.weatherGrey,
                          textAlign: TextAlign.center),
                      const Image(
                          image: AssetImage('assets/images/home-pixel.gif'))
                    ],
                  )
                : Container(
                    child: null,
                  ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
      //   ],
      // ),
    ));
  }
}

class Settings extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  Settings({super.key});

  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Signed in as ${user.email}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
                minWidth: double.infinity,
                height: MediaQuery.of(context).size.height * 0.19,
                color: Colors.redAccent,
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: Row(
                  children: const [Icon(Icons.arrow_back), Text('Sign out')],
                ))
          ]),
        )));
  }
}

class WeatherTextStyle {
  static const TextStyle weatherMain =
      TextStyle(fontSize: 50, fontWeight: FontWeight.w300);
  static const TextStyle weatherSecondary =
      TextStyle(fontSize: 50, fontWeight: FontWeight.w200);
  static const TextStyle weatherGrey =
      TextStyle(fontSize: 25, fontWeight: FontWeight.w200, color: Colors.grey);
}

class ElevatedCardExample extends StatelessWidget {
  const ElevatedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const FractionalOffset(0.5, 0.3),
      child: Card(
        color: Colors.transparent,
        elevation: 2,
        child: SizedBox(
          width: 300,
          height: 400,
          child: Column(
            children: <Widget>[
              const Align(
                  alignment: Alignment.topCenter,
                  child: Text('New York, United States',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 3,
                          fontSize: 22,
                          color: Colors.white))),
              RichText(
                text: const TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: '13',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              fontSize: 80)),
                      TextSpan(text: '°C', style: TextStyle(fontSize: 40))
                    ]),
              ),
              const Align(
                  alignment: FractionalOffset(0.45, 0.5),
                  child: Icon(
                    WeatherIcons.day_cloudy,
                    size: 100,
                    color: Colors.white,
                  )),
              RichText(
                  text: const TextSpan(
                      text: 'Day Cloudy',
                      style: TextStyle(
                          height: 3,
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      ),
    );
  }
}
