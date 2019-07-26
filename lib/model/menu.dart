import 'package:flutter/material.dart';

class Menu {
  String title;
  IconData icon;
  String image;
  String item;
  BuildContext context;
  Color menuColor;
  String toolTip;

  Menu({
    this.title,
    this.icon,
    this.image,
    this.item,
    this.context,
    this.menuColor = Colors.black,
    this.toolTip,
  }) : assert(title != null);
}
