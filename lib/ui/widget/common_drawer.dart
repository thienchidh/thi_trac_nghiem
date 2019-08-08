import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/ui/widget/about_tile.dart';
import 'package:thi_trac_nghiem/utils/dialog_ultis.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = UserManagement().curUser;
    final String code = user.userType == UserType.teacher
        ? UserManagement().curTeacherCode
        : user.maso;

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
              code,
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
              UIData.HOME,
              style: textStyle,
            ),
            leading: Icon(
              Icons.home,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.popUntil(
                context,
                ModalRoute.withName('/${UIData.HOME_ROUTE_NAME}'),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              UIData.LOGOUT,
              style: textStyle,
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.redAccent,
            ),
            onTap: () {
              return DialogUltis().confirmLogout(context);
            },
          ),
          Divider(),
          AboutApp()
        ],
      ),
    );
  }
}
