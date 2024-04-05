import 'package:crud_flutter/app/modules/auth/service/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final AuthService _authService = AuthService();

  ///Verificar usuário logado:
  verifyLoggedUser() {
    final loggedUser = _authService.checkCurrentUser();
    if (loggedUser) {
      Modular.to.navigate('/home');
    } else {
      Modular.to.navigate('/login');
    }
  }
}
