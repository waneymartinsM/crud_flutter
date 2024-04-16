import 'package:crud_flutter/app/app_store.dart';
import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/l10n/l10n.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final store = Modular.get<AppStore>();
  final homeStore = Modular.get<HomeStore>();

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    await homeStore.loadSelectedLanguage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("IDIOMA:> ${homeStore.selectedLanguage}");
    return Observer(
      builder: (context) {
        return MaterialApp.router(
          // theme: ThemeData(
          //   primaryColor: purple,
          //   scaffoldBackgroundColor: white,
          // ),
          theme: store.themeType,
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
          supportedLocales: L10n.all,
          locale: homeStore.selectedLanguage,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
