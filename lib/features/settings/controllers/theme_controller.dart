import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/storage/local_store.dart';

//  <--------- Theme Controller --------->
//* TO persist the light, dark or system theme preference
class ThemeController extends GetxController {
  ThemeController(this._store);

  //  <--------- Fields --------->
  static const _key = 'theme_mode';

  final LocalStore _store;

  late final Rx<ThemeMode> mode = _restore().obs;

  //  <--------- Restore --------->
  //* TO read the saved mode and fall back to system
  ThemeMode _restore() {
    final stored = _store.getString(_key);
    return ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  //  <--------- Set Mode --------->
  //* TO apply the new mode to the app and save it
  void setMode(ThemeMode next) {
    if (next == mode.value) return;
    mode.value = next;
    Get.changeThemeMode(next);
    _store.setString(_key, next.name);
  }
}
