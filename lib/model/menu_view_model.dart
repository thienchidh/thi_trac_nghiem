import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/menu.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class MenuViewModel {
  List<Menu> menuItems;

  MenuViewModel({this.menuItems}) {
    menuItems = <Menu>[
      Menu(
        title: UIData.PRACTICE,
        menuColor: Color(0xffe19b6b),
        icon: Icons.directions_run,
        image: UIData.blankImage,
        nameRouter: UIData.PRACTICE_ROUTE_NAME,
        validFor: UserType.student,
      ),
      Menu(
        title: UIData.EXAM,
        menuColor: Color(0xffc7d8f4),
        icon: Icons.send,
        image: UIData.loginImage,
        nameRouter: UIData.LIST_EXAM_ROUTE_NAME,
        validFor: UserType.student,
      ),
      Menu(
        title: UIData.FAVORITE_QUESTION,
        menuColor: Color(0xffddcec2),
        icon: Icons.favorite,
        image: UIData.timelineImage,
        nameRouter: UIData.FAVORITE_ROUTE_NAME,
        validFor: UserType.student,
      ),
      Menu(
        title: UIData.SETTING,
        menuColor: Color(0xff2a8ccf),
        icon: Icons.settings,
        image: UIData.settingsImage,
        nameRouter: UIData.SETTINGS_EXAM_ROUTE_NAME,
        validFor: UserType.teacher,
      ),
      Menu(
        title: UIData.HISTORY,
        menuColor: Color(0xff7f5741),
        icon: Icons.history,
        image: UIData.verifyImage,
        nameRouter: UIData.HISTORY_ROUTE_NAME,
        validFor: UserType.student,
      ),
      Menu(
        title: UIData.ADVANCE,
        menuColor: Color(0xff050505),
        icon: Icons.account_box,
        image: UIData.ADVANCE_IMAGE,
        nameRouter: UIData.ADVANCE_ROUTE_NAME,
        validFor: UserType.teacher,
      ),
      Menu(
        title: UIData.ABOUT_US,
        menuColor: Color(0xff261d33),
        icon: Icons.touch_app,
        image: UIData.ABOUT_US_IMAGE,
        nameRouter: UIData.ABOUT_US_ROUTE_NAME,
      ),
      Menu(
        title: UIData.SUPPORT,
        toolTip: 'Ủng hộ chúng tôi bằng cách click vào các quảng cáo',
        menuColor: Color(0xffddcec2),
        icon: Icons.payment,
        image: UIData.paymentImage,
        nameRouter: UIData.SUPPORT_ROUTE_NAME,
      ),
    ];
  }
}
