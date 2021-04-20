import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/env/routesAuth.dart';
import 'package:coinpay/src/helpers/dialog.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/modal.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/models/Wallet.dart';
import 'package:coinpay/src/screens/registration/RegisterUI.dart';
import 'package:coinpay/src/services/local_service.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  List<Wallet> wallets = []; // history data
  bool _loaded = false; // is loaded

  @override
  void initState() {
    super.initState();
    LocalService.loadWallets().then((value) {
      setState(() {
        _loaded = true;
        wallets = value;
      });
    });
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;

  @override
  Widget build(BuildContext context) {

    var lang = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: _loaded ? ButtonWithIcon(
          title: 'Logout',
          color: secondaryColor,
          size: Sizes.s100,
          height: Sizes.s30,
          icon: Icons.power_settings_new_outlined,
          onTap: () async{
            persistentBottomSheetController = _scaffoldKey.currentState.showBottomSheet((context) =>
              Container(
              child: CustomModal.loading(context, "${lang.translate('screen.register.progressMessage')}"),
              )
            );
            await Future.delayed(
              Duration(milliseconds: 5000),
                () async => await UserController().logout(RoutesAuth().buildRoute(RoutesAuth.LOGOUT)).then((data) async {
                print(data);
                if(data['code'] == 1000){
                  final sharedPrefService = await SharedPreferencesService.instance;
                  sharedPrefService.clear();
                  openRemovePage(context, RegisterUI());
                }else if(data['code'] == 1002){
                  await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorPhoneValidation')}");
                }else {
                  await dialogShow(context, "Oops an error !!!", data['message']);
                }
              }).catchError((onError) async{
                print(onError);
                await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorMessage')}");
              }).whenComplete(() => {
                setState(()=>{
                  print('Data receive'),
                })
              })
            ).whenComplete(() => {
              persistentBottomSheetController.close(),
              print("Future closed")
            });
          },
        ) : Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

