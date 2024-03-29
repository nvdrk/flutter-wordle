import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wordle/presentation/game/game_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordle/app/theme/style.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key, required this.title, this.isPop = false});
  final String title;
  final bool isPop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: greyTint.shade600,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      leading: isPop ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go('/');
          ref.invalidate(gameProvider);
        },
      ) : const SizedBox.shrink(),
      title: Text(
        title,
        style: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: good),
        textAlign: TextAlign.center,
      ),
    );
  }
}

