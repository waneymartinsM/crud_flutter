// ignore_for_file: deprecated_member_use
import 'package:crud_flutter/app/modules/home/store/home_store.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/l10n/l10n.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectPage extends StatefulWidget {
  const LanguageSelectPage({
    super.key,
    required this.selectedLocale,
  });

  final Locale selectedLocale;

  @override
  State<LanguageSelectPage> createState() => _LanguageSelectPageState();
}

class _LanguageSelectPageState extends State<LanguageSelectPage> {
  final homeStore = Modular.get<HomeStore>();

  @override
  void initState() {
    super.initState();
    homeStore.selectedLanguage = widget.selectedLocale;
    homeStore.loadSelectedLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: _buildArrowBack(),
        backgroundColor: purple,
        elevation: 0,
        title: _buildTextLanguage(context),
      ),
      body: _buildBody(context),
    );
  }

  IconButton _buildArrowBack() {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
      onPressed: () => Modular.to.navigate('/home'),
    );
  }

  Text _buildTextLanguage(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.language,
      style: GoogleFonts.syne(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildTextSelectLanguage(context),
          const SizedBox(height: 20),
          _buildDropdown(context),
          const SizedBox(height: 50),
          _buildButtonSave(context),
        ],
      ),
    );
  }

  Text _buildTextSelectLanguage(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.selectPreferredLanguage,
      style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w400),
    );
  }

  Container _buildDropdown(BuildContext context) {
    var textStyle = GoogleFonts.syne(fontSize: 14);
    return Container(
      decoration: BoxDecoration(
          color: greyLight, borderRadius: BorderRadius.circular(8)),
      child: Observer(builder: (context) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2<Locale>(
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.selectTheLanguage,
                style: textStyle),
            items: L10n.all.map((Locale value) {
              String image;
              switch (value.languageCode) {
                case 'en':
                  image = 'assets/images/estados-unidos.png';
                  break;
                case 'pt':
                  image = 'assets/images/brasil.png';
                  break;
                case 'es':
                  image = 'assets/images/espanha.png';
                  break;
                default:
                  image = 'assets/images/brasil.png';
              }
              return dropdownMenuItem(value, image, textStyle);
            }).toList(),
            value: homeStore.selectedLanguage,
            onChanged: (Locale? locale) {
              if (locale != null) {
                homeStore.updateLanguage(locale);
              }
            },
            dropdownStyleData: dropdownStyleData(),
          ),
        );
      }),
    );
  }

  DropdownMenuItem<Locale> dropdownMenuItem(
      Locale value, String image, TextStyle textStyle) {
    return DropdownMenuItem<Locale>(
      value: value,
      child: Row(
        children: [
          Image.asset(image, height: 25),
          const SizedBox(width: 10),
          Text(translateLanguage(value.toString()), style: textStyle),
        ],
      ),
    );
  }

  DropdownStyleData dropdownStyleData() {
    return DropdownStyleData(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      offset: const Offset(0, 8),
    );
  }

  CustomAnimatedButton _buildButtonSave(BuildContext context) {
    return CustomAnimatedButton(
      onTap: () async {
        await homeStore.saveSelectedLanguage();
        Modular.to.pushNamed('/home/');
      },
      widhtMultiply: 0.7,
      height: 45,
      colorText: white,
      color: purple,
      text: AppLocalizations.of(context)!.save,
    );
  }

  String translateLanguage(String languageCode) {
    switch (languageCode) {
      case 'pt':
        return AppLocalizations.of(context)!.portuguese;
      case 'en':
        return AppLocalizations.of(context)!.english;
      case 'es':
        return AppLocalizations.of(context)!.spanish;
      default:
        return languageCode;
    }
  }
}
