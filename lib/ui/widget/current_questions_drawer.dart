import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/utils/dialog_ultis.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class CurrentQuestionsDrawer extends StatelessWidget {
  final void Function(int index) onSelectItem;
  final void Function() onSubmit;
  final void Function() onRandom;

  final List<Question> items;

  CurrentQuestionsDrawer({@required this.items,
    @required this.onSelectItem,
    @required this.onSubmit,
    @required this.onRandom})
      : assert(items != null),
        assert(onSelectItem != null),
        assert(onSubmit != null),
        assert(onRandom != null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        itemCount: items.length + 1,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          if (index == items.length) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: RaisedButton(
                      padding: EdgeInsets.all(12.0),
                      shape: const StadiumBorder(),
                      child: Text(
                        UIData.SUBMIT_EXAM,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        onSubmit();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Tooltip(
                      child: RaisedButton(
                        padding: const EdgeInsets.all(12.0),
                        shape: const StadiumBorder(),
                        child: Text(
                          'Random',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          bool isAccept = await DialogUltis().showAlertDialog(
                            context,
                            title: UIData.CONFIRM,
                            content: UIData.RANDOM_DIALOG_TEXT,
                          );

                          if (isAccept ??= false) {
                            onRandom();
                          }
                        },
                      ),
                      message: 'Chọn ngẫu nhiên những đáp án chưa trả lời',
                    ),
                  ),
                ),
              ],
            );
          }

          final question = items[index];
          return Tooltip(
            message: question.content,
            child: ListTile(
              onTap: () => onSelectItem(index),
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
