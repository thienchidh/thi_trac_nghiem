import 'package:intl/intl.dart';

const String baseUrl = 'http://103.81.86.156:8080';
const String STATUS_SUCCESS = 'success';
const String STATUS_FAILED = 'failed';

const int DEFAULT_MILLIS_SLEEP_API = 1500;

const Duration connectTimedOut = Duration(milliseconds: 10000);

final DateFormat serverDateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

// 01/01/2000 05:06 PM
final DateFormat localDateFormat = DateFormat('dd-MM-yyyy hh:mm aaa');
