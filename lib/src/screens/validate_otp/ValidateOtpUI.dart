import 'package:coinpay/src/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:coinpay/src/env/routes.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/helpers/toast.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/inputs.dart';
import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/helpers/validation.dart';
import 'package:coinpay/src/screens/dashboard/DashboardUI.dart';

class ValidateOtpUI extends StatefulWidget {
  @override
  _ValidateOtpUIState createState() => _ValidateOtpUIState();
}

class _ValidateOtpUIState extends State<ValidateOtpUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);

    String _validateField(String value) {
      if (isRequired(value)) return "${lang.translate('screen.validateOTP.emptyFieldMessage')}";

      if (value.length < 6 || value.length > 6) return "${lang.translate('screen.validateOTP.invalidLengthFieldMessage')}";

      return null;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("${lang.translate('screen.validateOTP.appBar')}"),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(Sizes.s15, Sizes.s15, Sizes.s15, 0),
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: Sizes.s70,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${lang.translate('screen.validateOTP.title')}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: FontSize.s20,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${lang.translate('screen.validateOTP.subtitle')}",
                    style: TextStyle(
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                SizedBox(
                  height: Sizes.s30,
                ),
                Image.asset(
                  "assets/images/misc/validateOTP.png",
                  height: Sizes.s300,
                  width: Sizes.s500,
                ),
                SizedBox(
                  height: Sizes.s20,
                ),
                OutlineTextField(
                  hintText: "${lang.translate('screen.validateOTP.otpHint')}",
                  labelText: "${lang.translate('screen.validateOTP.otpLabel')}",
                  hintStyle: TextStyle(fontSize: FontSize.s14),
                  labelStyle: TextStyle(fontSize: FontSize.s14),
                  controller: otpController,
                  textInputType: TextInputType.number,
                  validator: _validateField,
                ),
                SizedBox(
                  height: Sizes.s15,
                ),
                Container(
                  height: Sizes.s40,
                  child: GradientButton(
                    title: "${lang.translate('screen.validateOTP.otpButton')}",
                    onTap: () async {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return ;
                        },
                      );
                      final sharedPrefService = await SharedPreferencesService.instance;
                      await Future.delayed(
                        Duration(milliseconds: 2500),
                          () => UserController().verifyOTP(
                            Routes.VERIFY_OTP,
                            {
                              "phone": "sharedPrefService.phone",
                              "password": "sharedPrefService.password",
                              "otp": otpController.text,
                            }
                          ).then((data) async {
                            print(data);
                            if(data['code'] == 1000){
                              final sharedPrefService = await SharedPreferencesService.instance;
                              await "sharedPrefService.setToken(data['token'])";
                              Navigator.pop(context);
                              openRemovePage(context, DashboardUI());
                            }else {
                              Navigator.pop(context);
                              await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text("Oops an error !!!"),
                                    content: Text(data['data'].values.first[0]),
                                  )
                              );
                            }
                          }).catchError((onError) async{
                            print(onError);
                            await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Oops an error !!!"),
                                  content: Text(onError),
                                )
                            );
                          }),
                      );
                      showToast(_scaffoldKey,
                          "${lang.translate('screen.validateOTP.otpSuccess')}");
                    },
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
