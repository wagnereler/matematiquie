// lib/application/settings_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../infrastructure/profile_prefs.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  const SettingsState({required this.themeMode});
  SettingsState copyWith({ThemeMode? themeMode}) =>
      SettingsState(themeMode: themeMode ?? this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class SettingsCubit extends Cubit<SettingsState> {
  final ProfilePrefs prefs;
  SettingsCubit({required this.prefs})
      : super(SettingsState(themeMode: _fromCode(prefs.getThemeModeCode())));

  static ThemeMode _fromCode(String? code) {
    switch (code) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String _toCode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await prefs.setThemeModeCode(_toCode(mode));
    emit(state.copyWith(themeMode: mode));
  }
}
