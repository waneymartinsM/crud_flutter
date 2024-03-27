// ignore_for_file: constant_identifier_names
import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("pt", LocaleData.BR),
  MapLocale("en", LocaleData.US),
  MapLocale("es", LocaleData.ES),
];

mixin LocaleData {
  static const String login = 'login';
  static const String NotHaveAccountRegister = 'NotHaveAccountRegister';
  static const String register = 'register';

  static const Map<String, dynamic> BR = {
    login: 'Login',
    NotHaveAccountRegister: 'Não tem uma conta? ',
    register: 'Registre-se',
  };

  static const Map<String, dynamic> US = {
    login: 'Login',
    NotHaveAccountRegister: 'Don\'t have an account? ',
    register: 'Register',
  };

  static const Map<String, dynamic> ES = {
    login: 'Acceso',
    NotHaveAccountRegister: '¿No tienes una cuenta? ',
    register: 'Registro',
  };
}
