import 'package:flutter/material.dart';

Future<bool> dialogShow(BuildContext context, String title, String content) async {
  return showDialog<bool>(
    context: context, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  ) ?? false;
}
