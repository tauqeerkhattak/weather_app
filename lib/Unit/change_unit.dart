import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/MapScreen/map_screen.dart';
import 'package:weather_app/data.dart';

class ChangeUnit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Temperature Unit'),
        centerTitle: true,
        backgroundColor: Data.primaryColor,
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

enum Units {Celsius,Fahrenheit}

class _ChangeUnitBodyState extends State<ChangeUnitBody> {

  Units? unit;

  Future <void> setUnit () async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('Unit') != null) {
      if (preferences.getString('Unit') == 'Celsius') {
        setState(() {
          unit = Units.Celsius;
        });
      }
      else if (preferences.getString('Unit') == 'Fahrenheit') {
        setState(() {
          unit = Units.Fahrenheit;
        });
      }
    }
    else {
      preferences.setString('Unit', 'Celsius');
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
                  color: Data.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Data.primaryColor),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (unit == Units.Celsius) {
                  prefs.setString('Unit', 'Celsius');
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
                    return MapScreen();
                  },), (route) => false);
                }
                else {
                  prefs.setString('Unit', 'Fahrenheit');
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) {
                    return MapScreen();
                  },), (route) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
