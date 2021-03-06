import 'package:coinpay/src/blocs/language.bloc.dart';
import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/env/routesAuth.dart';
import 'package:coinpay/src/helpers/dialog.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/modal.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/models/CountryOption.dart';
import 'package:coinpay/src/screens/registration/RegisterUI.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/tiles.dart';
import 'package:country_pickers/countries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingUI extends StatefulWidget {
  @override
  _SettingUIState createState() => _SettingUIState();
}

class _SettingUIState extends State<SettingUI> {

  List<CountryOption> countries = [
    CountryOption(
      country: countryList.firstWhere((e) => e.isoCode == "FR"),
      selected: false,
      currency: "XAF",
      lang: "French",
      code: Language.FR,
    ),
    CountryOption(
      country: countryList.firstWhere((e) => e.isoCode == "US"),
      selected: false,
      currency: "USD",
      lang: "English",
      code: Language.EN,
    ),
  ];

  selectCountry(CountryOption country) async {
    BlocProvider.of<LanguageBloc>(context).add(LanguageSelected(country.code));
    openRemovePage(context, RegisterUI());
  }

  @override
  void initState() {
    super.initState();
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;

  @override
  Widget build(BuildContext context) {

    var lang = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: Sizes.s20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: Sizes.s20,
                      left: Sizes.s20,
                      right: Sizes.s20,
                    ),
                    child: CountryTile(
                      countryOption: countries[index],
                      onTap: () {
                        selectCountry(countries[index]);
                      },
                    ),
                  );
                },
              ),
              ButtonWithIcon(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

