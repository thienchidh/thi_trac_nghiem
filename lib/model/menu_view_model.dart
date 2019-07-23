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
        icon: Icons.train,
        image: UIData.blankImage,
        items: [UIData.PRACTICE_ROUTE_NAME],
      ),
      Menu(
        title: UIData.EXAM,
        menuColor: Color(0xffc7d8f4),
        icon: Icons.send,
        image: UIData.loginImage,
        items: [UIData.EXAM_ROUTE_NAME],
      ),
      Menu(
        title: UIData.HISTORY,
        menuColor: Color(0xff7f5741),
        icon: Icons.history,
        image: UIData.timelineImage,
        items: [UIData.HISTORY_ROUTE_NAME],
      ),
      Menu(
        title: UIData.SETTING,
        menuColor: Color(0xff2a8ccf),
        icon: Icons.settings,
        image: UIData.settingsImage,
        items: [UIData.SETTING],
      ),
      Menu(
        title: 'Profile',
        menuColor: Color(0xff050505),
        icon: Icons.person,
        image: UIData.profileImage,
        items: ['View Profile', 'Profile 2', 'Profile 3', 'Profile 4'],
      ),
      Menu(
        title: 'Về chúng tôi',
        menuColor: Color(0xff261d33),
        icon: Icons.dashboard,
        image: UIData.dashboardImage,
        items: ['Dashboard 1', 'Dashboard 2', 'Dashboard 3', 'Dashboard 4'],
      ),
      Menu(
        title: 'Ủng hộ',
        toolTip: 'Ủng hộ chúng tôi bằng cách click vào các quảng cáo',
        menuColor: Color(0xffddcec2),
        icon: Icons.payment,
        image: UIData.paymentImage,
        items: ['Credit Card', 'Payment Success', 'Payment 3', 'Payment 4'],
      ),
    ];
  }
}
