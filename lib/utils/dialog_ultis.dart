import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
}
