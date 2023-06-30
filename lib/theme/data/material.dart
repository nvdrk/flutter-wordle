part of '../theme.dart';

extension ThemeExtensionsProvider on ThemeData {
  Spacing get spacing => extension<Spacing>()!;
  ThemeRadius get radius => extension<ThemeRadius>()!;
}

mixin MaterialThemeMixin on MoveTheme {
  @override
  ThemeData get material {
    return ThemeData(
      extensions: [radius, spacing],
      useMaterial3: false, // ?
      brightness: brightness,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: palette,
        errorColor: Palette.red500,
        brightness: brightness,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: palette.shade800,
          foregroundColor: palette.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radius.small),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Palette.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: palette.shade300),
          borderRadius: BorderRadius.all(radius.small),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palette.shade300),
          borderRadius: BorderRadius.all(radius.small),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palette.shade300),
          borderRadius: BorderRadius.all(radius.small),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: palette.shade400),
          borderRadius: BorderRadius.all(radius.small),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Palette.red500),
          borderRadius: BorderRadius.all(radius.small),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      scaffoldBackgroundColor: Palette.white,
      typography: Typography.material2021(),
    );
  }
}
