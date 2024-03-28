import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            Positioned(
              top: 0,
              left: 0,
              width: size.width * 0.3,
              child: Image.asset('assets/images/main_top.png'),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: size.width * 0.2,
              child: Image.asset('assets/images/main_bottom.png'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/chat.svg',
                  height: size.height * 0.50,
                ),
                SizedBox(height: size.height * 0.12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: CustomAnimatedButton(
                    onTap: () {
                      Modular.to.pushNamed('/login/signIn');
                    },
                    widhtMultiply: 1,
                    height: 45,
                    colorText: white,
                    color: purple,
                    text: AppLocalizations.of(context)!.login.toUpperCase(),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notHaveAccountRegister,
                      style:
                          GoogleFonts.syne(color: darkPurple.withOpacity(0.7)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Modular.to.pushNamed('/login/register');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.register,
                        style: GoogleFonts.syne(
                            color: darkPurple, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
