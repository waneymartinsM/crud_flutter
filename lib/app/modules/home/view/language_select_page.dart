// ignore_for_file: deprecated_member_use
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:crud_flutter/app/widgets/custom_animated_button.dart';
import 'package:crud_flutter/l10n/l10n.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  final List<String> items = ['Item1', 'Item2', 'Item3', 'Item4'];
  String? selectedValue;

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
            // DropdownButton<Locale>(
            //   items: L10n.all.map<DropdownMenuItem<Locale>>((Locale value) {
            //     IconData iconData;
            //     switch (value.languageCode) {
            //       case 'en':
            //         iconData = Icons.flag_outlined;
            //         break;
            //       case 'pt':
            //         iconData = Icons.g_mobiledata;
            //         break;
            //       default:
            //         iconData = Icons.opacity;
            //     }
            //
            //     return DropdownMenuItem<Locale>(
            //       value: value,
            //       child: Row(
            //         children: [
            //           Icon(iconData),
            //           SizedBox(width: 8),
            //           Text(
            //             value.languageCode.toUpperCase(),
            //             style: TextStyle(fontSize: 16),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            //   value: _selectedLanguage,
            //   onChanged: (Locale? locale) {
            //     if (locale != null) {
            //       _updateLanguage(locale);
            //     }
            //   },
            // ),

            DropdownButtonHideUnderline(
              child: DropdownButton2<Locale>(
                isExpanded: true,
                hint: Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: L10n.all.map((Locale value) {
                  IconData iconData;
                  switch (value.languageCode) {
                    case 'en':
                      iconData = Icons.flag_outlined;
                      break;
                    case 'pt':
                      iconData = Icons.g_mobiledata;
                      break;
                    default:
                      iconData = Icons.opacity;
                  }
                  return DropdownMenuItem<Locale>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(iconData),
                        SizedBox(width: 8),
                        Text(
                          value.languageCode.toUpperCase(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                value: _selectedLanguage,
                onChanged: (Locale? locale) {
                  if (locale != null) {
                    _updateLanguage(locale);
                  }
                },
                // buttonStyle: ButtonStyle(
                //   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                //     EdgeInsets.symmetric(horizontal: 16),
                //   ),
                //   height: MaterialStateProperty.all<double>(40),
                //   width: MaterialStateProperty.all<double>(140),
                // ),
                // menuItemHeight: 40,
              ),
            ),

            //TODO: REMOVER DROPDOWN
            // DropdownButton<Locale>(
            //   items: L10n.all.map<DropdownMenuItem<Locale>>((Locale value) {
            //     IconData iconData;
            //     switch (value.languageCode) {
            //       case 'en':
            //         iconData = Icons.flag_outlined;
            //         break;
            //       case 'pt':
            //         iconData = Icons.g_mobiledata;
            //         break;
            //       default:
            //         iconData = Icons.opacity;
            //     }
            //
            //     return DropdownMenuItem<Locale>(
            //       value: value,
            //       child: Row(
            //         children: [
            //           Icon(iconData),
            //           SizedBox(width: 8),
            //           Text(
            //             value.languageCode.toUpperCase(),
            //             style: TextStyle(fontSize: 16),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            //   value: _selectedLanguage,
            //   onChanged: (Locale? locale) {
            //     if (locale != null) {
            //       _updateLanguage(locale);
            //     }
            //   },
            // ),

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
