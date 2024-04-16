import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  ThemeData themeType = ThemeData.light();

  @computed
  bool get isDark => themeType.brightness == Brightness.dark;

  @action
  void changeTheme(){
    if(isDark){
      themeType = ThemeData.light();
    } else {
      themeType = ThemeData.dark();

    }
  }
}
