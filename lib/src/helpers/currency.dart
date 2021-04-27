import 'package:coinpay/src/services/prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String userCurrencySymbol(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.currencySymbol;
}

String userCurrencyName(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.currencyName;
}

double convertBalance(double amount, double rate){
  return amount*rate;
}
