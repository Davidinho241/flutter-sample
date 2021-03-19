import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String userCurrency(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format = NumberFormat.simpleCurrency(locale: locale.toString());
  return format.currencySymbol;
}
