// ignore_for_file: use_build_context_synchronously
import 'package:crud_flutter/app/modules/login/store/register_store.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/app/widgets/custom_text_field.dart';
import 'package:crud_flutter/app/widgets/custom_text_field_password.dart';
import 'package:crud_flutter/app/widgets/select_photo_options.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:crud_flutter/app/model/user.dart';
import 'package:crud_flutter/app/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:validatorless/validatorless.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = Modular.get<RegisterStore>();
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final name = TextEditingController();
  final email = TextEditingController();
  final cpf = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();

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
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: controller.loading == true
            ? const Center(child: CircularProgressIndicator(color: purple))
            : _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildArrowBackIcon(),
          _buildAddPhoto(),
          const SizedBox(height: 10),
          _buildAddPhotoText(),
          const SizedBox(height: 20),
          _buildForm(),
        ],
      ),
    );
  }

  Align _buildArrowBackIcon() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 10),
        child: IconButton(
          onPressed: () => Modular.to.pushNamed('/login'),
          icon: Icon(Icons.arrow_back_ios_new_outlined,
              color: controller.appStore.isDark ? white : darkPurple),
        ),
      ),
    );
  }

  Widget _buildAddPhoto() {
    return GestureDetector(
      child: Center(
          child: controller.file == null
              ? CircleAvatar(
                  radius: 60,
                  backgroundColor: lightPurple,
                  child: Image.asset('assets/images/camera.png',
                      color: darkPurple),
                )
              : CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(controller.file!),
                )),
      onTap: () => selectPhotoOptions(),
    );
  }

  Widget _buildAddPhotoText() {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.addProfilePhoto,
            style: GoogleFonts.syne(
              color: controller.appStore.isDark ? white : darkPurple,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
      onTap: () {
        selectPhotoOptions();
      },
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
              hintText: AppLocalizations.of(context)!.name,
              icon: const Icon(Icons.person_outline_rounded, color: grey),
              textInputType: TextInputType.text,
              controller: name,
              validator: Validatorless.multiple([
                Validatorless.required(
                    AppLocalizations.of(context)!.fillFieldYourName),
                Validatorless.min(3,
                    AppLocalizations.of(context)!.nameMustHaveLeast3Characters),
                Validatorless.max(
                    30,
                    AppLocalizations.of(context)!
                        .nameMustHaveMaximum30Characters),
              ]),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: AppLocalizations.of(context)!.email,
              icon: const Icon(Icons.alternate_email_rounded, color: grey),
              textInputType: TextInputType.emailAddress,
              controller: email,
              validator: Validatorless.multiple([
                Validatorless.required(
                    AppLocalizations.of(context)!.fillFieldWithYourEmail),
                Validatorless.email(AppLocalizations.of(context)!.invalidEmail),
              ]),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: AppLocalizations.of(context)!.cpf,
              icon: const Icon(Icons.person, color: grey),
              textInputType: TextInputType.number,
              controller: cpf,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              validator: Validatorless.multiple([
                Validatorless.required(
                    AppLocalizations.of(context)!.fillFieldWithYourCpf),
                Validatorless.cpf(AppLocalizations.of(context)!.invalidCpf),
                Validatorless.min(
                    11, AppLocalizations.of(context)!.cpfMustHaveElevenDigits)
              ]),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: AppLocalizations.of(context)!.cellPhone,
              icon: const Icon(Icons.phone, color: grey),
              textInputType: TextInputType.phone,
              controller: phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter(),
              ],
              validator: Validatorless.multiple([
                Validatorless.required(
                    AppLocalizations.of(context)!.fillFieldWithYourPhoneNumber),
                Validatorless.min(
                    14, AppLocalizations.of(context)!.phoneMustHave14Digits)
              ]),
            ),
            const SizedBox(height: 20),
            _buildMaritalStatus(),
            const SizedBox(height: 20),
            _buildGender(),
            const SizedBox(height: 20),
            CustomTextFieldPassword(
              hintText: AppLocalizations.of(context)!.password,
              icon: const Icon(Icons.lock_outline_rounded, color: grey),
              onTapPassword: () {
                controller.viewPassword();
              },
              visualizar: controller.passwordHide,
              password: true,
              obscureText: controller.passwordHide,
              textInputType: TextInputType.visiblePassword,
              controller: password,
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
                        .passwordMustBeAtLeast20CharactersLong),
              ]),
            ),
            const SizedBox(height: 20),
            _buildButtonSignUp(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMaritalStatus() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: lightPurple, borderRadius: BorderRadius.circular(11)),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.selectYourMaritalStatus,
            style: GoogleFonts.syne(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: darkPurple,
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.married,
              style: GoogleFonts.syne(
                  fontWeight: FontWeight.w500, fontSize: 15, color: black),
            ),
            leading: Radio(
              value: "Casado(a)",
              groupValue: controller.maritalStsValue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: purple,
              onChanged: (value) {
                setState(() {
                  controller.maritalStsValue = value as String;
                });
              },
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.single,
              style: GoogleFonts.syne(
                  fontWeight: FontWeight.w500, fontSize: 15, color: black),
            ),
            leading: Radio(
                value: "Solteiro(a)",
                groupValue: controller.maritalStsValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: purple,
                onChanged: (value) {
                  setState(() {
                    controller.maritalStsValue = value as String;
                  });
                }),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.divorced,
              style: GoogleFonts.syne(
                  fontWeight: FontWeight.w500, fontSize: 15, color: black),
            ),
            leading: Radio(
                value: "Divorciado(a)",
                groupValue: controller.maritalStsValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: purple,
                onChanged: (value) {
                  setState(() {
                    controller.maritalStsValue = value as String;
                  });
                }),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.widower,
              style: GoogleFonts.syne(
                  fontWeight: FontWeight.w500, fontSize: 15, color: black),
            ),
            leading: Radio(
                value: "Viúvo(a)",
                groupValue: controller.maritalStsValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: purple,
                onChanged: (value) {
                  setState(() {
                    controller.maritalStsValue = value as String;
                  });
                }),
          )
        ],
      ),
    );
  }

  Widget _buildGender() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: lightPurple, borderRadius: BorderRadius.circular(11)),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.selectYourGenre,
            style: GoogleFonts.syne(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: darkPurple,
            ),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.male,
              style: GoogleFonts.syne(
                  fontWeight: FontWeight.w500, fontSize: 15, color: black),
            ),
            leading: Radio(
                value: "Masculino",
                groupValue: controller.genreValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: purple,
                onChanged: (value) {
                  setState(() {
                    controller.genreValue = value as String;
                  });
                }),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.feminine,
              style: GoogleFonts.syne(
                  fontWeight: FontWeight.w500, fontSize: 15, color: black),
            ),
            leading: Radio(
                value: "Feminino",
                groupValue: controller.genreValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: purple,
                onChanged: (value) {
                  setState(() {
                    controller.genreValue = value as String;
                  });
                }),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.other,
              style: GoogleFonts.syne(
                  fontWeight: FontWeight.w500, fontSize: 15, color: black),
            ),
            leading: Radio(
                value: "Outro(s)",
                groupValue: controller.genreValue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: purple,
                onChanged: (value) {
                  setState(() {
                    controller.genreValue = value as String;
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSignUp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: CustomAnimatedButton(
        onTap: () async {
          signUp();
        },
        widhtMultiply: 1,
        height: 45,
        colorText: white,
        color: purple,
        text: AppLocalizations.of(context)!.createAnAccount,
      ),
    );
  }

  signUp() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    final user = UserModel(
      name: name.text,
      email: email.text,
      cpf: cpf.text,
      phone: phone.text,
      password: password.text,
      maritalStatus: controller.maritalStsValue,
      genre: controller.genreValue,
    );

    if (isValid) {
      List result = controller.validateFields(user);
      if (result.first == true) {
        setState(() => controller.loading = true);
        String url = '';
        if (controller.file != null) {
          url = await controller.upload(controller.file!.path, user.email);
        }
        user.userImage = url;
        bool result = await controller.signUpUser(user);
        if (result) {
          Modular.to.navigate('/home');
          setState(() => controller.loading = false);
        } else {
          alertDialog(
              context,
              AlertType.error,
              AppLocalizations.of(context)!.attention,
              AppLocalizations.of(context)!.userAlreadyExists);
        }
      } else {
        final info = result[0];
        final title = result[1];
        final description = result[2];
        alertDialog(context, info, title, description);
      }
    }
  }
}
