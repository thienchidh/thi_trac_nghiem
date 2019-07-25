import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class UIData {
  static const String LOGIN = 'Đăng nhập';
  static const String HOME = 'Trang chủ';
  static const String NOT_FOUND = 'Không tìm thấy';
  static const String PRACTICE = 'Luyện tập';
  static const String HISTORY = 'Lịch sử';
  static const String SUPPORT = 'Ủng hộ';
  static const String SETTING = 'Cài đặt đề thi';
  static const String ABOUT_US = 'Về chúng tôi';
  static const String ADVANCE = 'Nâng cao';
  static const String FAVORITE_QUESTION = 'Câu hỏi yêu thích';
  static const String EXAM = 'Kỳ thi';

  //routes name
  static const String LOGIN_ROUTE_NAME = '$LOGIN';
  static const String HOME_ROUTE_NAME = '$HOME';
  static const String NOT_FOUND_ROUTE_NAME = '$NOT_FOUND';
  static const String PRACTICE_ROUTE_NAME = '$PRACTICE';
  static const String HISTORY_ROUTE_NAME = '$HISTORY';
  static const String SUPPORT_ROUTE_NAME = '$SUPPORT';
  static const String SETTINGS_EXAM_ROUTE_NAME = '$SETTING';
  static const String ABOUT_US_ROUTE_NAME = '$ABOUT_US';
  static const String ADVANCE_ROUTE_NAME = '$ADVANCE';
  static const String FAVORITE_ROUTE_NAME = '$FAVORITE_QUESTION';
  static const String EXAM_ROUTE_NAME = '$EXAM';

  //about app
  static const String APP_NAME = 'Thi trắc nghiệm';
  static const String VERSION_APP = "1.0.0";

  //fonts
  static const String fontFamily = 'Montserrat';
  static const String ralewayFont = 'Raleway';
  static const String quickBoldFont = 'Montserrat_Bold.otf';
  static const String quickNormalFont = 'Montserrat_Book.otf';
  static const String quickLightFont = 'Montserrat_Light.otf';

  //images
  static const String imageDir = 'assets/images';
  static const String pkImage = '$imageDir/pk.jpg';
  static const String profileImage = '$imageDir/profile.jpg';
  static const String blankImage = '$imageDir/blank.jpg';
  static const String dashboardImage = '$imageDir/dashboard.jpg';
  static const String loginImage = '$imageDir/login.jpg';
  static const String paymentImage = '$imageDir/payment.jpg';
  static const String settingsImage = '$imageDir/setting.jpeg';
  static const String shoppingImage = '$imageDir/shopping.jpeg';
  static const String timelineImage = '$imageDir/timeline.jpeg';
  static const String verifyImage = '$imageDir/verification.jpg';

  //colors
  static const Color primaryColor = Colors.blue;
  static const MaterialColor primarySwatch = Colors.lime;
  static const Color accentColor = Colors.cyan;
  static const List<Color> kitGradients = [primaryColor, accentColor];

  //login
  static const String enter_code_label = 'Phone Number';
  static const String enter_code_hint = '10 Digit Phone Number';
  static const String enter_otp_label = 'OTP';
  static const String enter_otp_hint = '4 Digit OTP';
  static const String get_otp = 'Get OTP';
  static const String resend_otp = 'Resend OTP';
  static const String login = 'Login';
  static const String enter_valid_number = 'Enter 10 digit phone number';
  static const String enter_valid_otp = 'Enter 4 digit otp';

  //gneric
  static const String error = 'Error';
  static const String success = 'Success';
  static const String ok = 'OK';
  static const String forgot_password = 'Forgot Password?';
  static const String something_went_wrong = 'Something went wrong';
  static const String coming_soon = 'Coming Soon';

  //random color
  static final Random _random = Random();

  /// Returns a random color.
  static Color next() {
    return Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}
