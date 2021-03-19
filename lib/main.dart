import 'package:coinpay/src/helpers/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:coinpay/src/blocs/theme.bloc.dart';
import 'package:coinpay/src/utils/themes.dart';
import 'package:coinpay/src/screens/splashscreen/SplashscreenUI.dart';
import 'package:coinpay/src/blocs/language.bloc.dart';

void main() => runApp(MultiBlocProvider(providers: [
  BlocProvider<ThemeBloc>(
    create: (BuildContext context) => ThemeBloc()..add(ThemeLoadStarted()),
  ),
  BlocProvider<LanguageBloc>(
    create: (BuildContext context) =>
    LanguageBloc()..add(LanguageLoadStarted()),
  ),
], child: App()));

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                locale: languageState.locale,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('en', 'US'),
                ],
                title: 'CoinPay',
                themeMode: themeState.themeMode,
                theme: buildThemeLight(context),
                home: SplashscreenUI(),
              );
            });
      },
    );
  }
}
