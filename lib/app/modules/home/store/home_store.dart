import 'dart:io';
import 'package:crud_flutter/app/model/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  XFile? file;

  @action
  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future upload(String path, String cpf) async {
    File file = File(path);
    try {
      String ref = 'images/img-$cpf.jpg';
      final img = storage.ref(ref);
      await img.putFile(file);
      return await img.getDownloadURL();

    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  @action
  recoverUserData() async {
    bool response = _repository.checkCurrentUser();
    if(response){
      userModel = await _repository.recoverUserData();
    }
  }

  @action
  clearVariables(){
    userModel = UserModel.clean();
  }


  ///Validar campos de atualizações
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
        "Insira um número de telefone válido para prosseguirmos!"
      ];
    }
    return [true];
  }
}
