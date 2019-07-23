import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

import 'menu.dart';

class MenuViewModel {
  List<Menu> menuItems;

  MenuViewModel({this.menuItems}) {
    menuItems = <Menu>[
      Menu(
          title: 'Luyện Tập',
          menuColor: Color(0xffe19b6b),
          icon: Icons.train,
          image: UIData.blankImage,
          items: ['No Search Result', 'No Internet', 'No Item 3', 'No Item 4']),
      Menu(
          title: 'Vào Thi',
          menuColor: Color(0xffc7d8f4),
          icon: Icons.send,
          image: UIData.loginImage,
          items: ['Login With OTP', 'Login 2', 'Sign Up', 'Login 4']),
      Menu(
          title: 'Lịch sử bài thi',
          menuColor: Color(0xff7f5741),
          icon: Icons.history,
          image: UIData.timelineImage,
          items: ['Feed', 'Tweets', 'Timeline 3', 'Timeline 4']),
      Menu(
          title: 'Cài đặt đề thi',
          menuColor: Color(0xff2a8ccf),
          icon: Icons.settings,
          image: UIData.settingsImage,
          items: ['Device Settings', 'Settings 2', 'Settings 3', 'Settings 4']),
      Menu(
          title: 'Profile',
          menuColor: Color(0xff050505),
          icon: Icons.person,
          image: UIData.profileImage,
          items: ['View Profile', 'Profile 2', 'Profile 3', 'Profile 4']),
      Menu(
          title: 'Về chúng tôi',
          menuColor: Color(0xff261d33),
          icon: Icons.dashboard,
          image: UIData.dashboardImage,
          items: ['Dashboard 1', 'Dashboard 2', 'Dashboard 3', 'Dashboard 4']),
      Menu(
          title: 'Ủng hộ',
          toolTip: 'Ủng hộ chúng tôi bằng cách click vào các quảng cáo',
          menuColor: Color(0xffddcec2),
          icon: Icons.payment,
          image: UIData.paymentImage,
          items: ['Credit Card', 'Payment Success', 'Payment 3', 'Payment 4']),
      Menu(
          title: 'Thoát',
          menuColor: Color(0xffc8c4bd),
          icon: Icons.exit_to_app,
          image: UIData.shoppingImage,
          items: [
            'Shopping List',
            'Shopping Details',
            'Product Details',
            'Shopping 4'
          ]),
    ];
  }
}
