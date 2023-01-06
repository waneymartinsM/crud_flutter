import 'package:crud_flutter/app/modules/login/store/login_store.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    Key? key,
  }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final LoginStore controller = Modular.get();
  final firebaseAuth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                child: Image.asset(
                  'assets/images/main_top.png',
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                width: size.width * 0.2,
                child: Image.asset(
                  'assets/images/main_bottom.png',
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/login.svg',
                    height: size.height * 0.30,
                  ),
                  const SizedBox(height: 15),
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
                      onChanged: controller.setEmail,
                    ),
                  ),
                  Observer(
                    builder: (_) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 12.0,
                      ),
                      child: TextFormField(
                        obscureText: controller.passwordHide,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: purple,
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
                              if (controller.passwordHide == true) {
                                setState(() {
                                  controller.passwordHide = false;
                                });
                              } else {
                                setState(() {
                                  controller.passwordHide = true;
                                });
                              }
                            },
                            icon: Icon(
                              controller.passwordHide == true
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off,
                              color: purple,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Senha",
                        ),
                        controller: passwordController,
                        onChanged: controller.setPassword,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    width: size.width * 0.6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: TextButton(
                        onPressed: () {
                          controller
                              .signInWithEmailAndPassword(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 40,
                          ),
                          backgroundColor: purple,
                        ),
                        child: const Text('ENTRAR'),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Não tem uma conta? ',
                        style: TextStyle(
                          color: purple,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Modular.to.pushNamed('/login/register');
                        },
                        child: const Text(
                          "Registre-se",
                          style: TextStyle(
                            color: purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
