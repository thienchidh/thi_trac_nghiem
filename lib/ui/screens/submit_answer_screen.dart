import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class SubmitScreen extends StatefulWidget {
  final void Function() onSubmit;

  const SubmitScreen({Key key, @required this.onSubmit}) : super(key: key);

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
            UIData.SUBMIT_EXAM,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => widget.onSubmit(),
        ),
      ),
    );
  }
}
