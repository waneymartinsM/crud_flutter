import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/modules/home/repository/home_repository.dart';
import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/app/widgets/input_customized.dart';
import 'package:crud_flutter/app/widgets/select_photo_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final controller = Modular.get<HomeStore>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telController = TextEditingController();
  final _repository = HomeRepository();

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });
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
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purple,
        centerTitle: true,
        title: Text(
          'EDITAR PERFIL',
          style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Observer(
        builder: (_) => controller.loading
            ? const Center(child: CircularProgressIndicator(color: purple))
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildUserProfilePhoto(),
                      _buildForm(),
                      _buildButton(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildUserProfilePhoto() {
    return Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
            onTap: () {
              selectPhotoOptions();
            },
            child: Stack(children: [
              SizedBox(
                height: 180,
                width: 180,
                child: Card(
                  elevation: 8,
                  color: white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: controller.file == null
                        ? CachedNetworkImage(
                            filterQuality: FilterQuality.high,
                            color: Colors.black.withOpacity(0.5),
                            colorBlendMode: BlendMode.colorBurn,
                            imageUrl: controller.userModel.userImage.isEmpty
                                ? "https://img.myloview.com.br/posters/user-icon-human-person-symbol-avatar-login-sign-700-258992648.jpg"
                                : controller.userModel.userImage,
                            fit: BoxFit.cover,
                            errorWidget: (
                              context,
                              url,
                              error,
                            ) =>
                                const Icon(Icons.error))
                        : Image.file(
                            controller.file!,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Icon(Icons.camera_alt_outlined,
                      color: Colors.white.withOpacity(0.6), size: 45))
            ])));
  }

  Widget _buildForm() {
    return Column(
      children: [
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.person,
          hintText: 'Nome',
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.text,
          controller: nameController,
        ),
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.email_outlined,
          hintText: 'E-mail',
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.phone,
          hintText: 'Telefone',
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          controller: telController,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: CustomAnimatedButton(
            onTap: () async {
              await _saveChange();
            },
            widhtMultiply: 1,
            height: 45,
            colorText: white,
            color: purple,
            text: "SALVAR ALTERAÇÕES",
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: CustomAnimatedButton(
            onTap: () async {
              Modular.to.navigate('/home');
            },
            widhtMultiply: 1,
            height: 45,
            colorText: black,
            color: Colors.grey.withOpacity(0.2),
            text: "CANCELAR",
          ),
        ),
      ],
    );
  }

  Future _saveChange() async {
    final user = UserModel(
      name: nameController.text,
      email: emailController.text,
      phone: telController.text,
    );
    List result = controller.validateUpdatedFields(user);

    if (result.first == true) {
      setState(() => controller.loading = true);
      if (controller.file != null) {
        _repository.updateUserImage(
            imageFile: controller.file!,
            oldImageUrl: controller.userModel.userImage);
      }
      await _repository.updateUserData(user).then((value) {
        Modular.to.navigate('/home');
      }).catchError((_) {
        alertDialog(context, AlertType.error, 'Erro',
            'Ocorreu um erro ao atualizar perfil. Tente novamente mais tarde.');
      });
      setState(() => controller.loading = false);
    } else {
      alertDialog(context, AlertType.error, 'Erro', result[2]);
    }
  }
}
