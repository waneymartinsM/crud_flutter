import 'package:crud_flutter/app/app_store.dart';
import 'package:crud_flutter/app/modules/login/store/login_store.dart';
import 'package:crud_flutter/app/modules/login/store/register_store.dart';
import 'package:crud_flutter/app/modules/login/view/register_page.dart';
import 'package:crud_flutter/app/modules/login/view/login_page.dart';
import 'package:crud_flutter/app/modules/login/view/signIn_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => LoginStore(i.get<AppStore>())),
    Bind.lazySingleton((i) => RegisterStore(i.get<AppStore>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const LoginPage()),
    ChildRoute('/register', child: (_, args) => const RegisterPage()),
    ChildRoute('/signIn', child: (_, args) => const SignInPage()),
  ];
}
