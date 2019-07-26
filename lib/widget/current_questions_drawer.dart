import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class CurrentQuestionsDrawer extends StatelessWidget {
  final onSelectQuestionCallBack;

  final List<Question> questions;

  CurrentQuestionsDrawer(
      {@required this.questions, @required this.onSelectQuestionCallBack})
      : assert(questions != null),
        assert(onSelectQuestionCallBack != null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        itemCount: questions.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => onSelectQuestionCallBack(index),
            leading: CircleAvatar(
              child: Text('${index + 1}'),
              backgroundColor:
                  (questions[index].answerOfUser == Question.undefinedAnswer)
                      ? Colors.redAccent
                      : UIData.primarySwatch,
            ),
            title: Text(
              '${questions[index].content}',
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}
