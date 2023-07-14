// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterStore on _RegisterStore, Store {
  late final _$passwordHideAtom =
      Atom(name: '_RegisterStore.passwordHide', context: context);

  @override
  bool get passwordHide {
    _$passwordHideAtom.reportRead();
    return super.passwordHide;
  }

  @override
  set passwordHide(bool value) {
    _$passwordHideAtom.reportWrite(value, super.passwordHide, () {
      super.passwordHide = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_RegisterStore.loading', context: context);

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
      Atom(name: '_RegisterStore.userModel', context: context);

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

  late final _$fileAtom = Atom(name: '_RegisterStore.file', context: context);

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

  late final _$genreValueAtom =
      Atom(name: '_RegisterStore.genreValue', context: context);

  @override
  String get genreValue {
    _$genreValueAtom.reportRead();
    return super.genreValue;
  }

  @override
  set genreValue(String value) {
    _$genreValueAtom.reportWrite(value, super.genreValue, () {
      super.genreValue = value;
    });
  }

  late final _$maritalStsValueAtom =
      Atom(name: '_RegisterStore.maritalStsValue', context: context);

  @override
  String get maritalStsValue {
    _$maritalStsValueAtom.reportRead();
    return super.maritalStsValue;
  }

  @override
  set maritalStsValue(String value) {
    _$maritalStsValueAtom.reportWrite(value, super.maritalStsValue, () {
      super.maritalStsValue = value;
    });
  }

  late final _$pickImageAsyncAction =
      AsyncAction('_RegisterStore.pickImage', context: context);

  @override
  Future<dynamic> pickImage(ImageSource source) {
    return _$pickImageAsyncAction.run(() => super.pickImage(source));
  }

  late final _$cropImageAsyncAction =
      AsyncAction('_RegisterStore.cropImage', context: context);

  @override
  Future<File?> cropImage({required File imageFile}) {
    return _$cropImageAsyncAction
        .run(() => super.cropImage(imageFile: imageFile));
  }

  late final _$uploadAsyncAction =
      AsyncAction('_RegisterStore.upload', context: context);

  @override
  Future<dynamic> upload(String path, String email) {
    return _$uploadAsyncAction.run(() => super.upload(path, email));
  }

  late final _$signUpUserAsyncAction =
      AsyncAction('_RegisterStore.signUpUser', context: context);

  @override
  Future<bool> signUpUser(UserModel model) {
    return _$signUpUserAsyncAction.run(() => super.signUpUser(model));
  }

  late final _$_RegisterStoreActionController =
      ActionController(name: '_RegisterStore', context: context);

  @override
  void viewPassword() {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
        name: '_RegisterStore.viewPassword');
    try {
      return super.viewPassword();
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
passwordHide: ${passwordHide},
loading: ${loading},
userModel: ${userModel},
file: ${file},
genreValue: ${genreValue},
maritalStsValue: ${maritalStsValue}
    ''';
  }
}
