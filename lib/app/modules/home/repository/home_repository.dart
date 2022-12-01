import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_flutter/app/core/firebase_const.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore dataBase = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  ///Recuperar dados do usuário:
  Future recoverUserData() async {
    User user = _auth.currentUser!;
    UserModel loginModel = UserModel();
    DocumentSnapshot snapshot =
        await dataBase.collection(FirebaseConst.usuarios).doc(user.uid).get();
    loginModel = UserModel.fromMap(snapshot.data() as Map);
    return loginModel;
  }

//******************************************************************************

  ///Atualizar dados do usuário:
  Future<bool> updateUserData(UserModel model) async {
    try {
      dataBase
          .collection(FirebaseConst.usuarios)
          .doc(_auth.currentUser!.uid)
          .update({
        "name": model.name,
        "email": model.email,
        "phone": model.phone,
      });
      return true;
    } catch (error) {
      return false;
    }
  }
//******************************************************************************

  ///Atualizar imagem:
  Future<String> updateImage({
    required File file,
    required String path,
    required String userId,
  }) async {
    String imageName = userId + DateTime.now().toString();
    final UploadTask uploadTask =
        storage.ref().child('$path/$imageName').putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

//******************************************************************************

  ///Atualizar imagem do usuário:
  Future<void> updateUserImage(
      {required File imageFile, String? oldImageUrl, int? index}) async {
    String uploadPath = "uploads/updated_image";
    if (oldImageUrl != null) {
      await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();
    }
    final imageLink = await updateImage(
      file: imageFile,
      path: uploadPath,
      userId: _auth.currentUser!.uid,
    );
    await dataBase
        .collection(FirebaseConst.usuarios)
        .doc(_auth.currentUser!.uid)
        .update({"imagem_usuario": imageLink});
  }

//******************************************************************************

  ///Verificar o usuário atual:
  bool checkCurrentUser() {
    User? user = _auth.currentUser;
    return user != null ? true : false;
  }
}
