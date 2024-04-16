// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$readOnlyAtom =
      Atom(name: 'HomeStoreBase.readOnly', context: context);

  @override
  bool get readOnly {
    _$readOnlyAtom.reportRead();
    return super.readOnly;
  }

  @override
  set readOnly(bool value) {
    _$readOnlyAtom.reportWrite(value, super.readOnly, () {
      super.readOnly = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: 'HomeStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$userModelAtom =
      Atom(name: 'HomeStoreBase.userModel', context: context);

  @override
  UserModel get userModel {
    _$userModelAtom.reportRead();
    return super.userModel;
  }

  @override
  set userModel(UserModel value) {
    _$userModelAtom.reportWrite(value, super.userModel, () {
      super.userModel = value;
    });
  }

  late final _$fileAtom = Atom(name: 'HomeStoreBase.file', context: context);

  @override
  File? get file {
    _$fileAtom.reportRead();
    return super.file;
  }

  @override
  set file(File? value) {
    _$fileAtom.reportWrite(value, super.file, () {
      super.file = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: 'HomeStoreBase.selectedLanguage', context: context);

  @override
  Locale? get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(Locale? value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$pickImageAsyncAction =
      AsyncAction('HomeStoreBase.pickImage', context: context);

  @override
  Future<dynamic> pickImage(ImageSource source) {
    return _$pickImageAsyncAction.run(() => super.pickImage(source));
  }

  late final _$cropImageAsyncAction =
      AsyncAction('HomeStoreBase.cropImage', context: context);

  @override
  Future<File?> cropImage({required File imageFile}) {
    return _$cropImageAsyncAction
        .run(() => super.cropImage(imageFile: imageFile));
  }

  late final _$recoverUserDataAsyncAction =
      AsyncAction('HomeStoreBase.recoverUserData', context: context);

  @override
  Future recoverUserData() {
    return _$recoverUserDataAsyncAction.run(() => super.recoverUserData());
  }

  late final _$saveSelectedLanguageAsyncAction =
      AsyncAction('HomeStoreBase.saveSelectedLanguage', context: context);

  @override
  Future<void> saveSelectedLanguage() {
    return _$saveSelectedLanguageAsyncAction
        .run(() => super.saveSelectedLanguage());
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  dynamic changeReadOnly(bool value) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.changeReadOnly');
    try {
      return super.changeReadOnly(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearVariables() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.clearVariables');
    try {
      return super.clearVariables();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateLanguage(Locale newLanguage) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.updateLanguage');
    try {
      return super.updateLanguage(newLanguage);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
readOnly: ${readOnly},
loading: ${loading},
userModel: ${userModel},
file: ${file},
selectedLanguage: ${selectedLanguage}
    ''';
  }
}
