// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterStore on _RegisterStore, Store {
  late final _$viewPasswordAtom =
      Atom(name: '_RegisterStore.viewPassword', context: context);

  @override
  bool get viewPassword {
    _$viewPasswordAtom.reportRead();
    return super.viewPassword;
  }

  @override
  set viewPassword(bool value) {
    _$viewPasswordAtom.reportWrite(value, super.viewPassword, () {
      super.viewPassword = value;
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

  late final _$_RegisterStoreActionController =
      ActionController(name: '_RegisterStore', context: context);

  @override
  void boolViewPassword() {
    final _$actionInfo = _$_RegisterStoreActionController.startAction(
        name: '_RegisterStore.boolViewPassword');
    try {
      return super.boolViewPassword();
    } finally {
      _$_RegisterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
viewPassword: ${viewPassword},
userModel: ${userModel},
file: ${file}
    ''';
  }
}
