import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coinpay/src/utils/colors.dart';

ThemeData buildThemeLight(context) {
  return ThemeData(
    /// app primary color, currently is blueAccent
    /// you can edit this on colors.dart
    primaryColor: primaryColor,
    // appbar theme, we can set background, icon, and text color here
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      textTheme: GoogleFonts.heeboTextTheme(
        ThemeData.light().textTheme.copyWith(),
      ),
    ),
    // scaffold color, we can set app background color (scaffold body)
    scaffoldBackgroundColor: Colors.white,
    // card theme color, if currently light theme is active, set this to white
    cardTheme: CardTheme(color: Colors.white),
    // swatch color
    primarySwatch: Colors.indigo,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // text theme data, we'll use available data (ThemeData.light())
    textTheme: GoogleFonts.heeboTextTheme(
      ThemeData.light().textTheme.copyWith(),
    ),
  );
}

BoxShadow customShadow() {
  return BoxShadow(
    /// color params is used to set shadow color
    /// you can use your own color, for example you can set color to Colors.green.withOpacity(0.5)
    color: primaryColor.withOpacity(0.2),
    // the spread radius of shadow
    spreadRadius: 1,
    // the blur radius of shadow
    blurRadius: 1,
    offset: Offset(2, 1), // changes position of shadow
  );
}

LinearGradient customGradient() {
  // button gradient color
  return LinearGradient(
    // set where the gradient starts
    begin: Alignment.topRight,
    // set where the gradient ends
    end: Alignment.bottomLeft,
    // put your color here
    colors: [
      // first color of gradient
      Colors.blue,
      // second color of gradient
      Colors.blue[600],
      // third color of gradient
      Colors.blue[900],
    ],
  );
}

LinearGradient chatGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff2483f3),
      Color(0xff4394F4),
      Color(0xff5DA3F5),
    ],
  );
}

LinearGradient splashGradient() {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff1C409C),
      Color(0xff1C409C),
      Color(0xff1C409C),
    ],
  );
}
