import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/ui/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UIData.ABOUT_US),
      ),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  UIData.APP_NAME,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                UIData.VERSION_APP,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(
                'Phát triển bởi Team Data4U',
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(
                'Liên hệ: ailabteam2018@gmail.com',
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: RaisedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/${UIData.HOME_ROUTE_NAME}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
