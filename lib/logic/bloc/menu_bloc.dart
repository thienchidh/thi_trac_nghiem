import 'dart:async';

import 'package:thi_trac_nghiem/model/menu.dart';
import 'package:thi_trac_nghiem/model/menu_view_model.dart';

class MenuBloc {
  final _menuVM = MenuViewModel();
  final menuController = StreamController<List<Menu>>();

  Stream<List<Menu>> get menuItems => menuController.stream;

  MenuBloc() {
    menuController.add(_menuVM.menuItems);
  }
}
