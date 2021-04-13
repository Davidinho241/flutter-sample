import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/env/routes.dart';
import 'package:coinpay/src/helpers/dialog.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/modal.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/screens/dashboard/DashboardUI.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/inputs.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:coinpay/src/helpers/validation.dart';

class ResetPasswordUI extends StatefulWidget {
  final String code;

  // receive data from the FirstScreen as a parameter
  ResetPasswordUI({Key key, @required this.code}) : super(key: key);

  @override
  _ResetPasswordUIState createState() => _ResetPasswordUIState(this.code);
}

class _ResetPasswordUIState extends State<ResetPasswordUI> {

  final String code;

  _ResetPasswordUIState(this.code);

  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode confirmPasswordFocus;
  FocusNode inputPasswordFocus;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;
  bool status = false;
  bool enable = true;

  bool _obscurePassword = true;

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    confirmPasswordFocus = FocusNode();
    confirmPasswordFocus.addListener(() {
      setState(() {
        print("Has focus: ${confirmPasswordFocus.hasFocus}");
      });
    });
    inputPasswordFocus = FocusNode();
    inputPasswordFocus.addListener(() {
      setState(() {
        print("Has focus: ${inputPasswordFocus.hasFocus}");
      });
    });
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    confirmPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordFocus.dispose();
    inputPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);

    String _validateConfirmPassword(String value) {
      if (isRequired(value)) return "${lang.translate('screen.register.emptyFieldMessage')}" ;

      if (value != passwordController.text) return "${lang.translate('screen.resetPassword.invalidConfirmPassword')}";

      return null;
    }

    String _validatePassword(String value) {
      if (isRequired(value)) return "${lang.translate('screen.register.emptyFieldMessage')}";

      if (value.length < 8) return "${lang.translate('screen.register.invalidLengthPasswordMessage')}";

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
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextTitle(
                    data: "${lang.translate('screen.resetPassword.resetTitle')}",
                    weight: FontWeight.w700,
                    size: Sizes.s31m25,
                    textAlign: TextAlign.left,
                    height: Sizes.s1,
                  ),
                ),
                SizedBox(
                  height: Sizes.s20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextParagraph(
                    data: "${lang.translate('screen.resetPassword.resetSubtitle')}",
                    size: Sizes.s16,
                    weight: FontWeight.w300,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: Sizes.s15,
                ),
                OutlineTextField(
                  obscureText: _obscurePassword,
                  hintText: "${lang.translate('screen.resetPassword.newPasswordHint')}",
                  labelText: "${lang.translate('screen.resetPassword.newPasswordHint')}",
                  hintStyle: TextStyle(fontSize: FontSize.s14),
                  labelStyle: TextStyle(fontSize: FontSize.s14),
                  textInputType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: _obscurePassword
                        ? Icon(FlutterIcons.eye_fea, color: inputHint,)
                        : Icon(FlutterIcons.eye_off_fea, color: inputHint,),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = _obscurePassword ? false : true;
                      });
                    },
                  ),
                  prefixIcon: IconButton(
                      iconSize: Sizes.s24,
                      icon: Icon(
                        FlutterIcons.lock_outline_mdi,
                        color: inputPasswordFocus.hasFocus ? secondaryColor : inputHint,
                      )
                  ),
                  controller: passwordController,
                  validator: _validatePassword,
                  focusNode: inputPasswordFocus,
                ),
                SizedBox(
                  height: Sizes.s15,
                ),
                OutlineTextField(
                  obscureText: _obscurePassword,
                  hintText: "${lang.translate('screen.resetPassword.confirmNewPasswordHint')}",
                  labelText: "${lang.translate('screen.resetPassword.confirmNewPasswordHint')}",
                  hintStyle: TextStyle(fontSize: FontSize.s14),
                  labelStyle: TextStyle(fontSize: FontSize.s14),
                  textInputType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: _obscurePassword
                        ? Icon(FlutterIcons.eye_fea, color: inputHint,)
                        : Icon(FlutterIcons.eye_off_fea, color: inputHint,),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = _obscurePassword ? false : true;
                      });
                    },
                  ),
                  prefixIcon: IconButton(
                      iconSize: Sizes.s24,
                      icon: Icon(
                        FlutterIcons.lock_outline_mdi,
                        color: confirmPasswordFocus.hasFocus ? secondaryColor : inputHint,
                      )
                  ),
                  controller: confirmPasswordController,
                  validator: _validateConfirmPassword,
                  focusNode: confirmPasswordFocus,
                ),
                SizedBox(
                  height: Sizes.s20,
                ),
                Container(
                  height: Sizes.s40,
                  child: ButtonSystemTheme(
                    title: "${lang.translate('screen.resetPassword.submitButton')}",
                    onTap: () async {
                      persistentBottomSheetController = _scaffoldKey.currentState.showBottomSheet((context) =>
                          Container(
                            child: CustomModal.loading(context, "${lang.translate('screen.register.progressMessage')}"),
                          )
                      );
                      final sharedPrefService = await SharedPreferencesService.instance;
                      await Future.delayed(
                        Duration(milliseconds: 5000),
                            () => UserController().run(
                            Routes.RESET_PASSWORD,
                            {
                              "phone": sharedPrefService.phone,
                              "password": passwordController.text,
                              "repeatPassword": confirmPasswordController.text,
                              "code": this.code,
                            }
                        ).then((data) async {
                          print(data);
                          if(data['code'] == 1000){
                            final sharedPrefService = await SharedPreferencesService.instance;
                            await sharedPrefService.setToken(data['token']);
                            openRemovePage(context, DashboardUI());
                          }else {
                            await dialogShow(context, "Oops an error !!!", data['message']);
                          }
                        }).catchError((onError) async{
                          print(onError);
                          await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorMessage')}");
                        }).whenComplete(() => {
                        }),
                      ).whenComplete(() => {
                        persistentBottomSheetController.close(),
                      });
                    },
                    fontSize: FontSize.s16,
                    weight: FontWeight.w500,
                    height: Sizes.s48,
                    width: MediaQuery.of(context).size.width,
                    color: secondaryColor,
                  ),
                ),
                SizedBox(
                  height: Sizes.s30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
