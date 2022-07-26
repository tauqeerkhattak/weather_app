import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/screens/About/about.dart';
import 'package:weather_app/screens/Unit/change_unit.dart';
import 'package:weather_app/utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width * 0.70,
        color: Constants.primaryColor,
        child: ListView(
          children: [
            Container(
              width: Get.width * 0.70,
              height: Get.height * 0.25,
              child: Center(
                child: Text(
                  'Weather App',
                  style: TextStyle(
                    color: Constants.secondaryColor,
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
                color: Constants.secondaryColor,
                thickness: 1.5,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: InkWell(
                onTap: () {
                  Get.to(() => ChangeUnit());
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(
                          Icons.settings,
                          color: Constants.secondaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Center(
                        child: Text(
                          'Temperature unit',
                          style: TextStyle(
                            color: Constants.secondaryColor,
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
                  Get.to(() => About());
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Icon(
                          Icons.info_outline,
                          color: Constants.secondaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Center(
                        child: Text(
                          'about App',
                          style: TextStyle(
                            color: Constants.secondaryColor,
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
    );
  }
}