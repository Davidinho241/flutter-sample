import 'package:flutter/material.dart';

class Routes {
  static final String BASE_URL = 'https://coinpay-auth.herokuapp.com/api/';
  static final String REGISTER = 'auth/register';
  static final String VERIFY_OTP = 'auth/verifyCode';
  static final String LOGIN_VERIFY_OTP = 'auth/login/verify/otp';

  String buildRoute(String route){
    return BASE_URL+route;
  }
}