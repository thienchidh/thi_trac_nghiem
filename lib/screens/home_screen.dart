import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thi_trac_nghiem/bloc/menu_bloc.dart';
import 'package:thi_trac_nghiem/model/menu.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';

class HomeScreen extends StatelessWidget {
  final _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: Scaffold(
        key: _scaffoldState,
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

  //appbar
  Widget _appBar() {
    return SliverAppBar(
      backgroundColor: Colors.black,
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
              textColor: Colors.white,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              UIData.appName,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //menuStack
  Widget menuStack(BuildContext context, Menu menu) {
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

  //stack 1/3
  Widget _menuImage(Menu menu) {
    return Image.asset(
      menu.image,
      fit: BoxFit.cover,
    );
  }

  //stack 2/3
  Widget _menuColor() {
    return Container(
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.8),
          blurRadius: 5.0,
        ),
      ]),
    );
  }

  //stack 3/3
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  //bodygrid
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
        (BuildContext context, int index) => menuStack(context, menu[index]),
        childCount: menu.length,
      ),
    );
  }

  Widget _header() {
    return Ink(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: UIData.kitGradients2)),
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
        return Material(
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: Column(
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
                            Navigator.pushNamed(context, "/${menu.items[i]}");
                          }),
                    );
                  },
                ),
              ),
//                AboutApp(),
            ],
          ),
        );
      },
    );
  }
}
