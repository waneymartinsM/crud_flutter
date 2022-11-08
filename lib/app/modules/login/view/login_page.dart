import 'package:crud_flutter/app/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    width: size.width * 0.6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: TextButton(
                        onPressed: () {
                          Modular.to.pushNamed('/login/signIn');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                          backgroundColor: yellow,
                        ),
                        child: const Text('LOGIN'),
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
                              color: purple, fontWeight: FontWeight.bold),
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

