import 'package:coinpay/src/helpers/modal.dart';
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
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:coinpay/src/helpers/dialog.dart';

class RegisterUI extends StatefulWidget {
  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode inputFirstNameFocus;
  FocusNode inputLastNameFocus;
  FocusNode inputPhoneFocus;
  FocusNode inputPasswordFocus;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController persistentBottomSheetController;
  bool status = false;
  bool enable = true;
  bool isValidateTermsAndPolicy = false;

  bool _obscurePassword = true;
  Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('237');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    inputFirstNameFocus = FocusNode();
    inputLastNameFocus = FocusNode();
    inputPhoneFocus = FocusNode();
    inputPasswordFocus = FocusNode();
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    inputFirstNameFocus.dispose();
    inputLastNameFocus.dispose();
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
                    data: "${lang.translate('screen.register.title')}",
                    weight: FontWeight.w700,
                    size: Sizes.s31m25,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextParagraph(
                    data: "${lang.translate('screen.register.subtitle')}",
                    size: Sizes.s16,
                    weight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: Sizes.s25,
                ),
                OutlineTextField(
                  hintText:
                  "${lang.translate('screen.register.firstNameHint')}",
                  labelText:
                  "${lang.translate('screen.register.firstNameLabel')}",
                  hintStyle: TextStyle(fontSize: FontSize.s14),
                  labelStyle: TextStyle(fontSize: FontSize.s14),
                  controller: firstNameController,
                  textInputType: TextInputType.text,
                  prefixIcon: Icon(
                    Typicons.user_outline,
                    color: inputHint,
                  ),
                  maxLength: 20,
                  validator: _validateField,
                ),
                SizedBox(
                  height: Sizes.s15,
                ),
                OutlineTextField(
                  hintText:
                  "${lang.translate('screen.register.lastNameHint')}",
                  labelText:
                  "${lang.translate('screen.register.lastNameLabel')}",
                  hintStyle: TextStyle(fontSize: FontSize.s14),
                  labelStyle: TextStyle(fontSize: FontSize.s14),
                  controller: lastNameController,
                  textInputType: TextInputType.text,
                  prefixIcon: Icon(
                    Typicons.user_add_outline,
                    color: inputHint,
                  ),
                  maxLength: 20,
                  validator: _validateField,
                ),
                SizedBox(
                  height: Sizes.s15,
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextParagraph(
                    data: "${lang.translate('screen.register.passwordAlt')}",
                    size: Sizes.s10,
                    weight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: Sizes.s2,
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
                  prefixIcon: Icon(
                    FlutterIcons.lock_outline_mdi,
                    color: inputHint,
                  ),
                  controller: passwordController,
                  validator: _validatePassword,
                ),
                SizedBox(
                  height: Sizes.s20,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: secondaryColor,
                          checkColor: secondaryColor,
                          value: isValidateTermsAndPolicy,
                          onChanged: (value) => {
                            print(value)
                          }
                        ),
                        TextParagraph(
                          data: "${lang.translate('screen.register.agreeAlt')}",
                          size: Sizes.s9,
                          weight: FontWeight.w400,
                        ),
                        InkWell(
                          onTap: () =>{
                            print("Terms of services")
                          },
                          child: TextParagraph(
                            data: "${lang.translate('screen.register.termsOfServicesAlt')}",
                            size: Sizes.s9,
                            weight: FontWeight.w400,
                            color: secondaryColor,
                          ),
                        ),
                        TextParagraph(
                          data: "${lang.translate('screen.register.andAlt')}",
                          size: Sizes.s9,
                          weight: FontWeight.w400,
                        ),
                        InkWell(
                          onTap: () => {
                            print("Privacy Policy")
                          },
                          child: TextParagraph(
                            data: "${lang.translate('screen.register.privacyPolicyAlt')}",
                            size: Sizes.s9,
                            weight: FontWeight.w400,
                            color: secondaryColor,
                          ),
                        ),
                        TextParagraph(
                          data: "${lang.translate('screen.register.foulStop')}",
                          size: Sizes.s9,
                          weight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Sizes.s30,
                ),
                Container(
                  child: ButtonSystemTheme(
                    title: "${lang.translate('screen.register.registerButton')}",
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        persistentBottomSheetController = _scaffoldKey.currentState.showBottomSheet((context) =>
                            Container(
                              child: CustomModal.loading(context, "${lang.translate('screen.register.progressMessage')}"),
                            )
                        );
                        await Future.delayed(
                          Duration(milliseconds: 5000),
                            () async => await UserController().run(Routes.REGISTER,
                                new User(
                                    id: 0,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    phone: _selectedFilteredDialogCountry.phoneCode+phoneController.text,
                                    password: passwordController.text,
                                    avatar: null
                                ).toJson()
                            ).then((data) async {
                              print(data);
                              if(data['code'] == 1000){
                                final sharedPrefService = await SharedPreferencesService.instance;
                                await sharedPrefService.setPhone(_selectedFilteredDialogCountry.phoneCode+phoneController.text);
                                openRemovePage(context, ValidateOtpUI(action: "register"));
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
                  height: Sizes.s70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextParagraph(
                      data: "${lang.translate('screen.register.accountAlt')}",
                      weight: FontWeight.w300,
                      size: Sizes.s14,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => openRemovePage(context, LoginUI()),
                        child: TextParagraph(
                          data : "${lang.translate('screen.register.loginButton')}",
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
