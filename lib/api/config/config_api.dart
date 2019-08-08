import 'package:intl/intl.dart';

const String baseUrl = 'http://103.81.86.156:8080';
const String STATUS_SUCCESS = 'success';
const String STATUS_FAILED = 'failed';
const String STATUS = 'status';

const int DEFAULT_MILLIS_SLEEP_API = 100;

const Duration connectTimedOut = Duration(milliseconds: 10000);

final DateFormat serverDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

// 01-01-2000 15:06
final DateFormat localDateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
