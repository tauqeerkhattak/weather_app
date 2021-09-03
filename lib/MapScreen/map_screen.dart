import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocode/geocode.dart';
import 'package:latlong2/latlong.dart' as latLong;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/About/about.dart';
import 'package:weather_app/CityWeather/city_weather.dart';
import 'package:weather_app/Unit/change_unit.dart';
import 'package:weather_app/data.dart';

class MapScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.70,
          color: Data.primaryColor,
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Center(
                  child: Text(
                    'Weather App',
                    style: TextStyle(
                      color: Data.secondaryColor,
                      fontSize: 30,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: Divider(
                  color: Data.secondaryColor,
                  thickness: 1.5,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChangeUnit();
                    }));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Icon(
                            Icons.settings,
                            color: Data.secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Center(
                          child: Text(
                            'Temperature Unit',
                            style: TextStyle(
                              color: Data.secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return About();
                        }
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Icon(
                            Icons.info_outline,
                            color: Data.secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Center(
                          child: Text(
                            'About App',
                            style: TextStyle(
                              color: Data.secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: MapScreenBody(),
    );
  }
}

class MapScreenBody extends StatefulWidget {
  const MapScreenBody({Key? key}) : super(key: key);

  @override
  _MapScreenBodyState createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<MapScreenBody> {

  bool isLoading = false;
  List<Marker> markers = [];
  static final double markerHeight = 50;
  static final double markerWidth = 50;
  String cityName = '';
  String cityTemp = '';
  String cityWeatherType = '';
  bool isLocationSaved = false;

  Future<String> getCityName(double lat, double long) async {
    GeoCode geoCode = GeoCode();
    Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: long);
    return address.city.toString();
  }

  Future<void> getSavedLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('Latitude') != null) {
      double lat = double.parse(preferences.getString('Latitude').toString());
      double long = double.parse(preferences.getString('Longitude').toString());
      String tempCityName = await getCityName(lat, long);
      var json = await Data.getWeatherData(lat: lat, long: long);
      setState(() {
        cityName = tempCityName;
        cityWeatherType = json['current']['weather'][0]['main'];
        Data.getUnit(
                Data.roundOff(double.parse(json['current']['temp'].toString())))
            .then((value) {
          cityTemp = value;
        });
        isLocationSaved = true;
      });
    } else {
      setState(() {
        isLocationSaved = false;
      });
    }
  }

  @override
  void initState() {
    setCustomMarkers();
    getSavedLocation();
    print('ADDED MARKERS: ${markers.length}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: LoadingOverlay(
        isLoading: isLoading,
        color: Data.primaryColor,
        progressIndicator: Container(
          child: Center(
            child: Image.asset('images/loading.gif'),
          ),
        ),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                allowPanning: false,
                nePanBoundary:
                    latLong.LatLng(35.82102525343907, 80.08616797277499),
                swPanBoundary:
                    latLong.LatLng(25.262804710618266, 61.69346830399224),
                center: latLong.LatLng(29.98743291600722, 69.18838056609695),
                zoom: 6.5,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://c.tiles.wmflabs.org/osm-no-labels/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: markers,
                ),
              ],
            ),
            SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Colors.transparent,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        (isLocationSaved)
                            ? cityName + '   $cityTemp\u00b0'
                            : '',
                        textStyle: TextStyle(
                          color: Data.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      FadeAnimatedText(
                        (isLocationSaved)?'Click Here for Location weather':'',
                        textStyle: TextStyle(
                          color: Data.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                    onTap: () async {
                      var status = await Permission.location.request();
                      if (status.isGranted) {
                        setState(() {
                          isLoading = true;
                        });
                        LocationData _locationData;
                        Location _location = new Location();
                        SharedPreferences storage =
                        await SharedPreferences.getInstance();
                        if (await _location.serviceEnabled()) {
                          _locationData = await _location.getLocation();
                          String latitude = _locationData.latitude.toString();
                          String longitude = _locationData.longitude.toString();
                          storage.setString(
                              'Latitude', _locationData.latitude.toString());
                          storage.setString(
                              'Longitude', _locationData.longitude.toString());
                          String locationName = await getCityName(
                              double.parse(latitude), double.parse(longitude));
                          Data.getWeatherData(
                              lat: double.parse(latitude),
                              long: double.parse(longitude))
                              .then((value) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return CityWeather(
                                    cityName: locationName,
                                    weatherJSON: value,
                                  );
                                })).then((newValue) async {
                              String temp = await Data.getUnit(Data.roundOff(
                                  double.parse(
                                      value['current']['temp'].toString())));
                              setState(() {
                                cityName = locationName;
                                cityTemp = temp;
                              });
                            });
                            setState(() {
                              isLoading = false;
                            });
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Location access!',
                                  style: TextStyle(
                                    color: Data.primaryColor,
                                  ),
                                ),
                                content: Text(
                                  'Please turn on your location!',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(
                                        color: Data.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Permission Denied!',
                                style: TextStyle(
                                  color: Data.primaryColor,
                                ),
                              ),
                              content: Text(
                                  'We need this permission to show current location weather.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(
                                      color: Data.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    repeatForever: true,
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.dehaze,
                      color: Data.primaryColor,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
            ),
            if (!isLocationSaved)
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(
                  bottom: 15,
                  right: 15,
                ),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  backgroundColor: Data.primaryColor,
                  onPressed: () async {
                    var status = await Permission.location.request();
                    if (status.isGranted) {
                      setState(() {
                        isLoading = true;
                      });
                      LocationData _locationData;
                      Location _location = new Location();
                      SharedPreferences storage =
                          await SharedPreferences.getInstance();
                      if (await _location.serviceEnabled()) {
                        _locationData = await _location.getLocation();
                        String latitude = _locationData.latitude.toString();
                        String longitude = _locationData.longitude.toString();
                        storage.setString(
                            'Latitude', _locationData.latitude.toString());
                        storage.setString(
                            'Longitude', _locationData.longitude.toString());
                        String locationName = await getCityName(
                            double.parse(latitude), double.parse(longitude));
                        Data.getWeatherData(
                                lat: double.parse(latitude),
                                long: double.parse(longitude))
                            .then((value) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return CityWeather(
                              cityName: locationName,
                              weatherJSON: value,
                            );
                          })).then((newValue) {
                            setState(() {
                              isLocationSaved = true;
                              cityName = locationName;
                              Data.getUnit(Data.roundOff(double.parse(value['current']['temp'].toString()))).then((value) {
                                setState(() {
                                  cityTemp = value;
                                });
                              });
                            });
                          });
                          setState(() {
                            isLoading = false;
                          });
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Location access!',
                                style: TextStyle(
                                  color: Data.primaryColor,
                                ),
                              ),
                              content: Text(
                                'Please turn on your location!',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Okay',
                                    style: TextStyle(
                                      color: Data.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Permission Denied!',
                              style: TextStyle(
                                color: Data.primaryColor,
                              ),
                            ),
                            content: Text(
                                'We need this permission to show current location weather.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Okay',
                                  style: TextStyle(
                                    color: Data.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 24.8815, long:  67.0139)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CityWeather(
                      cityName: 'Karachi',
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
                'images/karachi.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                lat: 34.1448298,
                long: 73.2142212,
              ).then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/abbottabad.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                lat: 25.3801017,
                long: 68.3750376,
              ).then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/hyderabad.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                lat: 31.422829353929913,
                long: 73.0927324843212,
              ).then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/faisalabad.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 32.16018036171697, long: 74.18934124099547)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/gujranwala.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 25.24720087407281, long: 62.283503450529786)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/gwadar.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 33.694807560471546, long: 73.04061223025087)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/islamabad.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 27.815109510613535, long: 66.60757835899655)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/khuzdar.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 33.58573468018176, long: 71.44454148778277)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/kohat.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 31.519766435958818, long: 74.3551141291356)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/lahore.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 34.19468490569706, long: 72.02515586593198)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/mardan.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 30.188218598916613, long: 71.48565676532485)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/multan.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 34.013620839754324, long: 71.5201842585791)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/peshawar.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 30.18031408530992, long: 66.9747351561208)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/quetta.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 26.04356493250303, long: 68.94760021146035)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/sanghar.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 27.723530595905487, long: 68.82266843352353)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/sukkur.png',
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
              setState(() {
                isLoading = true;
              });
              Data.getWeatherData(
                      lat: 26.008317285055867, long: 63.03759333886163)
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
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
                'images/turbat.png',
              ),
            ),
          );
        },
      ),
    ];
  }
}
