import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latLong;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screens/city_weather/city_weather.dart';
import 'package:weather_app/utils/assets.dart';
import 'package:weather_app/utils/constants.dart';

class MapController extends GetxController {
  RxBool isLoading = false.obs;
  List<Marker> markers = [];
  static final double markerHeight = 50;
  static final double markerWidth = 50;
  String cityName = '';
  String cityTemp = '';
  String cityWeatherType = '';
  bool isLocationSaved = false;

  @override
  void onInit() {
    super.onInit();
    setCustomMarkers();
    getSavedLocation();
  }

  Future<String> getCityName(double lat, double long) async {
    final placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks.first.name ?? 'Not found';
  }

  Future<void> getSavedLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('Latitude') != null) {
      double lat = double.parse(preferences.getString('Latitude').toString());
      double long = double.parse(preferences.getString('Longitude').toString());
      String tempCityName = await getCityName(lat, long);
      var json = await Constants.getWeatherData(lat: lat, long: long);
      cityName = tempCityName;
      cityWeatherType = json['current']['weather'][0]['main'];
      Constants.getUnit(Constants.roundOff(
              double.parse(json['current']['temp'].toString())))
          .then((value) {
        cityTemp = value;
      });
      isLocationSaved = true;
    } else {
      isLocationSaved = false;
    }
  }

  void setCustomMarkers() {
    markers = [
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(24.8815, 67.0139),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(lat: 24.8815, long: 67.0139)
                  .then((value) {
                isLoading.value = false;
                Get.to(
                  () => CityWeather(
                    cityName: 'Karachi',
                    weatherJSON: value,
                  ),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.karachi,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(34.1448298, 73.2142212),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                lat: 34.1448298,
                long: 73.2142212,
              ).then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Abbottabad',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.abbottabad,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(25.3801017, 68.3750376),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                lat: 25.3801017,
                long: 68.3750376,
              ).then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Hyderabad',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.hyderabad,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(31.422829353929913, 73.0927324843212),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                lat: 31.422829353929913,
                long: 73.0927324843212,
              ).then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Faisalabad',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.faisalabad,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(32.16018036171697, 74.18934124099547),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 32.16018036171697, long: 74.18934124099547)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Gujranwala',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.gujranwala,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(25.24720087407281, 62.283503450529786),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 25.24720087407281, long: 62.283503450529786)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Gwadar',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.gwadar,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(33.694807560471546, 73.04061223025087),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 33.694807560471546, long: 73.04061223025087)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Islamabad',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.islamabad,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(27.815109510613535, 66.60757835899655),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 27.815109510613535, long: 66.60757835899655)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Khuzdar',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.islamabad,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(33.58573468018176, 71.44454148778277),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 33.58573468018176, long: 71.44454148778277)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Kohat',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.kohat,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(31.519766435958818, 74.3551141291356),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 31.519766435958818, long: 74.3551141291356)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Lahore',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.lahore,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(34.19468490569706, 72.02515586593198),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 34.19468490569706, long: 72.02515586593198)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Mardan',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.mardan,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(30.188218598916613, 71.48565676532485),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 30.188218598916613, long: 71.48565676532485)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Multan',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.multan,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(34.013620839754324, 71.5201842585791),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 34.013620839754324, long: 71.5201842585791)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Peshawar',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.peshawar,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(30.18031408530992, 66.9747351561208),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 30.18031408530992, long: 66.9747351561208)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Quetta',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.quetta,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(26.04356493250303, 68.94760021146035),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 26.04356493250303, long: 68.94760021146035)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Sanghar',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.sanghar,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(27.723530595905487, 68.82266843352353),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 27.723530595905487, long: 68.82266843352353)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Sukkur',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.sukkur,
              ),
            ),
          );
        },
      ),
      Marker(
        height: markerHeight,
        width: markerWidth,
        point: latLong.LatLng(26.008317285055867, 63.03759333886163),
        builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              isLoading.value = true;
              Constants.getWeatherData(
                      lat: 26.008317285055867, long: 63.03759333886163)
                  .then((value) {
                isLoading.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Turbat',
                      weatherJSON: value,
                    );
                  }),
                );
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: Image.asset(
                Assets.turbat,
              ),
            ),
          );
        },
      ),
    ];
  }
}
