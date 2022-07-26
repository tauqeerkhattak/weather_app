import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/controllers/map_controller.dart';
import 'package:weather_app/screens/city_weather/city_weather.dart';
import 'package:weather_app/utils/assets.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/widgets/custom_drawer.dart';

class MapScreen extends StatelessWidget {
  final controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: AnimatedTextKit(
          animatedTexts: [
            FadeAnimatedText(
              (controller.isLocationSaved)
                  ? controller.cityName + '   ${controller.cityTemp}\u00b0'
                  : '',
              textStyle: TextStyle(
                color: Constants.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            FadeAnimatedText(
              (controller.isLocationSaved)
                  ? 'Click Here for Location weather'
                  : '',
              textStyle: TextStyle(
                color: Constants.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
          onTap: () async {
            var status = await Permission.location.request();
            if (status.isGranted) {
              controller.isLoading.value = true;
              LocationData _locationData;
              Location _location = new Location();
              SharedPreferences storage = await SharedPreferences.getInstance();
              if (await _location.serviceEnabled()) {
                _locationData = await _location.getLocation();
                String latitude = _locationData.latitude.toString();
                String longitude = _locationData.longitude.toString();
                storage.setString(
                    'Latitude', _locationData.latitude.toString());
                storage.setString(
                    'Longitude', _locationData.longitude.toString());
                String locationName = await controller.getCityName(
                    double.parse(latitude), double.parse(longitude));
                Constants.getWeatherData(
                        lat: double.parse(latitude),
                        long: double.parse(longitude))
                    .then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return CityWeather(
                          cityName: locationName,
                          weatherJSON: value,
                        );
                      },
                    ),
                  ).then((newValue) async {
                    String temp = await Constants.getUnit(Constants.roundOff(
                        double.parse(value['current']['temp'].toString())));
                    controller.cityName = locationName;
                    controller.cityTemp = temp;
                  });
                  controller.isLoading.value = false;
                });
              } else {
                controller.isLoading.value = false;

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Location access!',
                        style: TextStyle(
                          color: Constants.primaryColor,
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
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              controller.isLoading.value = false;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Permission Denied!',
                      style: TextStyle(
                        color: Constants.primaryColor,
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
                            color: Constants.primaryColor,
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.dehaze,
                color: Constants.primaryColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        centerTitle: true,
      ),
      floatingActionButton: !controller.isLocationSaved
          ? FloatingActionButton(
              child: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              backgroundColor: Constants.primaryColor,
              onPressed: () async {
                var status = await Permission.location.request();
                if (status.isGranted) {
                  controller.isLoading.value = true;
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
                    String locationName = await controller.getCityName(
                        double.parse(latitude), double.parse(longitude));
                    Constants.getWeatherData(
                            lat: double.parse(latitude),
                            long: double.parse(longitude))
                        .then((value) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CityWeather(
                          cityName: locationName,
                          weatherJSON: value,
                        );
                      })).then((newValue) {
                        controller.isLocationSaved = true;
                        controller.cityName = locationName;
                        Constants.getUnit(Constants.roundOff(double.parse(
                                value['current']['temp'].toString())))
                            .then((value) {
                          controller.cityTemp = value;
                        });
                      });
                    });
                    controller.isLoading.value = false;
                  } else {
                    controller.isLoading.value = false;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Location access!',
                            style: TextStyle(
                              color: Constants.primaryColor,
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
                                  color: Constants.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  controller.isLoading.value = false;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Permission Denied!',
                          style: TextStyle(
                            color: Constants.primaryColor,
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
                                color: Constants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            )
          : null,
      body: Container(
        height: Get.height,
        width: Get.width,
        child: LoadingOverlay(
          isLoading: controller.isLoading.value,
          color: Constants.primaryColor,
          progressIndicator: Container(
            child: Center(
              child: Image.asset(
                Assets.loading,
              ),
            ),
          ),
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  allowPanning: false,
                  nePanBoundary: Constants.northEastBound,
                  swPanBoundary: Constants.southWestBount,
                  center: Constants.center,
                  zoom: 6.5,
                ),
                layers: [
                  // TileLayerOptions(
                  //   urlTemplate:
                  //       'https://c.tiles.wmflabs.org/osm-no-labels/{z}/{x}/{y}.png',
                  //   subdomains: ['a', 'b', 'c'],
                  // ),
                  MarkerLayerOptions(
                    markers: controller.markers,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
