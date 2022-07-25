import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/Services/notification_service.dart';
import 'package:weather_app/screens/map_screen/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotifications();
  NotificationService.showNotification();
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MapScreen(),
    );
  }
}
