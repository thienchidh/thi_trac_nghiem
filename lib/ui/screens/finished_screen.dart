import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class FinishedScreen extends StatelessWidget {
  FinishedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Question> questions = ModalRoute
        .of(context)
        .settings
        .arguments;
    assert(questions != null);

    int numCorrectAnswer =
        questions
            .where((q) => q.dapAnDung == q.answerOfUser)
            .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ModalRoute
              .of(context)
              .settings
              .name
              .substring(1),
        ),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: UIData.kitGradients,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildCard(UIData.NUM_OF_QUESTION, '${questions.length}'),
              const SizedBox(height: 10.0),
              _buildCard(
                  UIData.SCORE, '${numCorrectAnswer / questions.length * 10}'),
              const SizedBox(height: 10.0),
              _buildCard(UIData.NUM_OF_CORRECT,
                  '$numCorrectAnswer/${questions.length}'),
              const SizedBox(height: 10.0),
              _buildCard(UIData.NUM_OF_WRONG,
                  '${questions.length - numCorrectAnswer}/${questions.length}'),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: UIData.accentColor,
                    child: Text(UIData.BACK),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: UIData.primaryColor,
                    child: Text('Xem đáp án'),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/${UIData.CHECK_ANSWER_ROUTE_NAME}',
                          arguments: questions);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildCard(String title, String trailing) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(title, style: _titleStyle),
      trailing: Text(trailing, style: _trailingStyle),
    ),
  );
}

const TextStyle _titleStyle = TextStyle(
  color: Colors.black87,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);
const TextStyle _trailingStyle = TextStyle(
  color: UIData.primaryColor,
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);
