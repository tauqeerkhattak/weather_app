import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Data {
  static Color primaryColor = Colors.cyan;
  static Color temperatureColor = Colors.black;

  static Future<dynamic> getWeatherData({required String url}) async {
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    else {
      return response.statusCode;
    }
  }
}