// Used at BookingUI
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/models/Transaction.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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