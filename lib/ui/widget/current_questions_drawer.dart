import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class CurrentQuestionsDrawer extends StatelessWidget {
  final Function onSelectQuestionCallBack;
  final Function onSubmitCallback;

  final List<Question> questions;

  CurrentQuestionsDrawer(
      {@required this.questions,
      @required this.onSelectQuestionCallBack,
      @required this.onSubmitCallback})
      : assert(questions != null),
        assert(onSelectQuestionCallBack != null),
        assert(onSubmitCallback != null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        itemCount: questions.length + 1,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          if (index == questions.length) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    shape: const StadiumBorder(),
                    child: Text(
                      'NỘP BÀI',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // TODO confirm ,...
                      onSubmitCallback();
                    },
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    padding: const EdgeInsets.all(12.0),
                    shape: const StadiumBorder(),
                    child: Text(
                      'Random',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      final random = Random();
                      for (final question in questions) {
                        if (question.answerOfUser == Question.undefinedAnswer) {
                          final listDapAn = question.listDapAn;
                          question.answerOfUser =
                              listDapAn[random.nextInt(listDapAn.length)];
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          }

          final question = questions[index];
          return Tooltip(
            message: question.content,
            child: ListTile(
              onTap: () => onSelectQuestionCallBack(index),
              leading: CircleAvatar(
                child: Text('${index + 1}'),
                backgroundColor:
                    (question.answerOfUser == Question.undefinedAnswer)
                        ? Colors.redAccent
                        : UIData.primarySwatch,
              ),
              title: Text(
                '${question.content}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
