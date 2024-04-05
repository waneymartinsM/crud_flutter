import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/l10n/l10n.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final homeStore = Modular.get<HomeStore>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Locale>(
        future: _loadSelectedLanguage(),
        builder: (context, snapshot) {
          Locale selectedLocale = snapshot.data ?? const Locale('pt');
          return MaterialApp.router(
            theme:
                ThemeData(primaryColor: purple, scaffoldBackgroundColor: white),
            routeInformationParser: Modular.routeInformationParser,
            routerDelegate: Modular.routerDelegate,
            supportedLocales: L10n.all,
            locale: selectedLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
          );
        });
  }

  Future<Locale> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selectedLanguage');
    if (languageCode != null) {
      setState(() {

      });
      return Locale(languageCode);
    } else {
      return WidgetsBinding.instance.window.locale;
    }
  }
}
