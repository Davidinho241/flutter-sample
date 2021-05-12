import 'dart:convert';

import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/env/routesAuth.dart';
import 'package:coinpay/src/helpers/dialog.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/modal.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/screens/forgot_password/ForgotPassword.dart';
import 'package:coinpay/src/screens/registration/RegisterUI.dart';
import 'package:coinpay/src/screens/validate_otp/ValidateOtpUI.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/common_widgets.dart';
import 'package:coinpay/src/widgets/inputs.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:coinpay/src/helpers/validation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode inputPhoneFocus;
  FocusNode inputPasswordFocus;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;
  bool status = false;
  bool enable = true;
  bool hasError = false;
  String error = "No error";

  bool _obscurePassword = true;
  Country _selectedFilteredDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('237');

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    inputPhoneFocus = FocusNode();
    inputPhoneFocus.addListener(() {
      setState(() {
        print("Has focus: ${inputPhoneFocus.hasFocus}");
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
    phoneController.dispose();
    passwordController.dispose();
    inputPhoneFocus.dispose();
    inputPasswordFocus.dispose();
    super.dispose();
  }

  Widget _buildDialogItem(Country country, {bool showCountryName = true}) =>
      Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 2.0),
          Icon(Icons.keyboard_arrow_down,
            color: inputPhoneFocus.hasFocus ? secondaryColor : defaultTextColor,
          ),
          SizedBox(width: 2.0),
          Image.asset(
            "assets/images/icons/line.png",
            height: Sizes.s25,
          ),
          SizedBox(width: 4.0),
          Text("+${country.phoneCode}",
            style:  GoogleFonts.heebo(
                color: inputPhoneFocus.hasFocus ? secondaryColor : defaultTextColor,
                fontWeight: FontWeight.w500,
                fontSize: FontSize.s14,
                fontStyle: FontStyle.normal
            ),
          ),
          SizedBox(width: 5.0),
          showCountryName ? Flexible(child: Text(country.name)) : Container()
        ],
      );

  void _openFilteredCountryPickerDialog() => showDialog(
      context: context,
      builder: (context) {
        var lang = AppLocalizations.of(context);
        return Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(
              hintText: "${lang.translate('screen.register.searchPhoneHint')}",
            ),
            isSearchable: true,
            title: Text(
              "${lang.translate('screen.register.selectPhoneText')}",
            ),
            onValuePicked: (Country country) =>
                setState(() => _selectedFilteredDialogCountry = country),
            itemBuilder: _buildDialogItem,
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);

    String _validatePhone(String value) {
      Pattern pattern = r'^(?:[+0])?[0-9]{5}|[0-9]{6}|[0-9]{7}|[0-9]{8}|[0-9]{9}|[0-9]{10}$/';
      RegExp regex = new RegExp(pattern);

      if (isRequired(value)) return "${lang.translate('screen.register.emptyFieldMessage')}" ;

      if (!regex.hasMatch(value)) return "${lang.translate('screen.register.invalidLengthPhoneMessage')}";

      return null;
    }

    String _validatePassword(String value) {
      String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);

      if (isRequired(value)) return "${lang.translate('screen.register.emptyFieldMessage')}";

      if (!regExp.hasMatch(value)) return "${lang.translate('screen.register.invalidLengthPasswordMessage')}";

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
                    data: "${lang.translate('screen.login.title')}",
                    weight: FontWeight.w700,
                    size: Sizes.s31m25,
                    textAlign: TextAlign.left,
                    height: Sizes.s1,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextParagraph(
                    data: "${lang.translate('screen.login.subtitle')}",
                    size: Sizes.s16,
                    weight: FontWeight.w300,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: Sizes.s50,
                ),
                hasError ? displayError(context, error: error) : Container(),
                SizedBox(
                  height: Sizes.s30,
                ),
                OutlineTextField(
                  prefixIcon: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: Sizes.s10),
                    width: Sizes.s105,
                    child: InkWell(
                      onTap: _openFilteredCountryPickerDialog,
                      child: _buildDialogItem(
                        _selectedFilteredDialogCountry,
                        showCountryName: false,
                      ),
                    ),
                  ),
                  hintText:
                  "${lang.translate('screen.register.phoneHint')}",
                  labelText:
                  "${lang.translate('screen.register.phoneLabel')}",
                  hintStyle: TextStyle(fontSize: FontSize.s14),
                  labelStyle: TextStyle(fontSize: FontSize.s14),
                  textInputType: TextInputType.phone,
                  controller: phoneController,
                  maxLength: 15,
                  validator: _validatePhone,
                  focusNode: inputPhoneFocus,
                ),
                SizedBox(
                  height: Sizes.s15,
                ),
                OutlineTextField(
                  obscureText: _obscurePassword,
                  hintText: "${lang.translate('screen.register.passwordHint')}",
                  labelText: "${lang.translate('screen.register.passwordLabel')}",
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
                    ),
                    onPressed: null,
                  ),
                  controller: passwordController,
                  validator: _validatePassword,
                  focusNode: inputPasswordFocus,
                ),
                SizedBox(
                  height: Sizes.s10,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () => openRemovePage(context, ForgotPasswordUI()),
                    child: TextParagraph(
                      data: "${lang.translate('screen.login.forgotLabel')}",
                      color: secondaryColor,
                      weight: FontWeight.w500,
                      size: Sizes.s14,
                    ),
                  ),
                ),
                SizedBox(
                  height: Sizes.s20,
                ),
                Container(
                  height: Sizes.s40,
                  child: ButtonSystemTheme(
                    title: "${lang.translate('screen.login.loginButton')}",
                    onTap: () async {
                      setState(() {
                        hasError = false;
                      });
                      if(_formKey.currentState.validate()){
                        persistentBottomSheetController = _scaffoldKey.currentState.showBottomSheet((context) =>
                            Container(
                              child: CustomModal.loading(context, "${lang.translate('screen.register.progressMessage')}"),
                            )
                        );
                        await Future.delayed(
                          Duration(milliseconds: 5000),
                              () => UserController().run(
                              RoutesAuth().buildRoute(RoutesAuth.LOGIN),
                              {
                                "phone": _selectedFilteredDialogCountry.phoneCode+phoneController.text,
                                "password": passwordController.text,
                              }
                          ).then((data) async {
                            print(data);
                            if(data['code'] == 1000 || data['code'] == 1100){
                              final sharedPrefService = await SharedPreferencesService.instance;
                              await sharedPrefService.setPhone(_selectedFilteredDialogCountry.phoneCode+phoneController.text);
                              openRemovePage(context, ValidateOtpUI(action: 'login'));
                            }else if(data['code'] == 1002){
                              setState(() {
                                hasError = true;
                                if (data['data']['password'] != null){
                                  error = data['data']['password']['message'];
                                }
                              });
                            }else {
                              setState(() {
                                hasError = true;
                                error = data['message'];
                              });
                            }
                          }).catchError((onError) async{
                            print(onError);
                            setState(() {
                              hasError = true;
                              error = "${lang.translate('screen.register.errorMessage')}";
                            });
                          }).whenComplete(() => {
                            print('Data receive'),
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
                SizedBox(
                  height: Sizes.s30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextParagraph(data: "${lang.translate('screen.login.noAccountAlt')}"),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => openRemovePage(context, RegisterUI()),
                        child: TextParagraph(
                          data: "${lang.translate('screen.login.registerButton')}",
                          color: secondaryColor,
                          weight: FontWeight.w400,
                          size: Sizes.s14,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
