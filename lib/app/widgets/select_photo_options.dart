import 'package:crud_flutter/app/widgets/select_photo.dart';
import 'package:crud_flutter/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SelectPhotoOptions extends StatelessWidget {
  const SelectPhotoOptions({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function(ImageSource source) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: darkPurple,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              SelectPhoto(
                onTap: () => onTap(ImageSource.gallery),
                icon: Icons.image_outlined,
                textLabel: 'Escolher na galeria',
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'OU',
                  style: GoogleFonts.syne(
                      fontSize: 16, color: purple, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SelectPhoto(
                onTap: () => onTap(ImageSource.camera),
                icon: Icons.camera_alt_outlined,
                textLabel: 'Usar a Câmera',
              ),
            ],
          )
        ],
      ),
    );
  }
}
