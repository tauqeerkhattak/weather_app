import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
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

  String temperature = '',
      description = '',
      feelsLike = '',
      currentWeatherIcon = '';
  int currentEpoch = 0, humidity = 0;
  double currentWindSpeed = 0;
  List<Color> forecastColors = [
    Data.primaryColor,
    Data.forecastBackgroundColor,
    Data.forecastBackgroundColor,
    Data.forecastBackgroundColor,
    Data.forecastBackgroundColor,
    Data.forecastBackgroundColor,
    Data.forecastBackgroundColor,
    Data.forecastBackgroundColor,
  ];
  List <String> temperaturesOfWeek = [];

  Future <void> setData () async {
    Data.getUnit(Data.roundOff(double.parse(weatherJSON['current']['temp'].toString()))).then((value) {
      setState(() {
        temperature = value;
      });
    });
    Data.getUnit(Data.roundOff(
        double.parse((weatherJSON['current']['feels_like']).toString()))).then((value) {
          setState(() {
            feelsLike = value;
          });
    });
    description = weatherJSON['current']['weather'][0]['main'];
    currentEpoch = weatherJSON['current']['dt'];
    currentWeatherIcon = weatherJSON['current']['weather'][0]['icon'];
    currentWindSpeed = double.parse(weatherJSON['current']['wind_speed'].toString());
    humidity = weatherJSON['current']['humidity'];
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['current']['temp']
            .toString()))));
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['daily'][1]
        ['temp']['day']
            .toString()))));
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['daily'][2]
        ['temp']['day']
            .toString()))));
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['daily'][3]
        ['temp']['day']
            .toString()))));
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['daily'][4]
        ['temp']['day']
            .toString()))));
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['daily'][5]
        ['temp']['day']
            .toString()))));
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['daily'][6]
        ['temp']['day']
            .toString()))));
    temperaturesOfWeek.add(await Data.getUnit(Data.roundOff(double.parse(
        weatherJSON['daily'][7]
        ['temp']['day']
            .toString()))));
  }

  @override
  initState() {
    setData();
    super.initState();
  }

  _CityWeatherState({required this.cityName, required this.weatherJSON});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WeatherBg(
              weatherType: Data.getWeatherType(currentWeatherIcon),
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
                            Container(
                              margin: EdgeInsets.only(left: 5, right: 10),
                              child: Icon(
                                Icons.location_on,
                                size: 30,
                                color: Data.primaryColor,
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Text(
                                  cityName,
                                  style: TextStyle(
                                    color: Data.secondaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Feels like $feelsLike \u00b0',
                          style: TextStyle(
                            color: Data.secondaryColor,
                            fontSize: 22,
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
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        CupertinoIcons.wind,
                                        color: Data.primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      currentWindSpeed.toString() + ' m/s',
                                      style: TextStyle(
                                        color: Data.secondaryColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        CupertinoIcons.drop_fill,
                                        color: Data.primaryColor,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      humidity.toString() + ' %',
                                      style: TextStyle(
                                        color: Data.secondaryColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$temperature',
                              style: TextStyle(
                                color: Data.secondaryColor,
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\u00B0',
                              style: TextStyle(
                                color: Data.primaryColor,
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Weather: ',
                              style: TextStyle(
                                color: Data.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              description[0].toUpperCase() +
                                  description.substring(1),
                              style: TextStyle(
                                color: Data.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              Data.epochToFullDate(currentEpoch),
                              style: TextStyle(
                                color: Data.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['current']['temp']
                                        .toString())));
                                String feels_like = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['current']['feels_like']
                                        .toString())));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['current']
                                      ['weather'][0]['main'];
                                  currentEpoch = weatherJSON['current']['dt'];
                                  currentWeatherIcon = weatherJSON['current']
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['current']['wind_speed'];
                                  humidity = weatherJSON['current']['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 0) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[0],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                Data.epochToDay(
                                                    weatherJSON['current']['dt']),
                                                style: TextStyle(
                                                  color: Data.secondaryColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: Text(
                                                Data.epochToDate(
                                                    weatherJSON['current']['dt']),
                                                style: TextStyle(
                                                  color: Data.secondaryColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['current']['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          temperaturesOfWeek[0] + '\u00B0',
                                          style: TextStyle(
                                            color: Data.secondaryColor,
                                            fontSize: 37,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][1]['temp']['day']
                                        .toString())));
                                String feels_like = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][1]['feels_like']
                                    ['day']
                                        .toString())));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['daily'][1]
                                      ['weather'][0]['description'];
                                  currentEpoch = weatherJSON['daily'][1]['dt'];
                                  currentWeatherIcon = weatherJSON['daily'][1]
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['daily'][1]['wind_speed'];
                                  humidity =
                                      weatherJSON['daily'][1]['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 1) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[1],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              Data.epochToDay(
                                                  weatherJSON['daily'][1]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              Data.epochToDate(
                                                  weatherJSON['daily'][1]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['daily'][1]['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          temperaturesOfWeek[1] + '\u00B0',
                                          style: TextStyle(
                                            color: Data.secondaryColor,
                                            fontSize: 37,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][2]['temp']['day']
                                        .toString())));
                                String feels_like = Data.roundOff(double.parse(
                                    weatherJSON['daily'][2]['feels_like']
                                    ['day']
                                        .toString()));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['daily'][2]
                                      ['weather'][0]['description'];
                                  currentEpoch = weatherJSON['daily'][2]['dt'];
                                  currentWeatherIcon = weatherJSON['daily'][2]
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['daily'][2]['wind_speed'];
                                  humidity =
                                      weatherJSON['daily'][2]['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 2) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[2],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              Data.epochToDay(
                                                  weatherJSON['daily'][2]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              Data.epochToDate(
                                                  weatherJSON['daily'][2]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['daily'][2]['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            temperaturesOfWeek[2] + '\u00B0',
                                            style: TextStyle(
                                              color: Data.secondaryColor,
                                              fontSize: 37,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][3]['temp']['day']
                                        .toString())));
                                String feels_like = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][3]['feels_like']
                                    ['day']
                                        .toString())));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['daily'][3]
                                      ['weather'][0]['description'];
                                  currentEpoch = weatherJSON['daily'][3]['dt'];
                                  currentWeatherIcon = weatherJSON['daily'][3]
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['daily'][3]['wind_speed'];
                                  humidity =
                                      weatherJSON['daily'][3]['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 3) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[3],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              Data.epochToDay(
                                                  weatherJSON['daily'][3]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              Data.epochToDate(
                                                  weatherJSON['daily'][3]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['daily'][3]['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            temperaturesOfWeek[3] + '\u00B0',
                                            style: TextStyle(
                                              color: Data.secondaryColor,
                                              fontSize: 37,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][4]['temp']['day']
                                        .toString())));
                                String feels_like = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][4]['feels_like']
                                    ['day']
                                        .toString())));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['daily'][4]
                                      ['weather'][0]['description'];
                                  currentEpoch = weatherJSON['daily'][4]['dt'];
                                  currentWeatherIcon = weatherJSON['daily'][4]
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['daily'][4]['wind_speed'];
                                  humidity =
                                      weatherJSON['daily'][4]['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 4) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[4],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              Data.epochToDay(
                                                  weatherJSON['daily'][4]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              Data.epochToDate(
                                                  weatherJSON['daily'][4]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['daily'][4]['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          temperaturesOfWeek[4] + '\u00B0',
                                          style: TextStyle(
                                            color: Data.secondaryColor,
                                            fontSize: 37,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][5]['temp']['day']
                                        .toString())));
                                String feels_like = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][5]['feels_like']
                                    ['day']
                                        .toString())));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['daily'][5]
                                      ['weather'][0]['description'];
                                  currentEpoch = weatherJSON['daily'][5]['dt'];
                                  currentWeatherIcon = weatherJSON['daily'][5]
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['daily'][5]['wind_speed'];
                                  humidity =
                                      weatherJSON['daily'][5]['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 5) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[5],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              Data.epochToDay(
                                                  weatherJSON['daily'][5]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              Data.epochToDate(
                                                  weatherJSON['daily'][5]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['daily'][5]['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          temperaturesOfWeek[5] +
                                              '\u00B0',
                                          style: TextStyle(
                                            color: Data.secondaryColor,
                                            fontSize: 37,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][6]['temp']['day']
                                        .toString())));
                                String feels_like = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][6]['feels_like']
                                    ['day']
                                        .toString())));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['daily'][6]
                                      ['weather'][0]['description'];
                                  currentEpoch = weatherJSON['daily'][6]['dt'];
                                  currentWeatherIcon = weatherJSON['daily'][6]
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['daily'][6]['wind_speed'];
                                  humidity =
                                      weatherJSON['daily'][6]['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 6) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[6],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              Data.epochToDay(
                                                  weatherJSON['daily'][6]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              Data.epochToDate(
                                                  weatherJSON['daily'][6]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['daily'][6]['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          temperaturesOfWeek[6] + '\u00B0',
                                          style: TextStyle(
                                            color: Data.secondaryColor,
                                            fontSize: 37,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String temp = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][7]['temp']['day']
                                        .toString())));
                                String feels_like = await Data.getUnit(Data.roundOff(double.parse(
                                    weatherJSON['daily'][7]['feels_like']
                                    ['day']
                                        .toString())));
                                setState(() {
                                  temperature = temp;
                                  feelsLike = feels_like;
                                  description = weatherJSON['daily'][7]
                                      ['weather'][0]['description'];
                                  currentEpoch = weatherJSON['daily'][7]['dt'];
                                  currentWeatherIcon = weatherJSON['daily'][7]
                                      ['weather'][0]['icon'];
                                  currentWindSpeed =
                                      weatherJSON['daily'][7]['wind_speed'];
                                  humidity =
                                      weatherJSON['daily'][7]['humidity'];
                                  for (int i = 0;
                                      i < forecastColors.length;
                                      i++) {
                                    if (i == 7) {
                                      forecastColors[i] = Data.primaryColor;
                                    } else {
                                      forecastColors[i] =
                                          Data.forecastBackgroundColor;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 130,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: forecastColors[7],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              Data.epochToDay(
                                                  weatherJSON['daily'][7]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              Data.epochToDate(
                                                  weatherJSON['daily'][7]
                                                      ['dt']),
                                              style: TextStyle(
                                                color: Data.secondaryColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'http://openweathermap.org/img/wn/${weatherJSON['daily'][7]['weather'][0]['icon']}@2x.png',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            temperaturesOfWeek[7] + '\u00B0',
                                            style: TextStyle(
                                              color: Data.secondaryColor,
                                              fontSize: 37,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
