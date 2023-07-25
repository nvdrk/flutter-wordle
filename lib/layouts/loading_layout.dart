import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wordle/theme/style.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../theme/theme.dart';

class LoadingLayout extends ConsumerWidget {
  const LoadingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: greyTint.shade300,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WORD HAMSTER',
                style: const MontserratTextStyle().copyWith(color: greyTint.shade800, fontSize: 30),
              ),
              Lottie.asset(
                'assets/lottie/title.json',
                repeat: false,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(height: 50,)
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 50,
                  child: Text(
                    'LET\'S GO...',
                    style: const MontserratTextStyle().copyWith(color: greyTint.shade800, fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
