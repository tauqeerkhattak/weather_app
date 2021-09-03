// @ dart = 2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/MapScreen/map_screen.dart';
import 'package:weather_app/Services/notification_service.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotifications();
  NotificationService.showNotification();
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}