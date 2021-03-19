import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState(this.themeMode) : assert(themeMode != null);

  @override
  List<Object> get props => [themeMode];
}

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final bool value;

  ThemeChanged(this.value) : assert(value != null);

  @override
  List<Object> get props => [value];
}

class ThemeLoadStarted extends ThemeEvent {}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.light));

  ThemeState get initialState => ThemeState(ThemeMode.light);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeLoadStarted) {
      yield* _mapThemeLoadStartedToState();
    } else if (event is ThemeChanged) {
      yield* _mapThemeChangedToState(event.value);
    }
  }

  Stream<ThemeState> _mapThemeLoadStartedToState() async* {
    yield ThemeState(ThemeMode.light);
  }

  Stream<ThemeState> _mapThemeChangedToState(bool value) async* {
    yield ThemeState(ThemeMode.light);
  }
}
