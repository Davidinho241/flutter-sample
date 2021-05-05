import 'package:coinpay/src/components/actionsComponent.dart';
import 'package:coinpay/src/helpers/currency.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/models/Wallet.dart';
import 'package:coinpay/src/screens/action/ActionUI.dart';
import 'package:coinpay/src/services/local_service.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/cards.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeUI extends StatefulWidget {

  const HomeUI({Key key}) : super(key: key);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  List<Wallet> _wallets = []; // history data
  Map<String, dynamic> rates ; // history data
  List<ActionComponent> _actions = [];
  bool _loaded = false; // is loaded
  double sum = 0.0;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;
  String to;
  Wallet currentWallet;

  void updateWallets(List<Wallet> wallets) {
    setState(() {
      _wallets = wallets;
      currentWallet = wallets.first;
    });
  }

  initializeData() async {
    final sharedPrefService = await SharedPreferencesService.instance;
    to = sharedPrefService.currencyCode;

    await LocalService.loadRateTable().then((value) {
      setState(() {
        rates = value;
      });
    });

    await LocalService.loadWallets().then((value) {
      setState(() {
        _loaded = true;
        _wallets = value;

        if (_wallets != null){
          _wallets.first.isActivated = true;
          _wallets.forEach((element) {
            sum += convertBalance(element.balance, rates["${element.cryptoCurrency+"-"+to}"].toDouble());
          });
        }
      });
    });

    await LocalService.getActions().then((value) {
      setState(() {
        _actions = value;
      });
    });
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
      body: Container(
        height: double.maxFinite,
        child: _loaded ? SingleChildScrollView(
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextParagraph(
                    data: "\$"+priceParser.format(sum),
                    weight: FontWeight.w700,
                    size: Sizes.s31m25,
                    textAlign: TextAlign.left,
                    height: Sizes.s2,
                    color: textTitleColor,
                  ),
                ),
                SizedBox(height: Sizes.s10),
                Container(
                  height: 180,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _wallets != null ? _wallets.length : 0,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final sharedPrefService = await SharedPreferencesService.instance;
                          sharedPrefService.setCryptoCurrency(_wallets[index].cryptoCurrency);
                          setState(() {
                            _wallets.forEach((element) {
                              element.isActivated = false;
                            });
                            _wallets[index].isActivated = !_wallets[index].isActivated;
                            currentWallet = _wallets[index];
                          });
                        },
                        child: WalletCards(
                          wallet: _wallets[index],
                          isActivated: _wallets[index].isActivated,
                          rates: rates,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Sizes.s20),
                Container(
                  height: 500,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _actions != null ? _actions.length : 0,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        shape: Border(
                          bottom: BorderSide(color: inputHint, width: .5)
                        ),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            _actions[index].icon,
                            color: colorIconAction,
                          ),
                          title: TextParagraph(
                            data: _actions[index].title,
                            textAlign: TextAlign.start,
                            weight: FontWeight.w500,
                            size: FontSize.s14,
                            height: Sizes.s1,
                            color: defaultTextColor,
                          ),
                          onTap: index == 0 ? null : () async {
                            final wallets = await openPage(context, ActionUI(wallets: _wallets, action: _actions[index].title, rates: rates));
                            updateWallets(wallets);
                          },
                        ),
                      );
                    }
                  ),
                ),
              ],
            )
        ) : Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

