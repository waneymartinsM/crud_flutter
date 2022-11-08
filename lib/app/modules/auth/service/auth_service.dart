import 'package:firebase_auth/firebase_auth.dart';

///Verificar o usuário atual:
class AuthSevice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool checkCurrentUser() {
    User? user = _auth.currentUser;
    return user != null ? true : false;
  }
}
