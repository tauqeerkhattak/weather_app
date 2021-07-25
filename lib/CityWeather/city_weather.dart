import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:weather_app/Forecast/forecast.dart';
import 'package:weather_app/data.dart';

class CityWeather extends StatefulWidget {
  final String cityName;
  final weatherJSON;

  CityWeather({required this.cityName, required this.weatherJSON});

  @override
  _CityWeatherState createState() =>
      _CityWeatherState(cityName: cityName, weatherJSON: weatherJSON);
}

class _CityWeatherState extends State<CityWeather> {
  final String cityName;
  final weatherJSON;

  _CityWeatherState({required this.cityName, required this.weatherJSON});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WeatherBg(
              weatherType:
                  Data.getWeatherType(weatherJSON['current']['weather'][0]['icon']),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Data.temperatureColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Text(
                                  cityName,
                                  style: TextStyle(
                                    color: Data.temperatureColor,
                                    fontSize: 29,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Feels like ${Data.roundOff(weatherJSON['current']['feels_like'])}\u00B0',
                          style: TextStyle(
                            color: Data.temperatureColor,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${Data.roundOff(weatherJSON['current']['temp'])}\u00B0',
                          style: TextStyle(
                            color: Data.temperatureColor,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          weatherJSON['current']['weather'][0]['main'],
                          style: TextStyle(
                            color: Data.temperatureColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Forecast(
                            epoch: weatherJSON['daily'][1]['dt'],
                            icon: weatherJSON['daily'][1]['weather'][0]['icon'],
                            temp: weatherJSON['daily'][1]['temp']['day'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
