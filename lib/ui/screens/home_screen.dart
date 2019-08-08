import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/logic/bloc/menu_bloc.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/menu.dart';
import 'package:thi_trac_nghiem/ui/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/utils/delay_ultis.dart';
import 'package:thi_trac_nghiem/utils/dialog_ultis.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: CommonDrawer(),
      body: _bodySliverList(context),
    );
  }

  Widget _bodySliverList(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return DialogUltis().confirmLogout(context);
      },
      child: RefreshIndicator(
        child: StreamBuilder<List<Menu>>(
          stream: MenuBloc().menuItems,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                _appBar(),
                _bodyGrid(context, snapshot.data),
              ],
            )
                : LoadMoreItem(
              isVisible: true,
            );
          },
        ),
        onRefresh: () async {
          final ultis = DelayUltis(
            milliseconds: 1000,
          )
            ..start();
          print('_HomeScreenState._bodySliverList.refresh');
          await ultis.finish();
        },
      ),
    );
  }

  Widget _appBar() {
    return SliverAppBar(
      backgroundColor: UIData.primaryColor,
      pinned: true,
      elevation: 10.0,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: UIData.kitGradients,
            ),
          ),
        ),
        title: Text(UIData.APP_NAME),
      ),
    );
  }

  Widget itemMenuStack(BuildContext context, Menu menu) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/${menu.nameRouter}');
      },
      splashColor: Colors.orange,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Tooltip(
          message: menu.toolTip != null ? menu.toolTip : menu.title,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _menuImage(menu),
              _menuColor(),
              _menuData(menu),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuImage(Menu menu) {
    return Image.asset(
      menu.image,
      fit: BoxFit.cover,
    );
  }

  Widget _menuColor() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 5.0,
          ),
        ],
      ),
    );
  }

  Widget _menuData(Menu menu) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          menu.icon,
          color: Colors.white,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          menu.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _bodyGrid(BuildContext context, List<Menu> menu) {
    final Iterable<Menu> filter = menu.where((Menu menu) {
      return menu.validFor == UserType.both ||
          menu.validFor == UserManagement().curUser.userType;
    });

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
        MediaQuery
            .of(context)
            .orientation == Orientation.portrait ? 2 : 3,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
            itemMenuStack(context, filter.elementAt(index)),
        childCount: filter.length,
      ),
    );
  }
}
