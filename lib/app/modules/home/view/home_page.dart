import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/modules/home/repository/home_repository.dart';
import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:crud_flutter/app/widgets/input_customized.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/select_photo_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeStore controller = Modular.get();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  final telController = TextEditingController();
  final maritalStsController = TextEditingController();
  final genreController = TextEditingController();
  final _repository = HomeRepository();
  String genreValue = "";
  String maritalStsValue = "";
  bool loading = false;
  File? file;

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      File? img = File(image!.path);
      img = await cropImage(imageFile: img);
      setState(() {
        file = img;
        Modular.to.pop();
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Modular.to.pop();
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
    );
    return File(croppedImage!.path);
  }

  void selectPhotoOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          minChildSize: 0.28,
          maxChildSize: 0.4,
          expand: false,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptions(
                onTap: pickImage,
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Observer(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(
              controller.readOnly ? "MEU PERFIL" : "EDITAR PERFIL",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: controller.readOnly
                ? IconButton(
                    onPressed: () async {
                      controller.recoverUserData();
                      controller.changeReadOnly(false);
                    },
                    color: purple,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.edit),
                  )
                : IconButton(
                    onPressed: () {
                      controller.changeReadOnly(true);
                    },
                    color: purple,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    iconSize: 30,
                    icon: const Icon(Icons.close),
                  ),
            actions: [
              if (controller.readOnly)
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Modular.to.navigate('/login');
                  },
                  color: purple,
                  icon: const Icon(Icons.exit_to_app),
                ),
            ],
          ),
          body: SafeArea(
            child: Observer(
              builder: (_) => controller.loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: Image.network(
                                  controller.userModel.userImage,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            controller.readOnly
                                ? const Text(
                                    "Foto do usuário",
                                    style: TextStyle(
                                      color: purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : GestureDetector(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Alterar foto de perfil",
                                          style: TextStyle(
                                            color: purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      selectPhotoOptions();
                                    },
                                  ),
                            const SizedBox(height: 15),
                            InputCustomized(
                              icon: Icons.person,
                              readOnly: controller.readOnly,
                              hintText: controller.readOnly
                                  ? controller.userModel.name
                                  : "Nome",
                              hintStyle: const TextStyle(
                                color: darkPurple,
                              ),
                              keyboardType: TextInputType.text,
                              controller: nameController,
                            ),
                            const SizedBox(height: 10),
                            InputCustomized(
                              icon: Icons.email_outlined,
                              readOnly: controller.readOnly,
                              hintText: controller.readOnly
                                  ? controller.userModel.email
                                  : "E-mail",
                              hintStyle: const TextStyle(
                                color: darkPurple,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                            ),
                            const SizedBox(height: 10),
                            InputCustomized(
                              icon: Icons.phone,
                              readOnly: controller.readOnly,
                              hintText: controller.readOnly
                                  ? controller.userModel.phone
                                  : "Telefone",
                              hintStyle: const TextStyle(
                                color: darkPurple,
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TelefoneInputFormatter(),
                              ],
                              controller: telController,
                            ),
                            const SizedBox(height: 10),
                            controller.readOnly == false
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 30,
                                    ),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                          const Size(double.maxFinite, 45),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          lightPurple,
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final user = UserModel(
                                          name: nameController.text,
                                          email: emailController.text,
                                          cpf: cpfController.text,
                                          phone: telController.text,
                                          password: passwordController.text,
                                          maritalStatus: maritalStsValue,
                                          genre: genreValue,
                                        );
                                        List result = controller
                                            .validateUpdatedFields(user);

                                        if (result.first == true) {
                                          setState(
                                            () => loading = true,
                                          );
                                          bool result = await _repository
                                              .updateUserData(user);
                                          if (result) {
                                            setState(
                                              () => loading = false,
                                            );
                                          } else {
                                            alertDialog(
                                              context,
                                              AlertType.error,
                                              'Erro',
                                              'Ocorreu um erro ao atualizar perfil!',
                                            );
                                          }
                                        } else {
                                          alertDialog(
                                            context,
                                            AlertType.error,
                                            'Erro',
                                            result[2],
                                          );
                                        }
                                      },
                                      child: const Text(
                                        "Salvar alterações",
                                        style: TextStyle(
                                          color: purple,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      InputCustomized(
                                        icon: Icons.credit_card_rounded,
                                        readOnly: controller.readOnly,
                                        hintText: controller.userModel.cpf,
                                        hintStyle: const TextStyle(
                                          color: darkPurple,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 10),
                                      InputCustomized(
                                        icon: Icons.person_outline_outlined,
                                        readOnly: controller.readOnly,
                                        hintText: controller.userModel.genre,
                                        hintStyle: const TextStyle(
                                          color: darkPurple,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 10),
                                      InputCustomized(
                                        icon: Icons.people,
                                        readOnly: controller.readOnly,
                                        hintText:
                                            controller.userModel.maritalStatus,
                                        hintStyle: const TextStyle(
                                          color: darkPurple,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
