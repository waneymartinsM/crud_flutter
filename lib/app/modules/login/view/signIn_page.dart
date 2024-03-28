// ignore_for_file: use_build_context_synchronously
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/modules/login/store/login_store.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/app/widgets/custom_text_field.dart';
import 'package:crud_flutter/app/widgets/custom_text_field_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validatorless/validatorless.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final controller = Modular.get<LoginStore>();
  final _formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Size size = MediaQuery.of(context).size;
    return Observer(
      builder: (_) => SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              imageTop(size),
              imageBottom(size),
              centerContent(size),
            ],
          ),
        ),
      ),
    );
  }

  Positioned imageTop(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      width: size.width * 0.3,
      child: Image.asset(
        'assets/images/main_top.png',
      ),
    );
  }

  Positioned imageBottom(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      width: size.width * 0.2,
      child: Image.asset(
        'assets/images/main_bottom.png',
      ),
    );
  }

  Column centerContent(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/login.svg', height: size.height * 0.30),
        const SizedBox(height: 20),
        _buildForm(),
        SizedBox(height: size.height * 0.04),
        _buildButtonSignIn(),
        SizedBox(height: size.height * 0.03),
        _buildTextSignUp(),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomTextField(
              hintText: AppLocalizations.of(context)!.email,
              icon: const Icon(Icons.alternate_email_rounded, color: grey),
              textInputType: TextInputType.emailAddress,
              controller: emailController,
              onChange: controller.setEmail,
              validator: Validatorless.multiple([
                Validatorless.required(
                    AppLocalizations.of(context)!.fillFieldWithYourEmail),
                Validatorless.email(AppLocalizations.of(context)!.invalidEmail),
              ]),
            ),
            const SizedBox(height: 20),
            CustomTextFieldPassword(
              hintText: AppLocalizations.of(context)!.password,
              icon: const Icon(Icons.lock_outline_rounded),
              onTapPassword: () {
                controller.viewPassword();
              },
              visualizar: controller.passwordHide,
              password: true,
              obscureText: controller.passwordHide,
              textInputType: TextInputType.visiblePassword,
              controller: passwordController,
              validator: Validatorless.multiple([
                Validatorless.required(
                    AppLocalizations.of(context)!.fillFieldYourPassword),
                Validatorless.min(
                    6,
                    AppLocalizations.of(context)!
                        .passwordMustBeAtLeast6CharactersLong),
                Validatorless.max(
                  20,
                  AppLocalizations.of(context)!
                      .passwordMustBeAtLeast20CharactersLong,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSignIn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: CustomAnimatedButton(
        onTap: () async {
          final isValid = _formKey.currentState?.validate() ?? false;
          final user = UserModel(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          if (isValid) {
            bool result = await controller.signInWithEmailAndPassword(user);
            if (result) {
              Modular.to.navigate('/home');
              setState(() => controller.loading = false);
            } else {
              alertDialog(
                  context,
                  AlertType.error,
                  AppLocalizations.of(context)!.attention.toUpperCase(),
                  AppLocalizations.of(context)!.errorOccurredLoggingAccount);
            }
          }
        },
        widhtMultiply: 1,
        height: 45,
        colorText: white,
        color: purple,
        text: AppLocalizations.of(context)!.enter,
      ),
    );
  }

  Widget _buildTextSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.notHaveAccountRegister,
          style: GoogleFonts.syne(color: darkPurple),
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
    );
  }
}
