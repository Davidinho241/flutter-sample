import 'package:coinpay/src/helpers/currency.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/models/Wallet.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/cards.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionUI extends StatefulWidget {
  final List<Wallet> wallets;
  final String action;
  final Map<String, dynamic> rates;

  const ActionUI({Key key, @required this.wallets, @required this.action, this.rates}) : super(key: key);

  @override
  _ActionUIState createState() => _ActionUIState();
}

class _ActionUIState extends State<ActionUI> {
  double sum = 0.0;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;

  initializeData() async {
    widget.wallets.first.isActivated = true;
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {

    var lang = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("Transactions"),
      ),
      body: Container(
        height: double.maxFinite,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(Sizes.s8),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextParagraph(
                    data: "${lang.translate('screen.wallet.accountBalance')}",
                    size: Sizes.s16,
                    weight: FontWeight.w500,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: Sizes.s10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.wallets != null ? widget.wallets.length : 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final sharedPrefService = await SharedPreferencesService.instance;
                          sharedPrefService.setCryptoCurrency(widget.wallets[index].cryptoCurrency);
                          setState(() {
                            widget.wallets.forEach((element) {
                              element.isActivated = false;
                            });
                            widget.wallets[index].isActivated = !widget.wallets[index].isActivated;
                          });
                        },
                        child: WalletCards(
                          wallet: widget.wallets[index],
                          isActivated: widget.wallets[index].isActivated,
                          rates: widget.rates,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Sizes.s20),
              ],
            )
        ),
      ),
    );
  }
}

