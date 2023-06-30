import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/style.dart';

class MoveAppBar extends StatelessWidget {
  const MoveAppBar({super.key, required this.title, this.isPop = false});
  final String title;
  final bool isPop;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 8,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        title,
        style: GoogleFonts.oswald(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: moveGood),
        textAlign: TextAlign.center,
      ),
    );
  }
}

