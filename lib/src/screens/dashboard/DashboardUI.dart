import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'home/HomeUI.dart';

class DashboardUI extends StatefulWidget {
  @override
  _DashboardUIState createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  // default active index
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
      // if active tab is not account ui
      appBar: currentIndex != 3
          ? AppBar(
              elevation: 0,
              title: Row(
                children: <Widget>[
                  currentIndex == 0
                      ? Icon(
                          Feather.compass,
                          color: primaryColor,
                          size: FontSize.s15,
                        )
                      : Container(),
                  currentIndex == 0
                      ? Container(
                          width: Sizes.s10,
                        )
                      : Container(),
                  Text(
                    "CoinPay",
                    style: TextStyle(
                      fontSize: FontSize.s16,
                      color: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .color
                          .withOpacity(.7),
                    ),
                  )
                ],
              ),
            )
          : null,
      body: IndexedStack(
        index: currentIndex,
        children: <Widget>[
          HomeUI(),
        ],
      ),
    );
  }
}
