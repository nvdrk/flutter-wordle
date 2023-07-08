import 'package:flutter/material.dart';
import 'package:flutter_wordle/components/neumorphic_button.dart';
import 'package:flutter_wordle/components/appbar.dart';
import 'package:flutter_wordle/theme/style.dart';
import 'package:flutter_wordle/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: greyTint.shade800,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'WordHamster',
                style: const HeadlineTextStyle().copyWith(color: Colors.black, fontSize: 30),
              ),
              Lottie.asset('assets/lottie/title.json'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: NeumorphicButton(
                    onTap: () => context.go('/game'),
                    title: 'New Game',
                    height: 50,
                    width: 200, isToggle: false, hasHapticFeedBack: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: NeumorphicButton(
                  onTap: () => print('pressed'),
                  title: 'Settings',
                  height: 50,
                  width: 200, isToggle: false, hasHapticFeedBack: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
