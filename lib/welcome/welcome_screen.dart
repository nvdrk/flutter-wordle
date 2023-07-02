import 'package:flutter/material.dart';
import 'package:flutter_wordle/components/neumorphic_button.dart';
import 'package:flutter_wordle/components/appbar.dart';
import 'package:flutter_wordle/game/game_provider.dart';
import 'package:flutter_wordle/theme/style.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: greyTint.shade800,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CustomAppBar(
              title: 'FLUTTER WORDLE',
              isPop: false,
            )),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: NeumorphicButton(
                    onTap: () => context.go('/game'),
                    title: 'New Game',
                    height: 50,
                    width: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: NeumorphicButton(
                  onTap: () => print('pressed'),
                  title: 'Settings',
                  height: 50,
                  width: 200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
