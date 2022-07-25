import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screens/map_screen/map_screen.dart';
import 'package:weather_app/utils/constants.dart';

class ChangeUnit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Temperature unit'),
        centerTitle: true,
        backgroundColor: Constants.primaryColor,
      ),
      body: ChangeUnitBody(),
    );
  }
}

class ChangeUnitBody extends StatefulWidget {
  const ChangeUnitBody({Key? key}) : super(key: key);

  @override
  _ChangeUnitBodyState createState() => _ChangeUnitBodyState();
}

enum Units { Celsius, Fahrenheit }

class _ChangeUnitBodyState extends State<ChangeUnitBody> {
  Units? unit;

  Future<void> setUnit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('unit') != null) {
      if (preferences.getString('unit') == 'Celsius') {
        setState(() {
          unit = Units.Celsius;
        });
      } else if (preferences.getString('unit') == 'Fahrenheit') {
        setState(() {
          unit = Units.Fahrenheit;
        });
      }
    } else {
      preferences.setString('unit', 'Celsius');
      setState(() {
        unit = Units.Celsius;
      });
    }
  }

  @override
  void initState() {
    setUnit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RadioListTile(
            title: Text('Celsius'),
            value: Units.Celsius,
            groupValue: unit,
            onChanged: (Units? unit) {
              setState(() {
                this.unit = unit;
              });
            },
          ),
          RadioListTile(
            title: Text('Fahrenheit'),
            value: Units.Fahrenheit,
            groupValue: unit,
            onChanged: (Units? unit) {
              setState(() {
                this.unit = unit;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Constants.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Constants.primaryColor),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (unit == Units.Celsius) {
                  prefs.setString('unit', 'Celsius');
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MapScreen();
                    },
                  ), (route) => false);
                } else {
                  prefs.setString('unit', 'Fahrenheit');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return MapScreen();
                      },
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
