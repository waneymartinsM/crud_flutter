import 'dart:io';
import 'package:crud_flutter/app/model/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../repository/home_repository.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _repository = HomeRepository();

  @observable
  bool readOnly = true;

  @action
  changeReadOnly(bool value) => readOnly = value;

  @observable
  bool loading = false;

  @observable
  UserModel userModel = UserModel();

  @observable
  File? file;

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
  recoverUserData() async {
    bool response = _repository.checkCurrentUser();
    if (response) {
      userModel = await _repository.recoverUserData();
    }
  }

  @action
  clearVariables() {
    userModel = UserModel.clean();
  }

  List validateUpdatedFields(UserModel model) {
    if (model.name.isEmpty) {
      return [AlertType.info, "Atenção", "Insira o seu nome!"];
    } else if (model.email.isEmpty) {
      return [AlertType.info, "Atenção", "Insira o seu e-mail!"];
    } else if (EmailValidator.validate(model.email) == false) {
      return [AlertType.info, "Atenção", "Insira um e-mail válido!"];
    } else if (model.phone.isEmpty) {
      return [
        AlertType.info,
        "Atenção",
        "Insira um número de telefone válido para prosseguirmos!",
      ];
    }
    return [true];
  }
}
