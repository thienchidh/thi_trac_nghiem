import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/utils/dialog_ultis.dart';
import 'package:thi_trac_nghiem/widget/about_tile.dart';

class CommonDrawer extends StatelessWidget {
  final User user = UserManagement().curUser;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0);

    final list = user.name.split(' ');
    final firstCharacterName = list.isNotEmpty ? list.last[0] : '';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user.name,
            ),
            accountEmail: Text(
              user.maso,
            ),
            currentAccountPicture: CircleAvatar(
              child: Text(
                firstCharacterName,
                style: textStyle,
              ),
            ),
            onDetailsPressed: () {
              print('CommonDrawer.build.onDetailsPressed');
            },
          ),
          ListTile(
            title: Text(
              'Profile',
              style: textStyle,
            ),
            leading: Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text(
              'Timeline',
              style: textStyle,
            ),
            leading: Icon(
              Icons.timeline,
              color: Colors.cyan,
            ),
          ),
          ListTile(
            title: Text(
              'Settings',
              style: textStyle,
            ),
            leading: Icon(
              Icons.settings,
              color: Colors.brown,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Logout',
              style: textStyle,
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.redAccent,
            ),
            onTap: () {
              return DialogUltis().showDialogLogout(context);
            },
          ),
          Divider(),
          AboutApp()
        ],
      ),
    );
  }
}
