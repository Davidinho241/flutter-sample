import 'package:coinpay/src/utils/sizes.dart';
import 'package:flutter/material.dart';

class CustomModal {

  static loading(BuildContext context, String title) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Sizes.s15),
          topRight: Radius.circular(Sizes.s15),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          height: Sizes.s100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("$title"),
                SizedBox(
                  height: Sizes.s10,
                ),
                LinearProgressIndicator(),
                SizedBox(
                  height: Sizes.s15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

