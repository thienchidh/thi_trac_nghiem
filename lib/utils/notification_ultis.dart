import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';

class NotificationUltis {
  var _context;
  var _android;
  var _iOS;
  var _initSettings;
  var _platformChannelSpecifics;

  var _flutterLocalNotificationsPlugin;
  var _androidPlatformChannelSpecifics;
  var _iOSPlatformChannelSpecifics;

  Future<void> onSelectNotification(String payload) async {
    await UserManagement().logout(_context, true);

    await _flutterLocalNotificationsPlugin.cancel(int.parse(payload));
  }

  NotificationUltis(this._context) : super() {
    _android = AndroidInitializationSettings('@mipmap/ic_launcher');
    _iOS = IOSInitializationSettings();

    _initSettings = InitializationSettings(_android, _iOS);

    _androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');

    _iOSPlatformChannelSpecifics = IOSNotificationDetails();

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    _flutterLocalNotificationsPlugin.initialize(_initSettings,
        onSelectNotification: onSelectNotification);

    _platformChannelSpecifics = NotificationDetails(
        _androidPlatformChannelSpecifics, _iOSPlatformChannelSpecifics);
  }

  get iOSPlatformChannelSpecifics => _iOSPlatformChannelSpecifics;

  get androidPlatformChannelSpecifics => _androidPlatformChannelSpecifics;

  get flutterLocalNotificationsPlugin => _flutterLocalNotificationsPlugin;

  get platformChannelSpecifics => _platformChannelSpecifics;

  get initSettings => _initSettings;

  get iOS => _iOS;

  get android => _android;
}
