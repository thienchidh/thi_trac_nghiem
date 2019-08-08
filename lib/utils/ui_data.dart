import 'dart:ui';

import 'package:flutter/material.dart';

class UIData {
  static const String YES = 'Có';
  static const String NO = 'Không';

  static const String COMPLETE = 'Hoàn thành';
  static const String ERROR_OCCURRED = 'Có lỗi xảy ra!';

  static const String LOGOUT = 'Đăng xuất';
  static const String BACK = 'Quay lại';

  static const String CONFIRM = 'Xác nhận';
  static const String SUBMIT_EXAM = 'NỘP BÀI';

  //about app
  static const String APP_NAME = 'Thi trắc nghiệm';
  static const String VERSION_APP = "1.0.0";

  static const RANDOM_DIALOG_TEXT =
      'Bạn có muốn random câu trả lời cho các câu chưa chọn?';

  static const String NUM_OF_QUESTION = 'Số câu hỏi';
  static const String SCORE = 'Điểm';

  static const String NUM_OF_WRONG = 'Trả lời sai';
  static const String NUM_OF_CORRECT = 'Trả lời đúng';

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
  static const String LIST_EXAM = 'Danh sách kỳ thi';
  static const String FINISHED = 'Kết quả thi';
  static const String LIST_STUDENT = 'Danh sách sinh viên';
  static const String LIST_SCORE = 'Kết quả kỳ thi';
  static const String RESULT = 'Kết quả';
  static const String TIMER = 'Đếm giờ';
  static const String LIST_EXAM_STUDENT = 'Danh sách kỳ thi của sinh viên';
  static const String CHECK_ANSWER = 'Đáp án';

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
  static const String LIST_EXAM_ROUTE_NAME = '$LIST_EXAM';
  static const String LIST_EXAM_STUDENT_ROUTE_NAME = '$LIST_EXAM_STUDENT';
  static const String FINISHED_ROUTE_NAME = '$FINISHED';
  static const String LIST_STUDENT_ROUTE_NAME = '$LIST_STUDENT';
  static const String LIST_SCORE_ROUTE_NAME = '$LIST_SCORE';
  static const String TIMER_ROUTE_NAME = '$TIMER';
  static const String CHECK_ANSWER_ROUTE_NAME = '$CHECK_ANSWER';

  //fonts
  static const String fontFamily = 'Montserrat';
  static const String ralewayFont = 'Raleway';
  static const String quickBoldFont = 'Montserrat_Bold.otf';
  static const String quickNormalFont = 'Montserrat_Book.otf';
  static const String quickLightFont = 'Montserrat_Light.otf';

  //images
  static const String imageDir = 'assets/images';
  static const String ADVANCE_IMAGE = '$imageDir/profile.jpg';
  static const String blankImage = '$imageDir/blank.jpg';
  static const String ABOUT_US_IMAGE = '$imageDir/dashboard.jpg';
  static const String loginImage = '$imageDir/login.jpg';
  static const String paymentImage = '$imageDir/payment.jpg';
  static const String settingsImage = '$imageDir/setting.jpeg';
  static const String timelineImage = '$imageDir/timeline.jpeg';
  static const String verifyImage = '$imageDir/verification.jpg';

  //colors
  static const Color primaryColor = Colors.blue;
  static const Color primarySwatch = Colors.lime;
  static const Color accentColor = Colors.cyan;
  static const List<Color> kitGradients = [primaryColor, accentColor];
}
