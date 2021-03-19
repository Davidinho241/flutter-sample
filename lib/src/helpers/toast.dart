import 'package:flutter/material.dart';

showToast(GlobalKey<ScaffoldState> _scaffoldKey, String content) {
  _scaffoldKey.currentState.showSnackBar(
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
