import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

import 'menu.dart';

class MenuViewModel {
  List<Menu> menuItems;

  MenuViewModel({this.menuItems}) {
    menuItems = <Menu>[
      Menu(
        title: UIData.PRACTICE,
        menuColor: Color(0xffe19b6b),
        icon: Icons.directions_run,
        image: UIData.blankImage,
        item: UIData.PRACTICE_ROUTE_NAME,
      ),
      Menu(
        title: UIData.EXAM,
        menuColor: Color(0xffc7d8f4),
        icon: Icons.send,
        image: UIData.loginImage,
        item: UIData.LIST_EXAM_ROUTE_NAME,
      ),
      Menu(
        title: UIData.FAVORITE_QUESTION,
        menuColor: Color(0xffddcec2),
        icon: Icons.favorite,
        image: UIData.timelineImage,
        item: UIData.FAVORITE_ROUTE_NAME,
      ),
      Menu(
        title: UIData.HISTORY,
        menuColor: Color(0xff7f5741),
        icon: Icons.history,
        image: UIData.verifyImage,
        item: UIData.HISTORY_ROUTE_NAME,
      ),
      Menu(
        title: UIData.SETTING,
        menuColor: Color(0xff2a8ccf),
        icon: Icons.settings,
        image: UIData.settingsImage,
        item: UIData.SETTINGS_EXAM_ROUTE_NAME,
      ),
      Menu(
        title: 'Profile',
        menuColor: Color(0xff050505),
        icon: Icons.person,
        image: UIData.profileImage,
        item: UIData.ADVANCE_ROUTE_NAME,
      ),
      Menu(
        title: UIData.ABOUT_US,
        menuColor: Color(0xff261d33),
        icon: Icons.dashboard,
        image: UIData.dashboardImage,
        item: UIData.ABOUT_US_ROUTE_NAME,
      ),
      Menu(
        title: 'Ủng hộ',
        toolTip: 'Ủng hộ chúng tôi bằng cách click vào các quảng cáo',
        menuColor: Color(0xffddcec2),
        icon: Icons.payment,
        image: UIData.paymentImage,
        item: UIData.SUPPORT_ROUTE_NAME,
      ),
    ];
  }
}
