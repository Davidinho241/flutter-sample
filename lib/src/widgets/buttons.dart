import 'package:flutter/material.dart';
import 'package:coinpay/src/utils/themes.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:google_fonts/google_fonts.dart';

// Create gradient button
class GradientButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final double fontSize;
  GradientButton({
    @required this.title,
    @required this.onTap,
    this.fontSize = 12,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          Sizes.s10,
          Sizes.s5,
          Sizes.s10,
          Sizes.s5,
        ),
        decoration: BoxDecoration(
          // custom gradient color, you can customize this
          gradient: customGradient(),
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.s5),
          ),
        ),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(color: Colors.white, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}

// Used in Login & Register
class ButtonWithIcon extends StatelessWidget {
  final String title;
  final double height;
  final Function onTap;
  final IconData icon;
  final Color color;
  final double size;
  ButtonWithIcon({
    @required this.title,
    this.height,
    @required this.onTap,
    @required this.icon,
    @required this.color,
    this.size
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height != null ? height : Sizes.s50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.s10),
          ),
        ),
        child: SizedBox(
          width: size != null ? size : Sizes.s123,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "$title",
                style: GoogleFonts.heebo(
                  color: Colors.white,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: Sizes.s1,
                ),
              ),
              SizedBox(
                width: Sizes.s5,
              ),
              Icon(
                icon,
                size: FontSize.s15,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonSystemTheme extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final Function onTap;
  final Color color;
  final double size;
  final double fontSize;
  final FontWeight weight;

  ButtonSystemTheme({
    @required this.title,
    this.height,
    @required this.onTap,
    @required this.color,
    this.size,
    this.width,
    this.fontSize,
    this.weight
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height != null ? height : Sizes.s50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.s10),
          ),
        ),
        child: SizedBox(
          width: width != null ? width : Sizes.s123,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "$title",
                style: GoogleFonts.heebo(
                  color: Colors.white,
                  fontSize: fontSize != null ? fontSize : FontSize.s16,
                  fontWeight: weight != null ? weight : FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: Sizes.s1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Used at Maps UI
class CustomBackButton extends StatelessWidget {
  final Function onTap;
  final bool enableMargin;
  CustomBackButton({@required this.onTap, this.enableMargin = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: enableMargin
          ? EdgeInsets.only(top: Sizes.s50, left: Sizes.s20)
          : EdgeInsets.zero,
      width: Sizes.s40,
      height: Sizes.s40,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.s40),
        ),
        boxShadow: [
          customShadow(),
        ],
      ),
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
