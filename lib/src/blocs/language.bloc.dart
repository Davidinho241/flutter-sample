import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coinpay/src/services/prefs_service.dart';

enum Language { EN, FR }

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageLoadStarted extends LanguageEvent {}

class LanguageSelected extends LanguageEvent {
  final Language languageCode;

  LanguageSelected(this.languageCode) : assert(languageCode != null);

  @override
  List<Object> get props => [languageCode];
}

class LanguageState extends Equatable {
  final Locale locale;
  const LanguageState(this.locale) : assert(locale != null);

  @override
  List<Object> get props => [locale];
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(Locale('en', 'US')));

  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is LanguageLoadStarted) {
      yield* _mapLanguageLoadStartedToState();
    } else if (event is LanguageSelected) {
      yield* _mapLanguageSelectedToState(event.languageCode);
    }
  }

  Stream<LanguageState> _mapLanguageLoadStartedToState() async* {
    final sharedPrefService = await SharedPreferencesService.instance;

    final defaultLanguageCode = sharedPrefService.languageCode;
    Locale locale;

    if (defaultLanguageCode == null) {
      locale = Locale('en', 'US');
      await sharedPrefService.setLanguage(locale.languageCode);
    } else {
      locale = Locale(defaultLanguageCode);
    }

    yield LanguageState(locale);
  }

  Stream<LanguageState> _mapLanguageSelectedToState(
      Language selectedLanguage) async* {
    final sharedPrefService = await SharedPreferencesService.instance;

    if (selectedLanguage == Language.FR) {
      yield* _loadLanguage(sharedPrefService, 'fr', 'FR');
    } else if (selectedLanguage == Language.EN) {
      yield* _loadLanguage(sharedPrefService, 'en', 'US');
    }
  }

  /// This method is added to reduce code repetition.
  Stream<LanguageState> _loadLanguage(
      SharedPreferencesService sharedPreferencesService,
      String languageCode,
      String countryCode) async* {
    final locale = Locale(languageCode, countryCode);
    await sharedPreferencesService.setLanguage(locale.languageCode);
    yield LanguageState(locale);
  }
}
