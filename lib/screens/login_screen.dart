import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thi_trac_nghiem/api/login_api.dart';
import 'package:thi_trac_nghiem/model/account.dart';
import 'package:thi_trac_nghiem/screens/search_screen.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Account _account = Account();
  final storage = FlutterSecureStorage();

  final _txtEmailController = TextEditingController();

  final _txtPasswordController = TextEditingController();

  bool _isRememberPassword = true;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _txtEmailController.dispose();
    _txtPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? _buildLoading()
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          loginHeader(),
                          loginFields(),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }

  loginHeader() {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlutterLogo(
          size: 80.0,
          colors: primaryColor,
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          "Chào mừng bạn đến với Thi Trắc Nghiệm",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          "Đăng nhập để tiếp tục",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  loginFields() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
            child: TextField(
              controller: _txtEmailController,
              onChanged: (x) => _account.username = x,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Nhập tên người dùng của bạn",
                labelText: "Tên đăng nhập",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: TextField(
              controller: _txtPasswordController,
              onChanged: (x) => _account.password = x,
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Nhập mật khẩu của bạn",
                labelText: "Mật khẩu",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('Bạn là:'),
              subtitle: Text(_account.isStudent ? "Sinh viên" : "Giảng viên"),
              value: _account.isStudent,
              onChanged: (newValue) =>
                  setState(() => _account.isStudent = newValue),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("Nhớ mật khẩu:"),
              subtitle: Text(_isRememberPassword ? "Có chứ" : "Không, cảm ơn"),
              value: _isRememberPassword,
              onChanged: (x) => setState(() => _isRememberPassword = x),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            width: double.infinity,
            child: RaisedButton(
              padding: EdgeInsets.all(12.0),
              shape: StadiumBorder(),
              child: Text(
                "ĐĂNG NHẬP",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
              onPressed: () {
                login();
              },
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "TẠO MỘT TÀI KHOẢN",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future login() async {
    if (!_isLoading) {
      if (_txtEmailController.text.isEmpty ||
          _txtPasswordController.text.isEmpty) {
        Toast.show("Bạn phải điền đầy đủ thông tin", context);
        return;
      }
      setState(() => _isLoading = true);
      if (_isRememberPassword) {
        _rememberPassWord(_account);
      } else {
        _rememberPassWord(Account());
      }
      User user = await LoginApi().verifyLogin(_account);

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SearchScreen(user),
          ),
        );
        Toast.show("Đăng nhập thành công!", context);
      } else {
        Toast.show("Đăng nhập thất bại!", context);
      }
      setState(() => _isLoading = false);
    } else {
      Toast.show("Thao tác quá nhanh!", context);
    }
  }

  Future<void> _rememberPassWord(Account a) async {
    await storage.write(key: "username", value: a.username);
    await storage.write(key: "password", value: a.password);
    await storage.write(key: "isStudent", value: a.isStudent.toString());
  }

  void _initialize() {
    storage.readAll().then((map) {
      print('_LoginScreenState._initialize $map');
      String username = map["username"];
      String password = map["password"];
      bool isStudent = map["isStudent"] == "true";

      setState(() {
        _account = Account(
          username: username,
          password: password,
          isStudent: isStudent,
        );
      });
      _txtEmailController.text = _account.username;
      _txtPasswordController.text = _account.password;
    });
  }

  Widget _buildLoading() {
    return Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}

class LoginTwoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(),
      ),
    );
  }

  loginBody() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields()],
        ),
      );

  loginHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlutterLogo(
            colors: Colors.green,
            size: 80.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Chào mừng bạn đến với Thi Trắc Nghiệm",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Đăng nhập để tiếp tục",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  loginFields() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "Nhập tên người dùng của bạn",
                  labelText: "Tên đăng nhập",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Nhập mật khẩu của bạn",
                  labelText: "Mật khẩu",
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                child: Text(
                  "ĐĂNG NHẬP",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "ĐĂNG KÍ MỘT TÀI KHOẢN",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
}
