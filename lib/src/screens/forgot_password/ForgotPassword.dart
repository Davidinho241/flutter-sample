import 'package:coinpay/src/controllers/UserController.dart';
import 'package:coinpay/src/env/routes.dart';
import 'package:coinpay/src/helpers/dialog.dart';
import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/screens/registration/RegisterUI.dart';
import 'package:coinpay/src/screens/validate_otp/ValidateOtpUI.dart';
import 'package:coinpay/src/services/prefs_service.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/inputs.dart';
import 'package:coinpay/src/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:coinpay/src/helpers/validation.dart';

class ForgotPasswordUI extends StatefulWidget {
  @override
  _ForgotPasswordUIState createState() => _ForgotPasswordUIState();
}

class _ForgotPasswordUIState extends State<ForgotPasswordUI> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode inputPhoneFocus;
  FocusNode inputPasswordFocus;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool status = false;
  bool enable = true;

  bool _obscurePassword = true;
  Country _selectedFilteredDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('237');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    inputPhoneFocus = FocusNode();
    inputPasswordFocus = FocusNode();
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
          Icon(Icons.keyboard_arrow_down),
          SizedBox(width: 5.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
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

    String _validateField(String value) {
      if (isRequired(value)) return "${lang.translate('screen.register.emptyFieldMessage')}";

      if (value.length < 3) return "${lang.translate('screen.register.invalidLengthFieldMessage')}";

      return null;
    }

    String _validatePhone(String value) {
      if (isRequired(value)) return "${lang.translate('screen.register.emptyFieldMessage')}" ;

      if (value.length < 9) return "${lang.translate('screen.register.invalidLengthPhoneMessage')}";

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
                    data: "${lang.translate('screen.login.title')}",
                    weight: FontWeight.w700,
                    size: Sizes.s31m25,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextParagraph(
                    data: "${lang.translate('screen.login.subtitle')}",
                    size: Sizes.s16,
                    weight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: Sizes.s25,
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: _openFilteredCountryPickerDialog,
                      child: _buildDialogItem(
                        _selectedFilteredDialogCountry,
                        showCountryName: false,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: OutlineTextField(
                        hintText:
                        "${lang.translate('screen.register.phoneHint')}",
                        labelText:
                        "${lang.translate('screen.register.phoneLabel')}",
                        hintStyle: TextStyle(fontSize: FontSize.s14),
                        labelStyle: TextStyle(fontSize: FontSize.s14),
                        textInputType: TextInputType.phone,
                        controller: phoneController,
                        maxLength: 9,
                        validator: _validatePhone,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Sizes.s20,
                ),
                Container(
                  height: Sizes.s40,
                  child: ButtonSystemTheme(
                    title: "${lang.translate('screen.login.loginButton')}",
                    onTap: () async {
                      showModalBottomSheet<void>(
                        context: this.context,
                        backgroundColor: Colors.transparent,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return LinearProgressIndicator();
                        },
                      );
                      await Future.delayed(
                        Duration(milliseconds: 5000),
                            () => UserController().run(
                            Routes.FORGOT_PASSWORD,
                            {
                              "phone": _selectedFilteredDialogCountry.phoneCode+phoneController.text,
                            }
                        ).then((data) async {
                          print(data);
                          if(data['code'] == 1000){
                            final sharedPrefService = await SharedPreferencesService.instance;
                            await sharedPrefService.setPhone(_selectedFilteredDialogCountry.phoneCode+phoneController.text);
                            Navigator.pop(context);
                            openRemovePage(context, ValidateOtpUI(action: "forgot_password"));
                          }else if(data['code'] == 1002){
                            await dialogShow(context, "Oops an error !!!", "${lang.translate('screen.register.errorPhoneValidation')}");
                            Navigator.pop(context);
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