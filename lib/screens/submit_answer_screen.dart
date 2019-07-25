import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/model/enums.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';
import 'package:thi_trac_nghiem/screens/finished_screen.dart';

class SubmitScreen extends StatefulWidget {
  final List<Question> _data;
  final TypeExam _typeExam;

  SubmitScreen({@required data, @required typeExam})
      : assert(data != null),
        assert(typeExam != null),
        _data = data,
        _typeExam = typeExam;

  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
      width: double.infinity,
      child: Center(
        child: RaisedButton(
          padding: EdgeInsets.all(12.0),
          shape: StadiumBorder(),
          child: Text(
            'NỘP BÀI',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            final questions = widget._data;
            final typeExam = widget._typeExam;

            switch (typeExam) {
              case TypeExam.testTest:
                Navigator.pushNamed(context, FinishedScreen.nameRouter,
                    arguments: questions);

                break;

              case TypeExam.officialInspection:
              // server mark

              default:
                break;
            }

            // TODO
          },
        ),
      ),
    );
  }
}
