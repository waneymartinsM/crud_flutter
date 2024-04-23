import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  ThemeData? themeType;

  @computed
  bool get isDark => themeType?.brightness == Brightness.dark;

  @action
  void changeTheme() {
    if (isDark) {
      themeType = ThemeData.light();
    } else {
      themeType = ThemeData.dark();
    }
    saveThemePreferences();
  }

  void saveThemePreferences() {
    SharedPreferences.getInstance().then((value) {
      value.setBool('isDark', isDark);
    });
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDark') && prefs.getBool('isDark')!) {
      themeType = ThemeData.dark();
    } else {
      themeType = ThemeData.light();
    }
  }
}
