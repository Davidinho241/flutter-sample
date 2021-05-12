import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class WalletTile extends StatelessWidget{
  String icon, title;

  WalletTile({this.icon, this.title});

  @override
  Widget build(BuildContext context) {

    return Container(
        width: Sizes.s123,
        height: Sizes.s30,
        margin: EdgeInsets.only(right: Sizes.s20),
        padding: EdgeInsets.only(left: Sizes.s3),
        decoration: BoxDecoration(
          color: currencyBtnColor,
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.s6),
          ),
        ),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                icon,
                height: Sizes.s13,
              ),
              SizedBox(width: Sizes.s5),
              Text(
                "$title",
                style: GoogleFonts.heebo(
                  color: Colors.white,
                  fontSize: FontSize.s13,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  letterSpacing: Sizes.s2,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(width: Sizes.s10),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: Sizes.s25,
              )
            ],
          ),
        )
    );
  }
}

// ignore: must_be_immutable
class SliderTile extends StatelessWidget{
  String imagePath, title, description;

  SliderTile(this.imagePath, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400) ? Sizes.s40 : Sizes.s90),
        Align(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            imagePath,
            alignment: Alignment.center,
            height: (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400) ?
                  MediaQuery.of(context).size.height/4.2 : MediaQuery.of(context).size.height/4.8,
          ),
        ),
        SizedBox(height: (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400) ? Sizes.s40 : Sizes.s90),
        Center(
          child: Container(
            padding: EdgeInsets.only(left: Sizes.s24, right: Sizes.s24),
            child: Column(
              children: [
                Container(
                  child: TextTitle(data : title),
                ),
                SizedBox(height: Sizes.s20),
                Container(
                  padding: EdgeInsetsDirectional.only(start: Sizes.s24, end: Sizes.s24),
                  child: TextParagraph(data : description),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: Sizes.s5)
      ],
    );
  }
}


Widget displayError(BuildContext context, {String error}){
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s8)
    ),
    color: errorDisplayColor,
    child: SizedBox(
      height: Sizes.s55,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/images/icons/infoCircleIcon.svg",
              alignment: Alignment.center,
              height: Sizes.s20,
              color: Colors.red,
            ),
            SizedBox(
              width: Sizes.s10,
            ),
            Text.rich(
              TextSpan(
                text: 'Oops Error :  ',
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'SF-Pro',
                    fontSize: FontSize.s14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: Sizes.s1,
                    height: Sizes.s1
                ),
                children: <TextSpan>[
                  TextSpan(text: error)
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

