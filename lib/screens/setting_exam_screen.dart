import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thi_trac_nghiem/widget/common_drawer.dart';

class SettingExamScreen extends StatefulWidget {
  @override
  _SettingExamScreenState createState() => _SettingExamScreenState();
}

class _SettingExamScreenState extends State<SettingExamScreen> {
  static const textSetting = TextStyle(
    fontWeight: FontWeight.bold,
  );

  final DateTime _timeNow;
  final DateFormat _formatter;

  DateTime _startTime;
  var _dropdownValue;
  var _list = ['One', 'Two', 'Free', 'Four'];

  double _numOfQuestion;
  bool _isLoading;

  void _setValue(double x) =>
      setState(() => _numOfQuestion = x.floorToDouble());

  _SettingExamScreenState()
      : _timeNow = DateTime.now(),
        _formatter = DateFormat('dd-MM-yyyy hh:mm aaa') {
    _startTime = _timeNow;
    _numOfQuestion = 60;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Tên bài thi:'),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Nhập tên bài thi',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Lớp:'),
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      },
                      items: _list.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Thời gian bắt đầu:'),
                  ),
                  Text(
                    _formatter.format(_startTime),
                    style: textSetting,
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    child: Icon(
                      Icons.timer,
                    ),
                    onTap: () async {
                      final dateTimeSelected = await _onDatePicker();
                      setState(() => _startTime = dateTimeSelected);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Số phút làm bài:'),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      initialValue: '61',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              RaisedButton(
                onPressed: _completeSetup,
                child: Text('Xong'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _completeSetup() {
    print('_SettingExamScreenState._completeSetup');
  }

  Future<DateTime> _onDatePicker() async {
    final datePicker = await showDatePicker(
      context: context,
      initialDate: _timeNow,
      firstDate: _timeNow,
      lastDate: DateTime(_timeNow.year, _timeNow.month + 6),
    );

    if (datePicker == null) {
      return _timeNow;
    }

    final curTime = TimeOfDay.now();
    final timePicker = await showTimePicker(
      context: context,
      initialTime: curTime,
    );

    if (timePicker == null) {
      return _timeNow;
    }

    final year = datePicker.year;
    final month = datePicker.month;
    final day = datePicker.day;
    final hour = timePicker.hour;
    final minute = timePicker.minute;

    return DateTime(year, month, day, hour, minute);
  }
}
