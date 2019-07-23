import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      applicationIcon: FlutterLogo(
        colors: Colors.red,
      ),
      icon: FlutterLogo(
        colors: Colors.red,
      ),
      aboutBoxChildren: <Widget>[
        const SizedBox(
          height: 10.0,
        ),
        Text(
          'Phát triển bởi team Data4U',
        ),
      ],
      applicationName: 'Thi Trắc Nghiệm',
      applicationVersion: 'Phiên bản 1.0.0',
      applicationLegalese: 'Apache License 2.0',
    );
  }
}
