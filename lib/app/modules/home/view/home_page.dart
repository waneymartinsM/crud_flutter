import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() async {
    await controller.recoverUserData();
    setState(() {
      nameController.text = controller.userModel.name;
      emailController.text = controller.userModel.email;
      telController.text = controller.userModel.phone;
    });
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
            actions: [
              Switch(
                value: controller.appStore.isDark,
                onChanged: (bool value) {
                  controller.appStore.changeTheme();
                },
              ),
            ],
            title: Text(
              AppLocalizations.of(context)!.myProfile.toUpperCase(),
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
    var syne = GoogleFonts.syne(fontSize: 16);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: purple),
              child: Container()),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(AppLocalizations.of(context)!.editProfile, style: syne),
            onTap: () {
              Modular.to.navigate('/home/edit');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_alt_1_rounded),
            title:
                Text(AppLocalizations.of(context)!.deleteAccount, style: syne),
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
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language, style: syne),
            onTap: () => Modular.to.pushNamed('/home/language'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.toGoOut, style: syne),
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
      child: controller.loading
          ? const Center(
              child: Center(child: CircularProgressIndicator(color: purple)))
          : _buildUserData(),
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
          child: Text(AppLocalizations.of(context)!.attention,
              style: GoogleFonts.syne(fontWeight: FontWeight.bold))),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 180,
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.youWantDeleteYourAccount,
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
              text: AppLocalizations.of(context)!.delete.toUpperCase(),
            ),
            const SizedBox(height: 10),
            CustomAnimatedButton(
              onTap: () => Modular.to.pop(),
              widhtMultiply: 1,
              height: 45,
              colorText: black,
              color: grey.withOpacity(0.2),
              text: AppLocalizations.of(context)!.cancel.toUpperCase(),
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
          hintStyle: const TextStyle(color: darkPurple),
          keyboardType: TextInputType.text,
          controller: nameController,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.email_outlined,
          readOnly: true,
          hintText: controller.userModel.email,
          hintStyle: const TextStyle(color: darkPurple),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 10),
        InputCustomized(
          icon: Icons.phone,
          readOnly: true,
          hintText: controller.userModel.phone,
          hintStyle: const TextStyle(color: darkPurple),
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
