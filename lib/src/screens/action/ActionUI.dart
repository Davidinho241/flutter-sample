import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/models/Wallet.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/cards.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:coinpay/src/widgets/tiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ActionUI extends StatefulWidget {
  final List<Wallet> wallets;
  final String action;
  final Map<String, dynamic> rates;

  const ActionUI({Key key, this.wallets, this.action, this.rates}) : super(key: key);

  @override
  _ActionUIState createState() => _ActionUIState();
}

class _ActionUIState extends State<ActionUI> {
  double sum = 0.0;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;
  List<Wallet> wallets = [];
  Wallet currentWallet;
  var _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  FocusNode amountFocus;
  FocusNode addressFocus;
  QRViewController qrCodeController;

  void updateCurrentWallet(Wallet wallet) {
    setState(() {
      currentWallet = wallet;
    });
  }

  void updateQrCodeController(QRViewController controller) {
    setState(() {
      qrCodeController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      wallets = widget.wallets;
      currentWallet = wallets.first;
    });

    amountFocus = FocusNode();
    amountFocus.addListener(() {
      setState(() {
        print("Has focus: ${amountFocus.hasFocus}");
      });
    });
    addressFocus = FocusNode();
    addressFocus.addListener(() {
      setState(() {
        print("Has focus: ${addressFocus.hasFocus}");
      });
    });
  }
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    amountController.dispose();
    addressController.dispose();
    addressFocus.dispose();
    amountFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: TextTitle(
          data: widget.action == "Send Coins" ? "${lang.translate('screen.transactionScreen.appBarSend')}" : "${lang.translate('screen.transactionScreen.appBarReceive')}",
          height: Sizes.s1,
          size: FontSize.s25,
          weight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, wallets),
          icon: Icon(
            Icons.arrow_back_ios
          ),
        ),
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
                    data: widget.action == "Send Coins" ? "${lang.translate('screen.transactionScreen.subtitleSend')}" : "${lang.translate('screen.transactionScreen.subtitleReceive')}",
                    size: Sizes.s16,
                    weight: FontWeight.w500,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: Sizes.s10),
                Container(
                  height: 180,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: wallets != null ? wallets.length : 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          updateCurrentWallet(wallets[index]);
                          final sharedPrefService = await SharedPreferencesService.instance;
                          sharedPrefService.setCryptoCurrency(wallets[index].cryptoCurrency);
                          setState(() {
                            wallets.forEach((element) {
                              element.isActivated = false;
                            });
                            wallets[index].isActivated = !wallets[index].isActivated;
                          });
                        },
                        child: WalletCards(
                          wallet: wallets[index],
                          isActivated: wallets[index].isActivated,
                          rates: widget.rates,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Sizes.s50),
                widget.action == "Send Coins" ?
                  SendTile(
                    formKey: _formKey,
                    amountController: amountController,
                    amountFocus: amountFocus,
                    addressController: addressController,
                    addressFocus: addressFocus,
                  ) :
                  ReceiveTile(
                    address: currentWallet.address,
                    addressFocus: addressFocus,
                    addressController: addressController,
                  )
              ],
            )
        ),
      ),
    );
  }
}

