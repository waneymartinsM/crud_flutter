import 'dart:io';
import 'package:crud_flutter/app/modules/login/store/register_store.dart';
import 'package:crud_flutter/app/widgets/select_photo_options.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterStore controller = Modular.get();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  final telController = TextEditingController();
  File? file;
  String genreValue = "";
  String maritalStsValue = "";
  bool loading = false;
  bool passwordHide = true;

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
    Size size = MediaQuery.of(context).size;
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Modular.to.pushNamed('/login');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: purple,
            ),
          ),
        ),
        body: loading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: purple,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   child: Center(
                    //     child: controller.file == null
                    //         ? const CircleAvatar(
                    //             radius: 60,
                    //             backgroundColor: lightPurple,
                    //             child: Icon(
                    //               Icons.camera_alt_outlined,
                    //               size: 40,
                    //               color: purple,
                    //             ),
                    //           )
                    //         : CircleAvatar(
                    //             radius: 60,
                    //             backgroundImage: FileImage(
                    //               controller.pickAndUploadImage(),
                    //             ),
                    //           ),
                    //   ),
                    //   onTap: () {
                    //     FocusScope.of(context).unfocus();
                    //     controller.getImage();
                    //   },
                    // ),
                    GestureDetector(
                      child: Center(
                        child: controller.file == null
                            ? const CircleAvatar(
                                radius: 60,
                                backgroundColor: lightPurple,
                                child: Icon(
                                  Icons.photo_camera_outlined,
                                  size: 50,
                                  color: purple,
                                ),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(
                                  file!,
                                ),
                              ),
                      ),
                      onTap: () {
                        selectPhotoOptions();
                      },
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Adicionar uma foto de perfil",
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 12.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightPurple,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: purple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Nome",
                        ),
                        cursorColor: purple,
                        controller: nameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 12.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightPurple,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: purple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "E-mail",
                        ),
                        cursorColor: purple,
                        controller: emailController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 12.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightPurple,
                          prefixIcon: const Icon(
                            Icons.credit_card_rounded,
                            color: purple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "CPF",
                        ),
                        cursorColor: purple,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter(),
                        ],
                        controller: cpfController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 12.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightPurple,
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: purple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Telefone",
                        ),
                        cursorColor: purple,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        controller: telController,
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          "Estado civil",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: purple,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            "Casado(a)",
                          ),
                          leading: Radio(
                              value: "Casado(a)",
                              groupValue: maritalStsValue,
                              activeColor: purple,
                              onChanged: (value) {
                                setState(() {
                                  maritalStsValue = value as String;
                                });
                              }),
                        ),
                        ListTile(
                          title: const Text(
                            "Solteiro(a)",
                          ),
                          leading: Radio(
                              value: "Solteiro(a)",
                              groupValue: maritalStsValue,
                              activeColor: purple,
                              onChanged: (value) {
                                setState(() {
                                  maritalStsValue = value as String;
                                });
                              }),
                        ),
                        ListTile(
                          title: const Text(
                            "Divorciado(a)",
                          ),
                          leading: Radio(
                              value: "Divorciado(a)",
                              groupValue: maritalStsValue,
                              activeColor: purple,
                              onChanged: (value) {
                                setState(() {
                                  maritalStsValue = value as String;
                                });
                              }),
                        ),
                        ListTile(
                          title: const Text(
                            "Viúvo(a)",
                          ),
                          leading: Radio(
                              value: "Viúvo(a)",
                              groupValue: maritalStsValue,
                              activeColor: purple,
                              onChanged: (value) {
                                setState(() {
                                  maritalStsValue = value as String;
                                });
                              }),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Sexo",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: purple,
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            "Masculino",
                          ),
                          leading: Radio(
                              value: "Masculino",
                              groupValue: genreValue,
                              activeColor: purple,
                              onChanged: (value) {
                                setState(() {
                                  genreValue = value as String;
                                });
                              }),
                        ),
                        ListTile(
                          title: const Text(
                            "Feminino",
                          ),
                          leading: Radio(
                              value: "Feminino",
                              groupValue: genreValue,
                              activeColor: purple,
                              onChanged: (value) {
                                setState(() {
                                  genreValue = value as String;
                                });
                              }),
                        ),
                        ListTile(
                          title: const Text("Outro(s)"),
                          leading: Radio(
                              value: "Outro(s)",
                              groupValue: genreValue,
                              activeColor: purple,
                              onChanged: (value) {
                                setState(() {
                                  genreValue = value as String;
                                });
                              }),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 12.0,
                      ),
                      child: TextFormField(
                        obscureText: passwordHide,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: lightPurple,
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            color: purple,
                          ),
                          suffixIcon: IconButton(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                if (passwordHide == true) {
                                  setState(() {
                                    passwordHide = false;
                                  });
                                } else {
                                  setState(() {
                                    passwordHide = true;
                                  });
                                }
                              },
                              icon: Icon(
                                passwordHide == true
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off,
                                color: purple,
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Senha",
                        ),
                        cursorColor: purple,
                        controller: passwordController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      width: size.width * 0.6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: TextButton(
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
                            List result = controller.validateFields(user);

                            if (result.first == true) {
                              setState(
                                () => loading = true,
                              );

                              String url = '';
                              if (file != null) {
                                url = await controller.upload(
                                  file!.path,
                                  user.email,
                                );
                              }
                              user.userImage = url;

                              bool result = await controller.signUpUser(user);
                              if (result) {
                                Modular.to.navigate('/home');
                                setState(
                                  () => loading = false,
                                );
                              } else {
                                alertDialog(
                                  context,
                                  AlertType.error,
                                  'ATENÇÃO',
                                  'Usuário já existe!\n Tente novamente.',
                                );
                              }
                            } else {
                              final info = result[0];
                              final title = result[1];
                              final description = result[2];
                              alertDialog(
                                context,
                                info,
                                title,
                                description,
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40,
                            ),
                            backgroundColor: purple,
                          ),
                          child: const Text(
                            'REGISTRAR',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
