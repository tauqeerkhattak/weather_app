import 'package:about/about.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AboutPage(
        title: Text('about Weather App'),
        values: {
          'version': '1.0.0',
          'buildNumber': '1',
          'year': '2021',
          'author': 'Tauqeer Ahmed',
        },
      ),
    );
  }
}
