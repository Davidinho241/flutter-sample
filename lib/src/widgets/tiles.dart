import 'package:coinpay/src/models/CountryOption.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/utils/themes.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

class CountryTile extends StatelessWidget {
  final CountryOption countryOption;
  final Function onTap;

  CountryTile({
    @required this.countryOption,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            child:
                CountryPickerUtils.getDefaultFlagImage(countryOption.country),
            decoration: BoxDecoration(boxShadow: [customShadow()]),
          ),
          SizedBox(
            width: Sizes.s15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${countryOption.country.name} (${countryOption.lang})",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: FontSize.s15,
                ),
              ),
              Text(
                "${countryOption.currency}",
                style: TextStyle(
                  fontSize: FontSize.s12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          countryOption.selected ? Icon(Icons.check) : Container()
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final CountryOption countryOption;
  final Function onTap;

  ActionTile({
    @required this.countryOption,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            child:
                CountryPickerUtils.getDefaultFlagImage(countryOption.country),
            decoration: BoxDecoration(boxShadow: [customShadow()]),
          ),
          SizedBox(
            width: Sizes.s15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${countryOption.country.name} (${countryOption.lang})",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: FontSize.s15,
                ),
              ),
              Text(
                "${countryOption.currency}",
                style: TextStyle(
                  fontSize: FontSize.s12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          countryOption.selected ? Icon(Icons.check) : Container()
        ],
      ),
    );
  }
}


