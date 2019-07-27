import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class DialogUltis {
  Future<bool> showAlertDialog(
    BuildContext context, {
    String title = 'Xác nhận hành động',
    String content = 'Bạn chắc chứ?',
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(content),
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('Không'),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text('Có'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }

  Future<bool> showDialogLogout(BuildContext context) {
    return showDialog<bool>(
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
              child: Text('Yes'),
              onPressed: () {
                UserManagement().isAutoLogin = false;

                // TODO
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/${UIData.LOGIN_ROUTE_NAME}',
                      (_) => false,
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
  }
}
