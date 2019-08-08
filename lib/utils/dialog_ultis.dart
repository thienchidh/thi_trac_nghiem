import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class DialogUltis {
  Future<bool> showAlertDialog(
    BuildContext context, {
        String title = 'Xác nhận thoát?',
        String content = 'Bạn có muốn thoát?',
      }) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(content),
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text(UIData.YES),
              onPressed: () {
                return Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text(UIData.NO),
              onPressed: () {
                return Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> confirmLogout(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) {
        final user = UserManagement().curUser;
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: Text(
            'Tài khoản \'${user.name}\' sẽ được đăng xuất khỏi thiết bị này?',
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(UIData.YES),
              onPressed: () {
                UserManagement().logout(context);
              },
            ),
            FlatButton(
              child: Text(UIData.NO),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
