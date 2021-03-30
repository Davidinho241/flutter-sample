class Routes {
  static final String BASE_URL = 'https://coinpay-auth.herokuapp.com/api/v1/';
  static final String REGISTER = 'auth/register';
  static final String LOGIN = 'auth/login';
  static final String VERIFY_OTP = 'auth/verifyCode';
  static final String LOGIN_VERIFY_OTP = 'auth/login/verify/otp';
  static final String FORGOT_PASSWORD = '/auth/forgotPassword';
  static final String RESET_PASSWORD = '/auth/resetPassword';
  static final String RESEND_OTP = '/auth/resendCode';

  String buildRoute(String route){
    return BASE_URL+route;
  }
}