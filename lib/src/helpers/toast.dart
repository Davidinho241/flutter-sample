import 'package:flutter/material.dart';

showToast(GlobalKey<ScaffoldState> _scaffoldKey, String content) {
  ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
    SnackBar(
      content: Text(
        "$content",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black.withOpacity(.5),
    ),
  );
}
