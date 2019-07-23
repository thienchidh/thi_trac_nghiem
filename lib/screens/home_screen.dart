import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/bloc/menu_bloc.dart';
import 'package:thi_trac_nghiem/model/menu.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';
import 'package:thi_trac_nghiem/widget/about_tile.dart';
import 'package:thi_trac_nghiem/widget/common_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopCallback(context),
      child: Scaffold(
        key: _scaffoldState,
        drawer: CommonDrawer(),
        body: _bodySliverList(context),
      ),
    );
  }

  Widget _bodySliverList(BuildContext context) {
    return StreamBuilder<List<Menu>>(
      stream: MenuBloc().menuItems,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? CustomScrollView(
                slivers: <Widget>[
                  _appBar(),
                  _bodyGrid(context, snapshot.data),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget _appBar() {
    return SliverAppBar(
      backgroundColor: UIData.primaryColor,
      pinned: true,
      elevation: 10.0,
      forceElevated: true,
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: UIData.kitGradients,
            ),
          ),
        ),
        title: Row(
          children: <Widget>[
            FlutterLogo(
              colors: Colors.yellow,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              UIData.APP_NAME,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemMenuStack(BuildContext context, Menu menu) {
    return InkWell(
      onTap: () => _showModalBottomSheet(context, menu),
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
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) =>
            itemMenuStack(context, menu[index]),
        childCount: menu.length,
      ),
    );
  }

  Widget _header() {
    return Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: UIData.kitGradients,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage(UIData.pkImage),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, Menu menu) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _header(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: menu.items.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListTile(
                      title: Text(
                        menu.items[i],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/${menu.items[i]}');
                      },
                    ),
                  );
                },
              ),
            ),
            AboutApp(),
          ],
        );
      },
    );
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text("Bạn có muốn thoát?"),
          title: Text("Xác nhận thoát!"),
          actions: <Widget>[
            FlatButton(
              child: Text("Không"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("Đồng ý"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }
}
