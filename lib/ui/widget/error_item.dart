import 'package:flutter/material.dart';

class ErrorItem extends StatelessWidget {
  final Function onClick;

  const ErrorItem({Key key, @required this.onClick})
      : assert(onClick != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Có lỗi xảy ra, click vào đây để thử lại!',
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
      ),
      isThreeLine: false,
      leading: CircleAvatar(
        child: Text(':('),
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent,
      ),
      onTap: () => onClick(),
    );
  }
}
