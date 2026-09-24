import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

//  <--------- Local Store --------->
//* TO wrap SharedPreferences with typed JSON helpers so every persisted feature goes through one place
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferencesWithCache _prefs;

  //  <--------- Factory --------->
  //* TO open the cached preferences before the app starts
  static Future<LocalStore> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    return LocalStore(prefs);
  }

  //  <--------- String Access --------->
  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  //!  <--------- Remove Key --------->
  //* TO delete a stored value permanently
  Future<void> remove(String key) => _prefs.remove(key);

  //  <--------- JSON Object Access --------->
  //* TO read a JSON object where corrupt or missing data yields null
  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  //  <--------- JSON List Access --------->
  //* TO read a JSON array of objects where corrupt or missing data yields an empty list
  List<Map<String, dynamic>> getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> setJsonList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

  //!  <--------- Tolerant Parsing --------->
  //* TO map a stored list into objects and skip any entry that fails to parse, so one bad record cannot break a whole feature
  List<T> getJsonObjects<T>(
    String key,
    T Function(Map<String, dynamic> json) parse,
  ) {
    final result = <T>[];
    for (final json in getJsonList(key)) {
      try {
        result.add(parse(json));
      } catch (_) {}
    }
    return result;
  }
}
