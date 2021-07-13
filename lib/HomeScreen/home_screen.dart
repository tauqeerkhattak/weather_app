import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/CityWeather/city_weather.dart';

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
  var karachiMarker, lahoreMarker;
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
        mapType: MapType.normal,
        markers: markers,
        initialCameraPosition: _pakistan,
        onMapCreated: (GoogleMapController controller) {
          _completer.complete(controller);
          setState(() {
            markers.add(
              Marker(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CityWeather(cityName: 'Karachi');
                    }
                  ));
                },
                markerId: MarkerId('Karachi'),
                position: LatLng(24.838546248537753, 67.0031512662043),
                icon: karachiMarker,
              ),
            );
            markers.add(
              Marker(
                onTap: () {

                },
                markerId: MarkerId('Lahore'),
                position: LatLng(31.518601552187715, 74.35236129991766),
                icon: lahoreMarker,
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
