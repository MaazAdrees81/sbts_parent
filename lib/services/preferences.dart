import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/credentials_model.dart';

class Preferences extends GetxController {
  static Preferences get I => Get.find<Preferences>();

  late final SharedPreferences _prefs;

  Future<Preferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  static const _kSession = "session";
  static const _kCredentials = "credentials";
  static const _kCookie = "cookie";
  static const _kToken = "token";

  bool getSession() => _prefs.getBool(_kSession) ?? false;
  Future<void> saveSession(bool value) => _prefs.setBool(_kSession, value);

  CredentialsModel? getCredentials() {
    final String? data = _prefs.getString(_kCredentials);
    if (data == null) return null;
    return CredentialsModel.fromJson(jsonDecode(data));
  }

  Future<void> saveCredentials(CredentialsModel credentials) {
    return _prefs.setString(_kCredentials, jsonEncode(credentials.toJson()));
  }

  Future<void> deleteCredentials() => _prefs.remove(_kCredentials);

  String? getCookie() => _prefs.getString(_kCookie);
  Future<void> saveCookie(String cookie) => _prefs.setString(_kCookie, cookie);

  String getToken() => _prefs.getString(_kToken) ?? "";
  Future<void> saveToken(String token) => _prefs.setString(_kToken, token);

  Future<void> deleteUserSession() async {
    await _prefs.remove(_kSession);
    await _prefs.remove(_kCookie);
    await _prefs.remove(_kToken);
  }
}