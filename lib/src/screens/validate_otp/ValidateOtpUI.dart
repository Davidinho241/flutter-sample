import 'package:coinpay/src/helpers/dialog.dart';
import 'package:coinpay/src/screens/reset_password/ResetPassword.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:coinpay/src/env/routes.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/helpers/validation.dart';
import 'package:coinpay/src/screens/dashboard/DashboardUI.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ValidateOtpUI extends StatefulWidget {
  String action;

  ValidateOtpUI({Key key, @required this.action}) : super(key: key);

  @override
  _ValidateOtpUIState createState() => _ValidateOtpUIState(this.action);
}

class _ValidateOtpUIState extends State<ValidateOtpUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String action = "null";

  final otpController = TextEditingController();

  _ValidateOtpUIState(this.action);

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
                  "assets/images/misc/referal.png",
                  height: Sizes.s300,
                  width: Sizes.s500,
                ),
                SizedBox(
                  height: Sizes.s20,
                ),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  textStyle: GoogleFonts.heebo(
                    fontSize: FontSize.s14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(Sizes.s10),
                    fieldHeight: Sizes.s50,
                    fieldWidth: Sizes.s50,
                    activeFillColor: Colors.indigoAccent,
                    selectedFillColor: Colors.indigo
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  keyboardType: TextInputType.number,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: inputBg,
                      blurRadius: Sizes.s10,
                    )
                  ],
                  onCompleted: (v) {
                    print("Completed");
                    print(otpController.text);
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      print(value);
                    });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },

                ),
                SizedBox(
                  height: Sizes.s15,
                ),
                Container(
                  height: Sizes.s40,
                  child: action == "forgot_password" ?
                  ButtonSystemTheme(
                    title: "${lang.translate('screen.validateOTP.otpButton')}",
                    onTap: () async {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: false,
                        builder: (context) {
                          return LinearProgressIndicator();
                        },
                      );
                      await Future.delayed(
                        Duration(milliseconds: 5000),
                          () => {
                            Navigator.pop(context),
                            openRemovePage(context, ResetPasswordUI(code: otpController.text))
                          }
                      );
                    },
                    fontSize: FontSize.s16,
                    weight: FontWeight.w500,
                    height: Sizes.s48,
                    width: MediaQuery.of(context).size.width,
                    color: secondaryColor,
                  )
                      : ButtonSystemTheme(
                    title: "${lang.translate('screen.validateOTP.otpButton')}",
                    onTap: () async {
                      showModalBottomSheet<void>(
                        context: this.context,
                        backgroundColor: Colors.transparent,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return LinearProgressIndicator();
                        },
                      );
                      final sharedPrefService = await SharedPreferencesService.instance;
                      await Future.delayed(
                        Duration(milliseconds: 5000),
                            () => UserController().run(
                            action == "login" ? Routes.LOGIN_VERIFY_OTP : Routes.VERIFY_OTP ,
                            {
                              "phone": sharedPrefService.phone,
                              "code": otpController.text,
                            }
                        ).then((data) async {
                          print(data);
                          if(data['code'] == 1000){
                            final sharedPrefService = await SharedPreferencesService.instance;
                            await sharedPrefService.setToken(data['token']);
                            Navigator.pop(context);
                            openRemovePage(context, DashboardUI());
                          }else {
                            await dialogShow(context, "Oops an error !!!", data['message']);
                            Navigator.pop(context);
                          }
                        }).catchError((onError) async{
                          print(onError);
                          await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorMessage')}");
                          Navigator.pop(context);
                        }),
                      );
                    },
                    fontSize: FontSize.s16,
                    weight: FontWeight.w500,
                    height: Sizes.s48,
                    width: MediaQuery.of(context).size.width,
                    color: secondaryColor,
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
