import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/welcome/welcome_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_wordle/game/game_screen.dart';

mixin RouterMixin<T extends StatefulWidget> on State<T> {

  late final router = GoRouter(
      routes: [
        GoRoute(
            name: 'Welcome',
            path: '/',
            pageBuilder: (context, state) => NoTransitionPage(
             key: state.pageKey,
             child: const WelcomeScreen(),
          ),
        ),
        GoRoute(
          name: 'Game',
          path: '/game',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const GameLayout(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        ),

      ]
  );
}