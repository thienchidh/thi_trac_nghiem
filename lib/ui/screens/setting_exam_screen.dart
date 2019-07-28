import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/class_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/api/post/post_exam_schedule.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_schedule.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/ui/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';
import 'package:toast/toast.dart';

class SettingExamScreen extends StatefulWidget {
  @override
  _SettingExamScreenState createState() => _SettingExamScreenState();
}

class _SettingExamScreenState extends State<SettingExamScreen> {
  final DateTime _timeNow;

  DateTime timeStart;
  String curClass;
  List<String> listClass;

  bool isLoading = true;

  DataSource<String> _dataSource;

  final nameOfExamController = TextEditingController();

  final numOfMinutesDoingController =
      TextEditingController(text: _MINUTES_DEFAULT_STR);

  _SettingExamScreenState()
      : _timeNow = DateTime.now().add(Duration(minutes: 30)),
        _dataSource = ClassDataSource() {
    listClass = [];
    timeStart = _timeNow;
    isLoading = false;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _dataSource.getData(isFirstLoading: true).then((List<String> result) {
      setState(() {
        listClass = result..sort();
        curClass = listClass.first;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: LoadMoreItem(
          isVisible: true,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                buildRowNameExam(),
                SizedBox(height: 10.0),
                buildRowClass(),
                SizedBox(height: 10.0),
                buildRowTimeStart(),
                SizedBox(height: 10.0),
                buildRowNumMinutes(),
                SizedBox(height: 25.0),
                Divider(),
                RaisedButton(
                  onPressed: completeSetup,
                  child: Text('Xong'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildRowNameExam() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Tên bài thi:'),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: nameOfExamController,
            decoration: InputDecoration(
              hintText: 'Nhập tên bài thi',
            ),
            validator: _validateForm,
          ),
        ),
      ],
    );
  }

  Row buildRowTimeStart() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Thời gian bắt đầu:'),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: InkWell(
            onTap: () async {
              final dateTimeSelected = await _onDatePicker();
              setState(() => timeStart = dateTimeSelected);
            },
            child: Row(
              children: <Widget>[
                Text(
                  localDateFormat.format(timeStart),
                  overflow: TextOverflow.ellipsis,
                  style: _textSetting,
                ),
                SizedBox(width: 10.0),
                Icon(Icons.today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row buildRowClass() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Lớp:'),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: DropdownButton<String>(
            value: curClass,
            onChanged: (String value) {
              setState(() {
                curClass = value;
              });
            },
            items: listClass.map<DropdownMenuItem<String>>(
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
    );
  }

  Widget buildRowNumMinutes() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Số phút làm bài:'),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            controller: numOfMinutesDoingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Nhập số phút làm bài',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return _validateForm(value);
              }
              if (int.parse(value) <= 10) {
                return 'Quá ngắn';
              }
              return null;
            },
          ),
        ),
      ],
    );
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

  Future<void> completeSetup() async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }
      setState(() {
        isLoading = true;
      });

      final bool isSuccess = await PostExamSchedule().postExamSchedule(
        ExamSchedule(
          account: UserManagement().curAccount,
          exam: Exam(
            tenBaiThi: nameOfExamController.value.text,
            thoiGianBatDau: serverDateFormat.format(timeStart),
            baoLau: numOfMinutesDoingController.value.text,
            lop: curClass,
          ),
        ),
      );

      if (isSuccess) {
        Toast.show('Đã lập lịch xong!', context);
        Navigator.popUntil(
          context,
          ModalRoute.withName('/${UIData.HOME_ROUTE_NAME}'),
        );
      } else {
        Toast.show('Thao tác thất bại!', context);
      }
    } catch (e) {
      print(e);
      Toast.show('Có lỗi xảy ra!', context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

const _textSetting = TextStyle(
  fontWeight: FontWeight.bold,
);

String _validateForm(String value) {
  if (value.isEmpty) {
    return 'Trường này là bắt buộc';
  }
  return null;
}

const _MINUTES_DEFAULT_STR = '60';
