import 'dart:ui';
import 'package:crud_flutter/app/app_store.dart';
import 'package:crud_flutter/app/modules/home/view/edit_profile_page.dart';
import 'package:crud_flutter/app/modules/home/view/language_select_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../store/home_store.dart';
import '../view/home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore(i.get<AppStore>()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const HomePage()),
    ChildRoute('/edit', child: (_, args) => const EditProfilePage()),
    ChildRoute('/language',
        child: (_, args) =>
            const LanguageSelectPage(selectedLocale: Locale('pt'))),
  ];
}
