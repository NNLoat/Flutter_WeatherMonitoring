import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:geolocator/geolocator.dart';

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
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Weather Forecast',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.transparent,
        shadowColor: const Color.fromARGB(2, 255, 255, 255),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        centerTitle: true,
        leading: const BoxedIcon(WeatherIcons.day_sunny),
      ),
      body: Stack(children: <Widget>[
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("background.jpg"), fit: BoxFit.cover)),
        ),
        const ElevatedCardExample()
      ]),
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
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
