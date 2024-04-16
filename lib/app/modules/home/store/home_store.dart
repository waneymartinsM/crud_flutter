import 'dart:io';
import 'package:crud_flutter/app/app_store.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/home_repository.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  HomeStoreBase(this.appStore);

  final AppStore appStore;
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

  @observable
  Locale? selectedLanguage;

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

  Future<bool> deleteAccount() async {
    bool success = await _repository.deleteAccount();
    if (success) {
      Modular.to.navigate('/login');
    } else {
      alertDialog(context, AlertType.error, "ATENÇÃO",
          'Ocorreu um erro ao deletar conta, tente novamente mais tarde!');
    }
    return success;
  }

  Future<void> loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selectedLanguageCode');
    if (languageCode != null) {
      selectedLanguage = Locale(languageCode);
    } else {
      selectedLanguage = WidgetsBinding.instance.window.locale;
    }
  }

  @action
  void updateLanguage(Locale newLanguage) {
    selectedLanguage = newLanguage;
  }

  @action
  Future<void> saveSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'selectedLanguageCode', selectedLanguage!.languageCode);
  }

}
