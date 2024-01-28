import 'package:flutter/material.dart';
import 'package:flutter_wordle/app/navigation/navigator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_wordle/app/theme/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with RouterMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WORD HAMSTER',
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: greyTint.shade700, brightness:  Brightness.dark)
      ),
      builder: (context, router) {
        return ProviderScope(child: router!);
      },
    );
  }
}

