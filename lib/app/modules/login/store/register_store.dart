import 'dart:io';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/modules/login/repository/login_repository.dart';
import 'package:email_validator/email_validator.dart';
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
  final FirebaseStorage storage = FirebaseStorage.instance;

  @observable
  bool viewPassword = true;

  @action
  void boolViewPassword() => viewPassword = !viewPassword;

  @observable
  UserModel userModel = UserModel();

  @observable
  File? file;

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

  ///Fazer upload da imagem:
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

  ///Validar campos:
  List validateFields(UserModel model) {
    if (model.name.isEmpty) {
      return [AlertType.info, "Atenção", "Insira o seu nome!"];
    } else if (model.email.isEmpty) {
      return [AlertType.info, "Atenção", "Insira o seu e-mail!"];
    } else if (EmailValidator.validate(model.email) == false) {
      return [AlertType.info, "Atenção", "E-mail é inválido!"];
    } else if (CPFValidator.isValid(model.cpf) == false) {
      return [AlertType.info, "Atenção", "CPF inválido!"];
    } else if (model.phone.isEmpty) {
      return [AlertType.info, "Atenção", "Insira seu telefone"];
    } else if (model.phone.length < 13) {
      return [AlertType.info, "Atenção", "Número de telefone inválido!"];
    } else if (model.maritalStatus.isEmpty) {
      return [AlertType.info, "Atenção", "Selecione seu estado civil!"];
    } else if (model.genre.isEmpty) {
      return [AlertType.info, "Atenção", "Selecione seu gênero sexual!"];
    } else if (model.password.isEmpty) {
      return [AlertType.info, "Atenção", "Insira sua senha!"];
    } else if (model.password.length < 7) {
      return [AlertType.info, "Atenção", "Sua senha tem menos de 7 caracteres"];
    }
    return [true];
  }

  ///Cadastrar usuário:
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
