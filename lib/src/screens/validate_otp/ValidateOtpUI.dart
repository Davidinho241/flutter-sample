import 'package:flutter/material.dart';
import 'package:coinpay/src/helpers/dialog.dart';
import 'package:coinpay/src/helpers/modal.dart';
import 'package:coinpay/src/screens/reset_password/ResetPassword.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/texts.dart';
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
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

// ignore: must_be_immutable
class ValidateOtpUI extends StatefulWidget {
  String action;

  ValidateOtpUI({Key key, @required this.action}) : super(key: key);

  @override
  _ValidateOtpUIState createState() => _ValidateOtpUIState(this.action);
}

class _ValidateOtpUIState extends State<ValidateOtpUI> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController persistentBottomSheetController;
  String action = "null";

  int requestAttemptsCounter = 3;
  Duration timeOutOtp = Duration(minutes: 3);
  Duration waitTimeOtp = Duration(minutes: 15);
  bool hideButton = false;
  bool sendRefreshCode = false;

  final otpController = TextEditingController();

  _ValidateOtpUIState(this.action);

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    print("requestAttemptsCounter");
    print(requestAttemptsCounter);
    print("hideButton");
    print(hideButton);
    print("sendRefreshCode");
    print(sendRefreshCode);

    super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onEnd() {
    print('Timer end');
  }

  bool isAbleToSubmitCode(){
    return true;
  }

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
          padding: EdgeInsets.all(Sizes.s8),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: Sizes.s70,
                  ),
                  Image.asset(
                    "assets/images/misc/validate_otp_illustrations.png",
                    height: Sizes.s300,
                    width: Sizes.s500,
                  ),
                  SizedBox(
                    height: Sizes.s20,
                  ),
                  requestAttemptsCounter == 0 ? Container() : PinCodeTextField(
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
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                    validator: _validateField,
                    onChanged: (String value){},

                  ),
                  requestAttemptsCounter == 0 ? Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextTitle(
                            data: "${lang.translate('screen.validateOTP.maxAttemptsMessage')}",
                            height: Sizes.s20,
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
                    child: action == "forgot_password" ?
                    ButtonSystemTheme(
                      title: "${lang.translate('screen.validateOTP.otpButton')}",
                      onTap: () async {
                        setState(() {
                          requestAttemptsCounter = requestAttemptsCounter - 1;
                        });
                        if(_formKey.currentState.validate()){
                          openRemovePage(context, ResetPasswordUI(code: otpController.text));
                        }
                      },
                      fontSize: FontSize.s16,
                      weight: FontWeight.w500,
                      height: Sizes.s48,
                      width: MediaQuery.of(context).size.width,
                      color: secondaryColor,
                    ): hideButton || sendRefreshCode ? Container() : ButtonSystemTheme(
                      title: "${lang.translate('screen.validateOTP.otpButton')}",
                      onTap: () async {
                        setState(() {
                          requestAttemptsCounter = requestAttemptsCounter - 1;
                        });
                        if(_formKey.currentState.validate()){
                          persistentBottomSheetController = _scaffoldKey.currentState.showBottomSheet((context) =>
                              Container(
                                child: CustomModal.loading(context, "${lang.translate('screen.register.progressMessage')}"),
                              )
                          );
                          final sharedPrefService = await SharedPreferencesService.instance;
                          await Future.delayed(
                            Duration(milliseconds: 5000),
                                ()  =>  UserController().run(
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
                                  openRemovePage(context, DashboardUI());
                                }else if(data['code'] == 1002){
                                  setState(() {
                                    hideButton = true;
                                    sendRefreshCode = true;
                                  });
                                  await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorPhoneValidation')}");
                                }else {
                                  setState(() {
                                    hideButton = true;
                                    sendRefreshCode = true;
                                  });
                                  await dialogShow(context, "Oops an error !!!", data['message']);
                                }
                              }).catchError((onError) async{
                                print(onError);
                                await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorMessage')}");
                              }).whenComplete(() => {
                                setState(()=>{
                                  print('Data receive'),
                                })
                              }),
                          ).whenComplete(() => {
                            persistentBottomSheetController.close(),
                            print("Future closed")
                          });
                        }
                      },
                      fontSize: FontSize.s16,
                      weight: FontWeight.w500,
                      height: Sizes.s48,
                      width: MediaQuery.of(context).size.width,
                      color: secondaryColor,
                    ),
                  ),
                  SizedBox(height: Sizes.s20),
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
                  ),
                  SizedBox(
                    height: Sizes.s30,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: requestAttemptsCounter == 0 ? Row(
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
                      ) :Container(),
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
