import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class ClassItem extends StatelessWidget {
  final String item;

  const ClassItem({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        item,
      ),
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            child: Icon(
              Icons.check,
            ),
          ),
          title: Text(
            'Danh sách sinh viên của lớp $item',
            overflow: TextOverflow.ellipsis,
            style: _textStyle,
          ),
          onTap: () {
            UserManagement().curUser.lop = item;
            Navigator.pushNamed(context, '/${UIData.LIST_STUDENT_ROUTE_NAME}');
          },
        ),
        ListTile(
          leading: CircleAvatar(
            child: Icon(
              Icons.check,
            ),
          ),
          title: Text(
            '${UIData.LIST_EXAM} của lớp $item',
            overflow: TextOverflow.ellipsis,
            style: _textStyle,
          ),
          onTap: () {
            UserManagement().curUser.lop = item;
            Navigator.pushNamed(context, '/${UIData.LIST_EXAM_ROUTE_NAME}');
          },
        ),
      ],
    );
  }
}

final _textStyle = TextStyle(
  fontSize: 14.0,
);
