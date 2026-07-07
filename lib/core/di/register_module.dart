import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Module to register third-party dependencies with the GetIt locator.
@module
abstract class RegisterModule {
  /// Asynchronously resolve and register SharedPreferences.
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
