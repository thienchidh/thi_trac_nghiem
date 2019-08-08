import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';

class Menu {
  String title;
  IconData icon;
  String image;
  BuildContext context;
  Color menuColor;
  String nameRouter;
  String toolTip;
  UserType validFor;

  Menu({
    this.title,
    this.icon,
    this.image,
    this.context,
    this.menuColor = Colors.black,
    this.nameRouter,
    this.toolTip,
    this.validFor = UserType.both,
  }) : assert(title != null);
}
