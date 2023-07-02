import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordle/theme/style.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title, this.isPop = false});
  final String title;
  final bool isPop;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: greyTint.shade900,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      elevation: 8,
      leading: isPop ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go('/');
        },
      ) : const SizedBox.shrink(),
      title: Text(
        title,
        style: GoogleFonts.oswald(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: good),
        textAlign: TextAlign.center,
      ),
    );
  }
}

