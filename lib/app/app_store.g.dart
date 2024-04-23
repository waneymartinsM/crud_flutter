// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  Computed<bool>? _$isDarkComputed;

  @override
  bool get isDark => (_$isDarkComputed ??=
          Computed<bool>(() => super.isDark, name: 'AppStoreBase.isDark'))
      .value;

  late final _$themeTypeAtom =
      Atom(name: 'AppStoreBase.themeType', context: context);

  @override
  ThemeData? get themeType {
    _$themeTypeAtom.reportRead();
    return super.themeType;
  }

  @override
  set themeType(ThemeData? value) {
    _$themeTypeAtom.reportWrite(value, super.themeType, () {
      super.themeType = value;
    });
  }

  late final _$AppStoreBaseActionController =
      ActionController(name: 'AppStoreBase', context: context);

  @override
  void changeTheme() {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.changeTheme');
    try {
      return super.changeTheme();
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
themeType: ${themeType},
isDark: ${isDark}
    ''';
  }
}
