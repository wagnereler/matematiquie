// lib/infrastructure/profile_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePrefs {
  final SharedPreferences _prefs;
  ProfilePrefs(this._prefs);

  static const _kActivePlayerId = 'active_player_id';

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
}
