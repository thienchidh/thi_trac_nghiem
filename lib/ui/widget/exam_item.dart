import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/convert_question.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class ExamItem extends StatelessWidget {
  final ExamQuestions item;

  const ExamItem({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(item.diem),
      ),
      title: Text(item.hoTen),
      subtitle: Text(
        item.baiThi,
      ),
      trailing: Text('${item.status}'),
      onTap: () async {
        ConvertQuestion().convertAnswerToDest(item);

        if (UserManagement().curUser.userType == UserType.teacher) {
          Navigator.pushNamed(
            context,
            '/${UIData.FINISHED_ROUTE_NAME}',
            arguments: item.listCauHoiDetails,
          );
          return;
        }

        if (UserManagement().curExamDoing != null &&
            UserManagement().curExamDoing.status == Exam.RUNNING) {
          return;
        }

        if (item.status == Exam.FINISHED) {
          Navigator.pushNamed(
            context,
            '/${UIData.FINISHED_ROUTE_NAME}',
            arguments: item.listCauHoiDetails,
          );
        }
      },
    );
  }
}
