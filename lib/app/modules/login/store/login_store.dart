import 'package:crud_flutter/app/app_store.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/modules/login/repository/login_repository.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  LoginStoreBase(this.appStore);

  final AppStore appStore;

  @observable
  String email = "";

  @observable
  String password = "";

  @action
  void setEmail(String text) => email = text;

  @action
  void setPassword(String text) => password = text;

  @observable
  bool loading = false;

  @observable
  dynamic result = false;

  @observable
  bool passwordHide = true;

  @action
  void viewPassword() => passwordHide = !passwordHide;

  @computed
  bool get finish => email.isNotEmpty && password.isNotEmpty;

  @action
  Future<bool> signInWithEmailAndPassword(UserModel model) async {
    final repository = LoginRepository();
    final user = await repository.loginUser(model);
    if(user != null){
      return await repository.loginUser(model);
    } else {
      return alertDialog(context, AlertType.info, "ATENÇÃO", result);
      //return false;
    }
  }
}