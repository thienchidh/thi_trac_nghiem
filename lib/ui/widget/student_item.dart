import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  final int index;

  const StudentItem({Key key, @required this.student, @required this.index})
      : assert(student != null),
        assert(index != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(
        '${student.name}',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${student.maso}',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${student.email}',
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        UserManagement().curUser.maso = student.maso;
        Navigator.pushNamed(context, '/${UIData.LIST_EXAM_STUDENT_ROUTE_NAME}');
      },
    );
  }
}
