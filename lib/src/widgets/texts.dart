import 'package:flutter/material.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:google_fonts/google_fonts.dart';

// Used in as Text title in all the app
class TextTitle extends StatelessWidget {
  final String data;
  final Color color;
  final double height;
  final double size;
  final FontWeight weight;
  final TextAlign textAlign;

  TextTitle({
    @required this.data,
    this.color,
    this.height,
    this.size,
    this.weight,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Text(
          data,
          style: GoogleFonts.heebo(
            color: color != null ? color : textTitleColor,
            fontSize: size != null ? size : FontSize.s30,
            fontWeight: weight != null ? weight : FontWeight.bold,
            fontStyle: FontStyle.normal,
            letterSpacing: Sizes.s1,
            height: height != null ? height : 1.6
          ),
          textAlign: textAlign != null ? textAlign :TextAlign.center,
        ),
      ),
    );
  }
}

// Used as Text paragraph in all the appd
class TextParagraph extends StatelessWidget {

  final String data;
  final Color color;
  final double height;
  final double size;
  final FontWeight weight;
  final FontStyle fontStyle;
  final TextAlign textAlign;

  TextParagraph({
    @required this.data,
    this.color,
    this.height,
    this.size,
    this.weight,
    this.fontStyle,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Text(
          data,
          style: TextStyle(
            color: color != null ? color : textParagraphColor,
            fontFamily: 'SF-Pro',
            fontSize: size != null ? size : FontSize.s14,
            fontWeight: weight != null ? weight : FontWeight.w300,
            fontStyle: fontStyle != null ? fontStyle : FontStyle.normal,
            letterSpacing: Sizes.s1,
            height: height != null ? height : 1.6
          ),
          textAlign: textAlign != null ? textAlign :TextAlign.center,
        ),
      ),
    );
  }

}
