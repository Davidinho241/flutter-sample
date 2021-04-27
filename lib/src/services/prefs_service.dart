import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String cryptoCurrency = 'cryptoCurrency';
  static const String currencyCode = 'currencyCode';
  static const String languageCode = 'languageCode';
  static const String token = 'token';
  static const String phone = 'phone';
  static const String userId = 'userId';
  static const String password = 'password';
}

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  void clear(){
    _preferences.clear();
  }

  Future<void> setCryptoCurrency(String currency) async =>
      await _preferences.setString(SharedPrefKeys.cryptoCurrency, currency);

  String get cryptoCurrency =>
      _preferences.getString(SharedPrefKeys.cryptoCurrency) ?? "\$";

  Future<void> setCurrency(String currCode) async =>
      await _preferences.setString(SharedPrefKeys.currencyCode, currCode);

  String get currencyCode =>
      _preferences.getString(SharedPrefKeys.currencyCode) ?? "USD";

  Future<void> setLanguage(String langCode) async =>
      await _preferences.setString(SharedPrefKeys.languageCode, langCode);

  String get languageCode =>
      _preferences.getString(SharedPrefKeys.languageCode);


  Future<void> setToken(String token) async =>
      await _preferences.setString(SharedPrefKeys.token, token);

  String get token =>
      _preferences.getString(SharedPrefKeys.token) ?? "\$";

  Future<void> setPhone(String phone) async =>
      await _preferences.setString(SharedPrefKeys.phone, phone);

  String get phone =>
      _preferences.getString(SharedPrefKeys.phone) ?? "\$";

  Future<void> setUserId(int userId) async =>
      await _preferences.setInt(SharedPrefKeys.userId, userId);

  String get userId =>
      _preferences.getString(SharedPrefKeys.userId) ?? "\$";
}
