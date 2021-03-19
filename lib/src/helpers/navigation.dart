import 'package:flutter/material.dart';
import 'package:coinpay/src/screens/webview/WebviewUI.dart';

openPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

openRemovePage(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
    (Route<dynamic> route) => false,
  );
}

openWebView(BuildContext context, String title, String url) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebviewUI(
        url: "$url",
        title: "$title",
      ),
    ),
  );
}
