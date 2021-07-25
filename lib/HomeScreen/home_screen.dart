import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/CityWeather/city_weather.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../data.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  var karachiMarker,
      lahoreMarker,
      islamabadMarker,
      peshawarMarker,
      quettaMarker;
  Set<Marker> markers = {};
  Completer<GoogleMapController> _completer = Completer();
  static final CameraPosition _pakistan = CameraPosition(
    target: LatLng(30.016368178657462, 68.64587475396765),
    zoom: 7,
  );

  Future<void> setCustomMarker() async {
    karachiMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/karachi.png',
    );
    lahoreMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/lahore.png',
    );
    islamabadMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/islamabad.png',
    );
    peshawarMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/peshawar.png',
    );
    quettaMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/quetta.png',
    );
  }

  @override
  void initState() {
    setCustomMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GoogleMap(
        markers: markers,
        initialCameraPosition: _pakistan,
        onMapCreated: (GoogleMapController controller) {
          _completer.complete(controller);
          rootBundle.loadString('assets/my_map_style.json').then((String mapStyle) {
            setState(() {
              controller.setMapStyle(mapStyle);
            });
          });
          setState(() {
            markers.add(
              Marker(
                onTap: () async {
                  await Data.getWeatherData(
                          lat: 24.858408078667665, long: 67.01417382670522)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return CityWeather(
                        cityName: 'Karachi',
                        weatherJSON: value,
                      );
                    }));
                  });
                },
                markerId: MarkerId('Karachi'),
                position: LatLng(24.838546248537753, 67.0031512662043),
                icon: karachiMarker,
              ),
            );
            markers.add(
              Marker(
                onTap: () async {
                  await Data.getWeatherData(
                          lat: 31.545748918925582, long: 74.34000818566564)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return CityWeather(
                        cityName: 'Lahore',
                        weatherJSON: value,
                      );
                    }));
                  });
                },
                markerId: MarkerId('Lahore'),
                position: LatLng(31.518601552187715, 74.35236129991766),
                icon: lahoreMarker,
              ),
            );
            markers.add(
              Marker(
                onTap: () async {
                  await Data.getWeatherData(
                          lat: 33.69071660532525, long: 73.05021340905674)
                      .then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CityWeather(
                            cityName: 'Islamabad', weatherJSON: value);
                      }),
                    );
                  });
                },
                markerId: MarkerId('Islamabad'),
                position: LatLng(33.69071660532525, 73.05021340905674),
                icon: islamabadMarker,
              ),
            );
            markers.add(
              Marker(
                onTap: () async {
                  await Data.getWeatherData(
                          lat: 34.0153017944768, long: 71.51145050554678)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return CityWeather(
                        cityName: 'Peshawar',
                        weatherJSON: value,
                      );
                    }));
                  });
                },
                markerId: MarkerId('Peshawar'),
                position: LatLng(34.0153017944768, 71.51145050554678),
                icon: peshawarMarker,
              ),
            );
            markers.add(
              Marker(
                onTap: () async {
                  await Data.getWeatherData(
                    lat: 30.179700468412477,
                    long: 66.97464179417648,
                  ).then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return CityWeather(
                              cityName: 'Quetta', weatherJSON: value);
                        },
                      ),
                    );
                  });
                },
                position: LatLng(
                  30.179700468412477,
                  66.97464179417648,
                ),
                markerId: MarkerId('Quetta'),
                icon: quettaMarker,
              ),
            );
          });
        },
        cameraTargetBounds: CameraTargetBounds(
          new LatLngBounds(
            southwest: LatLng(25.311241984927452, 61.62964321609874),
            northeast: LatLng(34.27481354756063, 76.35312132646213),
          ),
        ),
      ),
    );
  }
}
