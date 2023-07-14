import 'package:crud_flutter/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectPhoto extends StatelessWidget {
  const SelectPhoto({
    Key? key,
    required this.textLabel,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final void Function()? onTap;
  final String textLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 10,
        backgroundColor: lightPurple,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: purple),
            const SizedBox(width: 14),
            Text(
              textLabel,
              style: GoogleFonts.syne(fontSize: 18, color: purple),
            ),
          ],
        ),
      ),
    );
  }
}
