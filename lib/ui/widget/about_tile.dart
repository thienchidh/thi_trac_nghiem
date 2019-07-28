import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

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
      applicationName: '${UIData.APP_NAME}',
      applicationVersion: 'Phiên bản ${UIData.VERSION_APP}',
      applicationLegalese: 'Apache License 2.0',
    );
  }
}
