import 'package:coinpay/src/helpers/localization.dart';
import 'package:coinpay/src/helpers/navigation.dart';
import 'package:coinpay/src/helpers/toast.dart';
import 'package:coinpay/src/screens/dashboard/DashboardUI.dart';
import 'package:coinpay/src/screens/registration/RegisterUI.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:coinpay/src/widgets/buttons.dart';
import 'package:coinpay/src/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  bool _obscurePassword = true;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("${lang.translate('screen.login.appBar')}"),
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            color: Colors.transparent,
            onPressed: () => openRemovePage(context, DashboardUI()),
            child: Text(
              "${lang.translate('screen.login.skip')}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(Sizes.s15, Sizes.s15, Sizes.s15, 0),
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              OutlineTextField(
                hintText: "${lang.translate('screen.login.emailHint')}",
                labelText: "${lang.translate('screen.login.emailLabel')}",
                hintStyle: TextStyle(fontSize: FontSize.s14),
                labelStyle: TextStyle(fontSize: FontSize.s14),
              ),
              SizedBox(
                height: Sizes.s15,
              ),
              OutlineTextField(
                obscureText: _obscurePassword,
                hintText: "${lang.translate('screen.login.passwordHint')}",
                labelText: "${lang.translate('screen.login.passwordLabel')}",
                hintStyle: TextStyle(fontSize: FontSize.s14),
                labelStyle: TextStyle(fontSize: FontSize.s14),
                suffixIcon: IconButton(
                  icon: _obscurePassword
                      ? Icon(FlutterIcons.eye_fea)
                      : Icon(FlutterIcons.eye_off_fea),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = _obscurePassword ? false : true;
                    });
                  },
                ),
              ),
              SizedBox(
                height: Sizes.s10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: null,
                  child: Text(
                    "${lang.translate('screen.login.forgotLabel')}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Sizes.s20,
              ),
              Container(
                height: Sizes.s40,
                child: GradientButton(
                  title: "${lang.translate('screen.login.loginButton')}",
                  onTap: () async {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return;
                      },
                    );
                    await Future.delayed(
                      Duration(milliseconds: 2500),
                      () => Navigator.pop(context),
                    );
                    showToast(_scaffoldKey,
                        "${lang.translate('screen.login.loginSuccess')}");
                  },
                  fontSize: FontSize.s14,
                ),
              ),
              SizedBox(
                height: Sizes.s25,
              ),
              Text("${lang.translate('screen.login.loginAlt')}"),
              SizedBox(
                height: Sizes.s10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(right: Sizes.s5),
                      child: ButtonWithIcon(
                        title: "Google",
                        onTap: () =>
                            showToast(_scaffoldKey, "Login with google"),
                        icon: FlutterIcons.google_faw,
                        color: Color(0xffFF6347),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(left: Sizes.s5),
                      child: ButtonWithIcon(
                        title: "Facebook",
                        onTap: () =>
                            showToast(_scaffoldKey, "Login with facebook"),
                        icon: FlutterIcons.facebook_f_faw,
                        color: Color(0xff083d8d),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Sizes.s30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${lang.translate('screen.login.noAccountAlt')}"),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => openRemovePage(context, RegisterUI()),
                      child: Text(
                        "${lang.translate('screen.login.registerButton')}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
