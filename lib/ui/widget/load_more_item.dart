import 'package:flutter/material.dart';

class LoadMoreItem extends StatelessWidget {
  final bool isVisible;

  const LoadMoreItem({Key key, @required this.isVisible})
      : assert(isVisible != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: const SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
