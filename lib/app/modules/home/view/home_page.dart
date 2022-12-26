import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/modules/home/repository/home_repository.dart';
import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:crud_flutter/app/widgets/input_customized.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/select_photo_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
                onTap: controller.pickImage,
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
                      // Modular.to.push(MaterialPageRoute(builder: (_)=> GabrielPage()));
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
              builder: (_) => loading
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
                            GestureDetector(
                              onTap: () {
                                controller.readOnly
                                    ? null
                                    : selectPhotoOptions();
                              },
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 180,
                                    width: 180,
                                    child: Card(
                                      elevation: 8.0,
                                      color: Colors.white.withOpacity(0.2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(150),
                                        child: controller.file == null
                                            ? CachedNetworkImage(
                                                filterQuality:
                                                    FilterQuality.high,
                                                color: controller.readOnly
                                                    ? null
                                                    : Colors.black
                                                        .withOpacity(0.5),
                                                colorBlendMode:
                                                    BlendMode.colorBurn,
                                                imageUrl: controller.userModel
                                                        .userImage.isEmpty
                                                    ? "https://www.kindpng.com/picc/m/22-223863_no-avatar-png-circle-transparent-png.png"
                                                    : controller
                                                        .userModel.userImage,
                                                fit: BoxFit.cover,
                                                errorWidget: (
                                                  context,
                                                  url,
                                                  error,
                                                ) =>
                                                    const Icon(
                                                  Icons.error,
                                                ),
                                              )
                                            : Image.file(
                                                controller.file!,
                                                filterQuality:
                                                    FilterQuality.high,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                  if (controller.readOnly == false)
                                    Positioned(
                                      right: 0,
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 45,
                                      ),
                                    ),
                                ],
                              ),
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
                                        await _saveChange();
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

  Future _saveChange() async {
    final user = UserModel(
      name: nameController.text,
      email: emailController.text,
      cpf: cpfController.text,
      phone: telController.text,
      password: passwordController.text,
      maritalStatus: maritalStsValue,
      genre: genreValue,
    );
    List result = controller.validateUpdatedFields(user);

    if (result.first == true) {
      setState(() => loading = true);
      if (controller.file != null) {
        _repository.updateUserImage(
          imageFile: controller.file!,
          oldImageUrl: controller.userModel.userImage,
        );
      }
      await _repository.updateUserData(user).then((value) {
        controller.changeReadOnly(true);
      }).catchError((_) {
        alertDialog(
          context,
          AlertType.error,
          'Erro',
          'Ocorreu um erro ao atualizar perfil!',
        );
      });

      setState(() => loading = false);
    } else {
      alertDialog(
        context,
        AlertType.error,
        'Erro',
        result[2],
      );
    }
  }
}
