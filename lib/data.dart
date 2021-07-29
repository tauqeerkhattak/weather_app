import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:intl/intl.dart';

class Data {
  static Color primaryColor = Colors.cyan;
  static Color secondaryColor = Colors.white;
  static Color temperatureColor = Colors.black;
  static Color forecastBackgroundColor = Colors.transparent.withOpacity(0.1);

  static Future<dynamic> getWeatherData({required double lat,required double long}) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&units=metric&exclude=minutely,hourly&appid=1aca8b01724808e81031434cd1341c65'),
    );
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    }
    else {
      return response.statusCode;
    }
  }

  static WeatherType getWeatherType (String weatherCode) {
    switch (weatherCode) {
      case '01d':
        return WeatherType.sunny;
      case '01n':
        return WeatherType.sunnyNight;
      case '02d':
        return WeatherType.cloudy;
      case '02n':
        return WeatherType.cloudyNight;
      case '03d':
        return WeatherType.overcast;
      case '03n':
        return WeatherType.overcast;
      case '04d':
        return WeatherType.hazy;
      case '04n':
        return WeatherType.hazy;
      case '09d':
        return WeatherType.middleRainy;
      case '09n':
        return WeatherType.middleRainy;
      case '10d':
        return WeatherType.heavyRainy;
      case '10n':
        return WeatherType.heavyRainy;
      case '11d':
        return WeatherType.thunder;
      case '11n':
        return WeatherType.thunder;
      case '13d':
        return WeatherType.heavySnow;
      case '13n':
        return WeatherType.heavySnow;
      case '50d':
        return WeatherType.foggy;
      case '50n':
        return WeatherType.foggy;
      default:
        return WeatherType.cloudy;
    }
  }

  static String roundOff (double temperature) {
    String temp = temperature.toString();
    String stringDecimalPart = temp.split('.')[1];
    double doubleDecimalPart = double.parse('0.'+stringDecimalPart);
    print(temperature);
    print(doubleDecimalPart);
    if (doubleDecimalPart >= 0.4 && doubleDecimalPart <= 0.6) {
      return temperature.toStringAsFixed(1);
    }
    else {
      double i = 1 - doubleDecimalPart;
      if (i > 0.6) {
        temperature = temperature - doubleDecimalPart;
        int intTemperature = temperature.floor();
        return '$intTemperature';
      }
      else {
        temperature = temperature + i;
        int intTemperature = temperature.floor();
        return '$intTemperature';
      }
    }
  }

  static String epochToDay (int epoch) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    DateFormat format = DateFormat('E');
    var day = format.format(date);
    return day;
  }

  static String epochToDate (int epoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    DateFormat format = DateFormat('MMMd');
    var date = format.format(dateTime);
    return date;
  }

  static String epochToFullDate (int epoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    DateFormat format = DateFormat('EEEE, MMMM d, yyyy');
    var date = format.format(dateTime);
    return date;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}