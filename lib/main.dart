import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/HomeScreen/home_screen.dart';

void main () {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}