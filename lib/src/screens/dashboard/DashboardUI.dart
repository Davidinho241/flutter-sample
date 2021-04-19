import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:coinpay/src/components/walletsComponent.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/screens/dashboard/market/MarketUI.dart';
import 'package:coinpay/src/screens/dashboard/transaction/TransactionUI.dart';
import 'package:coinpay/src/services/local_service.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/widgets/common_widgets.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/HomeUI.dart';

class DashboardUI extends StatefulWidget {

  DashboardUI({Key key}) : super(key: key);

  @override
  _DashboardUIState createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  // default active index
  int currentIndex = 0;

  List<WalletComponent> _wallets = [];
  String dropdownValue = "BTC";

  initializeData() async {
    await LocalService.getWallets().then((value) {
      setState(() {
        _wallets = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  // app bar title for every tab
  String appBarTitle(context) {
    var lang = AppLocalizations.of(context);
    switch (currentIndex) {
    // first tab
      case 0:
        return "${lang.translate('screen.dashboard.firstAppBar')}";
        break;
    // second tab
      case 1:
        return "${lang.translate('screen.dashboard.secondAppBar')}";
        break;
    // third tab
      case 2:
        return "${lang.translate('screen.dashboard.thirdAppBar')}";
        break;
    // fourth tab
      case 3:
        return "${lang.translate('screen.dashboard.fourthAppBar')}";
        break;
    // fifth tab
      case 4:
        return "${lang.translate('screen.dashboard.fifthAppBar')}";
        break;
    // if unknown
      default:
        return "";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    var lang = AppLocalizations.of(context);

    return Scaffold(
      // if active tab is not account ui
      appBar: currentIndex == 0
          ? AppBar(
              elevation: 0,
              title: Row(
                children: <Widget>[
                  SizedBox(height: Sizes.s70),
                  TextTitle(
                    data: appBarTitle(context),
                    height: Sizes.s1,
                    color: defaultTextColor,
                    weight: FontWeight.w600,
                    size: FontSize.s30,
                  )
                ],
              ),
            )
          : AppBar(
            elevation: 0,
            title: Row(
              children: <Widget>[
                SizedBox(height: Sizes.s70),
                TextTitle(
                  data: appBarTitle(context),
                  height: Sizes.s1,
                  color: defaultTextColor,
                  weight: FontWeight.w600,
                  size: FontSize.s30,
                )
              ],
            ),
            actions: [
              DropdownButton<String>(
                value: dropdownValue,
                underline: Container(
                  height: 0,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 0,
                ),
                onChanged: (newValue) async{
                  setState(() {
                    dropdownValue = newValue;
                  });
                  final sharedPrefService = await SharedPreferencesService.instance;
                  await sharedPrefService.setCryptoCurrency(newValue);
                },
                items: _wallets.map((WalletComponent item) {
                  return DropdownMenuItem<String>(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          item.inactivatedIcon,
                          height: Sizes.s13,
                        ),
                        SizedBox(width: Sizes.s5),
                        Text(
                          item.title,
                          style: GoogleFonts.heebo(
                            color: primaryColor50,
                            fontSize: FontSize.s13,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            letterSpacing: Sizes.s2,
                          ),
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                    value: item.currency,
                  );
                }).toList(),
                selectedItemBuilder: (context){
                  return _wallets.map<DropdownMenuItem<Widget>>((value) {
                    return DropdownMenuItem<Widget>(
                      value: WalletTile(
                          icon : value.icon,
                          title : value.title
                      ),
                      child: WalletTile(
                          icon : value.icon,
                          title : value.title
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
      body: IndexedStack(
        index: currentIndex,
        children: <Widget>[
          HomeUI(),
          TransactionUI(),
          MarketUI()
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Image.asset(
              "assets/images/icons/WalletFocus.png",
              height: Sizes.s30,
            ),
            title: Text("${lang.translate('screen.dashboard.firstTab')}"),
            activeColor: primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Image.asset(
              "assets/images/icons/Activity.png",
              height: Sizes.s30,
            ),
            title: Text("${lang.translate('screen.dashboard.secondTab')}"),
            activeColor: primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Image.asset(
              "assets/images/icons/Chart.png",
              height: Sizes.s30,
            ),
            title: Text("${lang.translate('screen.dashboard.thirdTab')}"),
            activeColor: primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Image.asset(
              "assets/images/icons/Notification.png",
              height: Sizes.s30,
            ),
            title: Text("${lang.translate('screen.dashboard.fourthTab')}"),
            activeColor: primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Image.asset(
              "assets/images/icons/Setting.png",
              height: Sizes.s30,
            ),
            title: Text("${lang.translate('screen.dashboard.fifthTab')}"),
            activeColor: primaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
