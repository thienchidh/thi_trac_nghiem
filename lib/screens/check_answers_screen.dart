import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class CheckAnswersScreen extends StatelessWidget {
  final List<Question> questions;

  const CheckAnswersScreen({
    Key key,
    @required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đáp án'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: UIData.primaryColor),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return RaisedButton(
        child: Text('Xong'),
        onPressed: () {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
        },
      );
    }
    Question question = questions[index];
    bool correct = question.dapAnDung == question.answerOfUser;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question.content,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              question.dapAnDung,
              style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Đáp án: '),
                        TextSpan(
                          text: question.dapAnDung,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
