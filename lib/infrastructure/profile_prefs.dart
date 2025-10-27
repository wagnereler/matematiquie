// lib/infrastructure/profile_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePrefs {
  static const _keyActivePlayerId = 'active_player_id';

  final SharedPreferences prefs;
  ProfilePrefs(this.prefs);

  int? getActivePlayerId() {
    return prefs.getInt(_keyActivePlayerId);
  }

  Future<void> setActivePlayerId(int id) async {
    await prefs.setInt(_keyActivePlayerId, id);
  }

  Future<void> clearActivePlayerId() async {
    await prefs.remove(_keyActivePlayerId);
  }
}
