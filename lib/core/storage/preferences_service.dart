import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PreferencesService handles standard key-value storage using shared_preferences.
@lazySingleton
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyLastSyncTimestamp = 'last_sync_timestamp';

  /// Save theme mode ('light', 'dark', 'system').
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_keyThemeMode, mode);
  }

  /// Read theme mode.
  String getThemeMode([String defaultVal = 'system']) {
    return _prefs.getString(_keyThemeMode) ?? defaultVal;
  }

  /// Save onboarding completed status.
  Future<void> saveOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Read onboarding completed status.
  bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Save last offline sync timestamp.
  Future<void> saveLastSyncTimestamp(int timestampMs) async {
    await _prefs.setInt(_keyLastSyncTimestamp, timestampMs);
  }

  /// Get last offline sync timestamp.
  int? getLastSyncTimestamp() {
    return _prefs.getInt(_keyLastSyncTimestamp);
  }

  /// Clear standard settings.
  Future<void> clear() async {
    await _prefs.clear();
  }
}
