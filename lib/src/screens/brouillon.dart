import 'package:coinpay/src/helpers/modal.dart';
import 'package:coinpay/src/screens/dashboard/DashboardUI.dart';
import 'package:coinpay/src/screens/reset_password/ResetPassword.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:coinpay/src/helpers/validation.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/models/User.dart';
import 'package:coinpay/src/screens/login/LoginUI.dart';
import 'package:coinpay/src/screens/validate_otp/ValidateOtpUI.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/inputs.dart';
import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/env/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:coinpay/src/helpers/dialog.dart';

class ValidateOtpUI extends StatefulWidget {
  final String action;

  ValidateOtpUI({Key key, @required this.action}) : super(key: key);

  @override
  _ValidateOtpUIState createState() => _ValidateOtpUIState();
}

class _ValidateOtpUIState extends State<ValidateOtpUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController persistentBottomSheetController;

  int requestAttemptsCounter = 3;
  Duration timeOutOtp = Duration(minutes: 3);
  Duration waitTimeOtp = Duration(minutes: 15);
  bool hideButton = false;
  bool sendRefreshCode = false;

  final otpController = TextEditingController();
  FocusNode inputOtpFocus;

  @override
  void initState() {
    super.initState();
    inputOtpFocus = FocusNode();
    inputOtpFocus.addListener(() {
      setState(() {
        print("Has focus: ${inputOtpFocus.hasFocus}");
      });
    });
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    otpController.dispose();
    inputOtpFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);

    String _validateField(String value) {
      if (isRequired(value)) return "${lang.translate('screen.register.emptyFieldMessage')}";

      if (value.length < 3) return "${lang.translate('screen.register.invalidLengthFieldMessage')}";

      return null;
    }
    void goToDashboard(BuildContext context) async{
      persistentBottomSheetController = _scaffoldKey.currentState.showBottomSheet((context) =>
          Container(
            child: CustomModal.loading(context, "${lang.translate('screen.register.progressMessage')}"),
          )
      );
      final sharedPrefService = await SharedPreferencesService.instance;
      await Future.delayed(
        Duration(milliseconds: 5000),
            ()  =>  UserController().verifyOTP(
            widget.action == "login" ? Routes.LOGIN_VERIFY_OTP : Routes.VERIFY_OTP ,
            {
              "phone": sharedPrefService.phone,
              "code": otpController.text,
            }
        ).then((data) async {
          print(data);
          if(data['code'] == 1000){
            openRemovePage(context, DashboardUI());
          }else if(data['code'] == 1002){
            setState(() {
              requestAttemptsCounter = requestAttemptsCounter - 1;
              hideButton = true;
              sendRefreshCode = true;
            });
            await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorPhoneValidation')}");
          }else {
            setState(() {
              requestAttemptsCounter = requestAttemptsCounter - 1;
              hideButton = true;
              sendRefreshCode = true;
            });
            await dialogShow(context, "Oops an error !!!", data['error']);
          }
        }).catchError((onError) async{
          print(onError);
          await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorMessage')}");
        }).whenComplete(() => {
          print('Request receive'),
        }),
      ).whenComplete(() => {
        persistentBottomSheetController.close(),
        print("Future closed")
      });
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
          padding: EdgeInsets.all(Sizes.s8),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  requestAttemptsCounter == 0 ? Container() : OutlinePinField(
                    appContext: context,
                    length: 6,
                    controller: otpController,
                    validator: _validateField,
                  ),
                  requestAttemptsCounter == 0 ? Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextTitle(
                            data: "${lang.translate('screen.validateOTP.maxAttemptsMessage')}",
                            height: Sizes.s1,
                            size: Sizes.s24,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: Sizes.s20),
                          TextParagraph(
                            data: "${lang.translate('screen.validateOTP.waitBeforeRefreshOtpMessage')}",
                            fontStyle: FontStyle.normal,
                            weight: FontWeight.w400,
                            size: Sizes.s14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextParagraph(
                                data: "${lang.translate('screen.validateOTP.waitBeforeRefreshOtpMessage2')}",
                                fontStyle: FontStyle.normal,
                                weight: FontWeight.w400,
                                size: Sizes.s14,
                              ),
                              SlideCountdownClock(
                                duration: waitTimeOtp,
                                textStyle: TextStyle(
                                    color: secondaryColor,
                                    fontSize: Sizes.s14,
                                    fontWeight: FontWeight.w500
                                ),
                                separator: ":",
                                onDone: (){
                                  setState(() {
                                    sendRefreshCode = true;
                                    hideButton = true;
                                  });
                                },
                              ),
                              TextParagraph(
                                data: "${lang.translate('screen.validateOTP.closeBracket')}",
                                fontStyle: FontStyle.normal,
                                weight: FontWeight.w400,
                                size: Sizes.s14,
                              ),
                            ],
                          )
                        ],
                      )
                  ) :
                  sendRefreshCode ?
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            TextParagraph(
                              data: "${lang.translate('screen.validateOTP.invalidOtp')}",
                              fontStyle: FontStyle.normal,
                              weight: FontWeight.w400,
                              size: Sizes.s16,
                              color: Colors.red,
                            ),
                            TextParagraph(
                              data: "${lang.translate('screen.validateOTP.invalidOtpMessage')}",
                              fontStyle: FontStyle.normal,
                              weight: FontWeight.w400,
                              size: Sizes.s16,
                            ),
                            InkWell(
                              onTap: () async{
                                setState(() {
                                  sendRefreshCode = false;
                                  hideButton = false;
                                });
                                persistentBottomSheetController = _scaffoldKey.currentState.showBottomSheet((context) =>
                                    Container(
                                      child: CustomModal.loading(context, "${lang.translate('screen.register.progressMessage')}"),
                                    )
                                );
                                final sharedPrefService = await SharedPreferencesService.instance;
                                await Future.delayed(
                                    Duration(milliseconds: 5000),
                                        ()  =>  UserController().run(
                                        Routes.RESEND_OTP ,
                                        {
                                          "phone": sharedPrefService.phone,
                                        }
                                    )).then((data) async {
                                  print(data);
                                  if(data['code'] == 1000){
                                    setState(() {
                                      sendRefreshCode = false;
                                      hideButton = false;
                                    });
                                  }else {
                                    await dialogShow(context, "Oops an error !!!", data['message']);
                                  }
                                }).catchError((onError) async{
                                  print(onError);
                                  await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorMessage')}");
                                }).whenComplete(() => {
                                  persistentBottomSheetController.close(),
                                  setState(()=>{
                                    print('Data receive'),
                                  })
                                });
                              },
                              child: TextParagraph(
                                data: "${lang.translate('screen.validateOTP.btnResendOtp')}",
                                fontStyle: FontStyle.normal,
                                weight: FontWeight.w400,
                                size: Sizes.s16,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) : Align(
                    alignment: Alignment.center,
                    child: TextParagraph(
                      data: "${lang.translate('screen.validateOTP.subtitle')}",
                      fontStyle: FontStyle.normal,
                      weight: FontWeight.w400,
                      size: Sizes.s16,

                    ),
                  ),
                  SizedBox(
                    height: Sizes.s30,
                  ),
                  Container(
                    height: Sizes.s40,
                    child: hideButton || sendRefreshCode ? Container() : ButtonSystemTheme(
                      title: "${lang.translate('screen.validateOTP.otpButton')}",
                      onTap: () async {
                        if (_formKey.currentState.validate()){
                          widget.action == "forgot_password" ? openRemovePage(context, ResetPasswordUI(code: otpController.text)) : goToDashboard(context);
                        }
                      },
                      fontSize: FontSize.s16,
                      weight: FontWeight.w500,
                      height: Sizes.s48,
                      width: MediaQuery.of(context).size.width,
                      color: secondaryColor,
                    ),
                  ),
                  SizedBox(height: Sizes.s40),
                  Align(
                      alignment: Alignment.center,
                      child: sendRefreshCode ? Container() : Row(
                        children: [
                          TextParagraph(
                            data: "${lang.translate('screen.validateOTP.receiveCodeMessage')}",
                            fontStyle: FontStyle.normal,
                            weight: FontWeight.w400,
                            size: Sizes.s14,
                          ),
                          SlideCountdownClock(
                            duration: timeOutOtp,
                            textStyle: TextStyle(
                              color: secondaryColor,
                              fontSize: Sizes.s14,
                              fontWeight: FontWeight.w400,
                            ),
                            separator: ":",
                            onDone: (){
                              setState(() {
                                sendRefreshCode = true;
                                hideButton = true;
                              });
                            },
                          ),
                          TextParagraph(
                            data: "${lang.translate('screen.validateOTP.closeBracket')}",
                            fontStyle: FontStyle.normal,
                            weight: FontWeight.w400,
                            size: Sizes.s14,
                          ),
                        ],
                      )
                  ),
                  SizedBox(
                    height: Sizes.s30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}