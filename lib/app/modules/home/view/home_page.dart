import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_flutter/app/modules/home/repository/home_repository.dart';
import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/app/widgets/input_customized.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String genreValue = "";
  String maritalStsValue = "";

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Observer(
        builder: (_) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: purple,
            elevation: 0,
            title: Text(
              'MEU PERFIL',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
          drawer: _buildDrawer(),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: purple),
              child: Container()),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text('Editar perfil', style: GoogleFonts.syne(fontSize: 16)),
            onTap: () {
              Modular.to.navigate('/home/edit');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_alt_1_rounded),
            title: Text('Excluir conta', style: GoogleFonts.syne(fontSize: 16)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildDeleteAccount();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Sair', style: GoogleFonts.syne(fontSize: 16)),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Modular.to.navigate('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Observer(
        builder: (_) => controller.loading
            ? const Center(
                child: Center(child: CircularProgressIndicator(color: purple)))
            : _buildUserData(),
      ),
    );
  }

  Widget _buildUserData() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildUserPhoto(),
            _buildUserInformation(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccount() {
    return AlertDialog(
      title: Center(
          child: Text('ATENÇÃO',
              style: GoogleFonts.syne(fontWeight: FontWeight.bold))),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          children: [
            Text("Tem certeza que deseja excluir sua conta?",
                textAlign: TextAlign.center,
                style: GoogleFonts.syne(fontSize: 16)),
            const Spacer(),
            CustomAnimatedButton(
              onTap: () async {
                await controller.deleteAccount();
              },
              widhtMultiply: 1,
              height: 45,
              colorText: white,
              color: purple,
              text: "EXCLUIR",
            ),
            const SizedBox(height: 10),
            CustomAnimatedButton(
              onTap: () {
                Modular.to.pop();
              },
              widhtMultiply: 1,
              height: 45,
              colorText: black,
              color: grey.withOpacity(0.2),
              text: "CANCELAR",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPhoto() {
    return Stack(
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: Card(
            elevation: 8.0,
            color: Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(150),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CachedNetworkImage(
                filterQuality: FilterQuality.high,
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
                    const Icon(
                  Icons.error,
                ),
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
    );
  }

  Widget _buildUserInformation() {
    return Column(
      children: [
        const SizedBox(height: 15),
        InputCustomized(
          icon: Icons.person,
          readOnly: true,
          hintText: controller.userModel.name,
          hintStyle: const TextStyle(
            color: darkPurple,
          ),
          keyboardType: TextInputType.text,
          controller: nameController,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.email_outlined,
          readOnly: true,
          hintText: controller.userModel.email,
          hintStyle: const TextStyle(
            color: darkPurple,
          ),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.phone,
          readOnly: true,
          hintText: controller.userModel.phone,
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
        InputCustomized(
          icon: Icons.credit_card_rounded,
          readOnly: true,
          hintText: controller.userModel.cpf,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.person_outline_outlined,
          readOnly: true,
          hintText: controller.userModel.genre,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.people,
          readOnly: true,
          hintText: controller.userModel.maritalStatus,
          hintStyle: GoogleFonts.syne(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
