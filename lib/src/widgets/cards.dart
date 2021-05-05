// Used at BookingUI
import 'package:coinpay/src/helpers/currency.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/models/Transaction.dart';
import 'package:coinpay/src/models/Wallet.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TransactionHistoryCard extends StatelessWidget {
  final Transaction transaction;
  TransactionHistoryCard({@required this.transaction});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Sizes.s15),
                ),
              ),
              height: Sizes.s100,
              width: Sizes.s100,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Sizes.s15),
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/misc/placeholder.png",
                  image: "${transaction.thumbnail}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: Sizes.s15,
            ),
            Divider(),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${transaction.hotel}",
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Sizes.s5),
                  Text(
                    "${transaction.guestName}",
                    style: TextStyle(
                      fontSize: FontSize.s12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${transaction.bookingDate}",
                    style: TextStyle(
                      fontSize: FontSize.s12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${transaction.room} ${lang.translate('widget.card.rooms')} / ${transaction.guest} ${lang.translate('widget.card.guests')}",
                    style: TextStyle(
                      fontSize: FontSize.s12,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Sizes.s5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      Text("${lang.translate('widget.card.bookAgain')}")
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: Sizes.s10),
        Divider(),
        SizedBox(height: Sizes.s20)
      ],
    );
  }
}

class WalletCards extends StatelessWidget {
  final Wallet wallet;
  final bool isActivated;
  final Map<String, dynamic> rates;
  WalletCards({@required this.wallet, this.isActivated = false, this.rates});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActivated? colorSecondary : Colors.white,
      elevation: Sizes.s2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.s6),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        margin: EdgeInsets.only(left: Sizes.s7),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "assets/images/misc/eclipse.svg",
                color: !isActivated ? Colors.white : null,
                height: Sizes.s100,
                width: Sizes.s100,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Sizes.s5),
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    isActivated ? "assets/images/icons/"+wallet.cryptoCurrency.toLowerCase()+"_logo_20.png" : "assets/images/icons/"+wallet.cryptoCurrency.toLowerCase()+"_logo_grey_20.png",
                  ),
                ),
                SizedBox(height: Sizes.s35),
                TextTitle(
                  data: "${wallet.balance}"+" ${wallet.cryptoCurrency}",
                  color: isActivated? Colors.white : primaryColor90,
                  size: FontSize.s18,
                ),
                SizedBox(height: Sizes.s45),
                TextParagraph(
                  data: userCurrencyName(context),
                  color: isActivated? colorActivateCardCurrency : inputHint,
                  size: FontSize.s8,
                  weight: FontWeight.w500,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextParagraph(
                        data: userCurrencySymbol(context)+priceParser.format(convertBalance(wallet.balance, rates["${wallet.cryptoCurrency+"-"+userCurrencyName(context)}"].toDouble())),
                        color: isActivated? Colors.white : primaryColor90,
                        size: FontSize.s14,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.start,
                        height: Sizes.s1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextParagraph(
                        data: "+9.28%",
                        color: isActivated? Colors.white : primaryColor90,
                        size: 0,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.end,
                        height: Sizes.s1,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}