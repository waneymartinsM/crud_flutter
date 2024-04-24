import 'package:crud_flutter/app/modules/login/store/login_store.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Modular.get<LoginStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            imageTop(size),
            imageBottom(size),
            centerContent(size, context),
          ],
        ),
      ),
    );
  }

  Positioned imageTop(Size size) {
    return Positioned(
        top: 0,
        left: 0,
        width: size.width * 0.3,
        child: Image.asset('assets/images/main_top.png'));
  }

  Positioned imageBottom(Size size) {
    return Positioned(
        bottom: 0,
        left: 0,
        width: size.width * 0.2,
        child: Image.asset('assets/images/main_bottom.png'));
  }

  SvgPicture imageCenter(Size size) {
    return SvgPicture.asset('assets/images/chat.svg',
        height: size.height * 0.50);
  }

  Widget centerContent(Size size, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        imageCenter(size),
        SizedBox(height: size.height * 0.12),
        buttonLogin(context),
        SizedBox(height: size.height * 0.03),
        textNotHaveAccountRegister(context),
      ],
    );
  }

  Padding buttonLogin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: CustomAnimatedButton(
        onTap: () => Modular.to.pushNamed('/login/signIn'),
        widhtMultiply: 1,
        height: 45,
        colorText: white,
        color: purple,
        text: AppLocalizations.of(context)!.login.toUpperCase(),
      ),
    );
  }

  Widget textNotHaveAccountRegister(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.notHaveAccountRegister,
          style: GoogleFonts.syne(
              color: controller.appStore.isDark
                  ? white
                  : darkPurple.withOpacity(0.7)),
        ),
        GestureDetector(
          onTap: () => Modular.to.pushNamed('/login/register'),
          child: Text(
            AppLocalizations.of(context)!.register,
            style: GoogleFonts.syne(
              color: controller.appStore.isDark ? white : darkPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
