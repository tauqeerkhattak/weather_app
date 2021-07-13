import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:weather_app/data.dart';

class CityWeather extends StatefulWidget {
  final String cityName;

  CityWeather({required this.cityName});

  @override
  _CityWeatherState createState() => _CityWeatherState(cityName: cityName);
}

class _CityWeatherState extends State<CityWeather> {
  final String cityName;
  var weatherType;

  _CityWeatherState({required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
        centerTitle: true,
        backgroundColor: Data.primaryColor,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WeatherBg(
              weatherType: WeatherType.sunnyNight,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            FutureBuilder(
              future: Data.getWeatherData(
                url:
                    'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=1aca8b01724808e81031434cd1341c65',
              ),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  double temperature = snapshot.data['main']['temp'];
                  final mainWeather = snapshot.data['weather'][0];
                  String description = mainWeather['description'];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        temperature.toString(),
                        style: TextStyle(
                          color: Data.temperatureColor,
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description.toString(),
                        style: TextStyle(
                          color: Data.temperatureColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
