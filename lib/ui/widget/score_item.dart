import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/convert_question.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class ScoreItem extends StatelessWidget {
  final ExamQuestions item;

  const ScoreItem({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(item.hoTen),
      subtitle: Text(
        item.diem,
      ),
      trailing: Text(item.mssv),
      onTap: () {
        ConvertQuestion().convertAnswerToDest(item);

        Navigator.pushNamed(context, '/${UIData.FINISHED_ROUTE_NAME}',
            arguments: item.listCauHoiDetails);
      },
    );
  }
}
