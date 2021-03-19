import 'package:flutter/material.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/utils/themes.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/screens/sliderscreen/SliderScreenUI.dart';

class SplashscreenUI extends StatefulWidget {
  @override
  _SplashscreenUIState createState() => _SplashscreenUIState();
}

class _SplashscreenUIState extends State<SplashscreenUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      openRemovePage(context, SliderScreenUI());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(gradient: splashGradient()),
        child: Center(
          child: Image.asset(
            "assets/images/icons/app_logo.png",
            height: Sizes.s180,
          ),
        ),
      ),
    );
  }
}
