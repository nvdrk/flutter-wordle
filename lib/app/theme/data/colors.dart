part of '../theme.dart';

class Palette extends MaterialColor {
  const Palette(super.primary, super.swatch);

  const Palette.gray()
      : super(0xFF768097, const {
          50: Color(0xFFEFEFF4),
          100: Color(0xFFD5D9E1),
          200: Color(0xFFBBC0CC),
          300: Color(0xFFA0A6B7),
          400: Color(0xFF8B92A6),
          500: Color(0xFF768097),
          600: Color(0xFF687185),
          700: Color(0xFF565D6E),
          800: Color(0xFF454B58),
          900: Color(0xFF323640)
        });

  static const Color black = Color.fromRGBO(12, 9, 42, 1);
  static const Color white = Color(0xFFFFFFFF);

  /// Gray
  static const Color gray50 = Color(0xFFEFEFF4);
  static const Color gray100 = Color(0xFFD5D9E1);
  static const Color gray200 = Color(0xFFBBC0CC);
  static const Color gray300 = Color(0xFFA0A6B7);
  static const Color gray400 = Color(0xFF8B92A6);
  static const Color gray500 = Color(0xFF768097);
  static const Color gray600 = Color(0xFF687185);
  static const Color gray700 = Color(0xFF565D6E);
  static const Color gray800 = Color(0xFF454B58);
  static const Color gray900 = Color(0xFF323640);

  /// Red
  static const Color red50 = Color(0xFFfef2f2);
  static const Color red100 = Color(0xFFfee2e2);
  static const Color red200 = Color(0xFFfecaca);
  static const Color red300 = Color(0xFFfca5a5);
  static const Color red400 = Color(0xFFf87171);
  static const Color red500 = Color(0xFFef4444);
  static const Color red600 = Color(0xFFdc2626);
  static const Color red700 = Color(0xFFb91c1c);
  static const Color red800 = Color(0xFF991b1b);
  static const Color red900 = Color(0xFF7f1d1d);
}
