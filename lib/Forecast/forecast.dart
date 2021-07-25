import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class Forecast extends StatefulWidget {

  final String icon;
  final int epoch;
  final double temp;

  Forecast({
    required this.epoch,
    required this.icon,
    required this.temp,
  });

  @override
  _ForecastState createState() => _ForecastState(
    icon: this.icon,
    epoch: this.epoch,
    temp: this.temp,
  );
}

class _ForecastState extends State<Forecast> {

  final String icon;
  final int epoch;
  final double temp;

  _ForecastState({
    required this.epoch,
    required this.icon,
    required this.temp,
  });

  @override
  void initState() {
    print('Icon code: $icon');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                Data.epochToDay(epoch),
                style: TextStyle(
                  color: Data.secondaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: CachedNetworkImage(
                imageUrl: 'http://openweathermap.org/img/wn/$icon@2x.png',
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                alignment: Alignment.bottomCenter,
                child: Text(
                  Data.roundOff(widget.temp),
                  style: TextStyle(
                    color: Data.secondaryColor,
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}