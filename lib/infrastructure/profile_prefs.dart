// lib/infrastructure/profile_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePrefs {
  final SharedPreferences _prefs;
  ProfilePrefs(this._prefs);

  static const _kActivePlayerId = 'active_player_id';
  static const _kThemeMode = 'theme_mode'; // 'system' | 'light' | 'dark'

  int? getActivePlayerId() {
    final v = _prefs.getInt(_kActivePlayerId);
    return v;
  }

  Future<void> setActivePlayerId(int id) async {
    await _prefs.setInt(_kActivePlayerId, id);
  }

  Future<void> clearActivePlayerId() async {
    await _prefs.remove(_kActivePlayerId);
  }

  // ===== Tema do app (persistido como string p/ não acoplar à UI)
  String getThemeModeCode() {
    return _prefs.getString(_kThemeMode) ?? 'system';
  }

  Future<void> setThemeModeCode(String code) async {
    await _prefs.setString(_kThemeMode, code);
  }
}
