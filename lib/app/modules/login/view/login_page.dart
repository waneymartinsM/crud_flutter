import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FlutterLocalization _flutterLocalization;

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
  }

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
                    text: LocaleData.login.getString(context).toUpperCase(),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleData.NotHaveAccountRegister.getString(context),
                      style:
                          GoogleFonts.syne(color: darkPurple.withOpacity(0.7)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Modular.to.pushNamed('/login/register');
                      },
                      child: Text(
                        LocaleData.register.getString(context),
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

//Adicionar dropdown:
// variavel:   late String _currentLocale;
//
// no initState:
// @override
//   void initState() {
//     super.initState();
//     _currentLocale = _flutterLocalization.currentLocale!.languageCode;
//   }

//      DropdownButton(
//             value: _currentLocale,
//             items: const [
//               DropdownMenuItem(
//                 value: "en",
//                 child: Text("English"),
//               ),
//               DropdownMenuItem(
//                 value: "de",
//                 child: Text("German"),
//               ),
//               DropdownMenuItem(
//                 value: "zh",
//                 child: Text("Chinese"),
//               ),
//             ],
//             onChanged: (value) {
//               _setLocale(value);
//             },
//           ),

// void _setLocale(String? value) {
//     if (value == null) return;
//     if (value == "en") {
//       _flutterLocalization.translate("en");
//     } else if (value == "de") {
//       _flutterLocalization.translate("de");
//     } else if (value == "zh") {
//       _flutterLocalization.translate("zh");
//     } else {
//       return;
//     }
//     setState(() {
//       _currentLocale = value;
//     });
//   }
