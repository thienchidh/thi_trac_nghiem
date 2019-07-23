import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/account.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';
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
              return showDialog<bool>(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Đăng xuất'),
                    content: Text(
                      'Tài khoản \'${user
                          .name}\' sẽ được đăng xuất khỏi thiết bị này?',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          // set auto login = false
                          UserManagement().isUserLogout = true;

                          while (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          Navigator.pushReplacementNamed(
                            context,
                            '/${UIData.LOGIN_ROUTE_NAME}',
                          );
                        },
                      ),
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Divider(),
          AboutApp()
        ],
      ),
    );
  }
}
