import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewUI extends StatelessWidget {
  final String url;
  final String title;
  WebviewUI({@required this.url, @required this.title});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text("$title"),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
