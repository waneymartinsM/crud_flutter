import 'package:crud_flutter/app/app_store.dart';
import 'package:crud_flutter/app/modules/auth/module/auth_module.dart';
import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/app/modules/login/module/login_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/home/module/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AppStore()),
    Bind.lazySingleton((i) => HomeStore(i.get<AppStore>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: AuthModule()),
    ModuleRoute('/home', module: HomeModule()),
    ModuleRoute('/login', module: LoginModule()),
  ];
}
