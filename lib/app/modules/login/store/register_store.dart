// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:crud_flutter/app/app_store.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/modules/login/repository/login_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStore with _$RegisterStore;

abstract class _RegisterStore with Store {
  _RegisterStore(this.appStore);

  final FirebaseStorage storage = FirebaseStorage.instance;
  final AppStore appStore;

  @observable
  bool passwordHide = true;

  @observable
  bool loading = false;

  @observable
  UserModel userModel = UserModel();

  @observable
  File? file;

  @observable
  String genreValue = "";

  @observable
  String maritalStsValue = "";

  @action
  void viewPassword() => passwordHide = !passwordHide;

  ///Pegar a imagem(câmera/galeria):
  @action
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      File? img = File(image!.path);
      img = await cropImage(imageFile: img);
      file = img;
      Modular.to.pop();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Modular.to.pop();
    }
  }

  @action
  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    return File(croppedImage!.path);
  }

  @action
  Future upload(String path, String email) async {
    File file = File(path);
    try {
      String ref = 'images/img-$email.jpg';
      final img = storage.ref(ref);
      await img.putFile(file);
      return await img.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  List validateFields(UserModel model) {
    if (model.maritalStatus.isEmpty) {
      return [AlertType.info, "Atenção", "Selecione seu Estado Civil."];
    } else if (model.genre.isEmpty) {
      return [AlertType.info, "Atenção", "Selecione seu Gênero."];
    }
    return [true];
  }

  @action
  Future<bool> signUpUser(UserModel model) async {
    final repository = LoginRepository();
    final user = await repository.createAccount(model);
    if (user != null) {
      return await repository.registerUser(model, user);
    } else {
      return false;
    }
  }
}
