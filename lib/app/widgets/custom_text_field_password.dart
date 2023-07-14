import 'package:crud_flutter/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldPassword extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final bool? visualizar;
  final bool password;
  final Function? onTapPassword;
  final bool obscureText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextFieldPassword(
      {Key? key,
        required this.hintText,
        required this.icon,
        required this.textInputType,
        required this.controller,
        this.password = false,
        this.obscureText = false,
        this.visualizar,
        this.onTapPassword,
        this.validator,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      obscureText: obscureText,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      style: Theme.of(context).textTheme.bodyText2?.copyWith(
        color: black.withOpacity(0.7),
      ),
      textAlign: TextAlign.start,
      cursorColor: darkPurple,
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(
          color: jet.withOpacity(0.7),
        ),
        hintText: hintText,
        filled: true,
        fillColor: lightPurple,
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Icon(icon.icon, color: darkPurple),
        ),
        suffixIcon: password ? GestureDetector(
          onTap: (){
            onTapPassword!();
          },
          child: Icon(
            visualizar! ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: darkPurple,
          ),
        ): null,
        contentPadding:const EdgeInsets.fromLTRB(0, 18, 0, 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 1.18,
            color: Colors.transparent,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 1.2,
            color: Colors.transparent,
          ), //Color(0xff1a1919)
        ),
      ),
    );
  }
}
