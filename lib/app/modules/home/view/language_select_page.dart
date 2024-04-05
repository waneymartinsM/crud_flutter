// ignore_for_file: deprecated_member_use
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectPage extends StatefulWidget {
  const LanguageSelectPage({super.key, required this.selectedLocale});

  final Locale selectedLocale;

  @override
  State<LanguageSelectPage> createState() => _LanguageSelectPageState();
}

class _LanguageSelectPageState extends State<LanguageSelectPage> {
  late Locale _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLocale;
    _loadSelectedLanguage();
  }

  void _updateLanguage(Locale newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedLanguageCode = prefs.getString('selectedLanguage');
    if (selectedLanguageCode != null) {
      setState(() {
        _selectedLanguage = Locale(selectedLanguageCode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
          onPressed: () => Modular.to.navigate('/home'),
        ),
        backgroundColor: purple,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.language,
          style: GoogleFonts.syne(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.selectPreferredLanguage,
              style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<Locale>(
              items: L10n.all.map<DropdownMenuItem<Locale>>((Locale value) {
                return DropdownMenuItem<Locale>(
                  value: value,
                  child: Text(value.languageCode.toUpperCase()),
                );
              }).toList(),
              value: _selectedLanguage,
              onChanged: (Locale? locale) {
                if (locale != null) {
                  _updateLanguage(locale);
                }
              },
            ),
            const SizedBox(height: 40),
            CustomAnimatedButton(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    'selectedLanguage', _selectedLanguage.languageCode);
                Modular.to.pushNamed('/home/');
              },
              widhtMultiply: 0.7,
              height: 45,
              colorText: white,
              color: purple,
              text: AppLocalizations.of(context)!.save,
            ),
          ],
        ),
      ),
    );
  }
}
