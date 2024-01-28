import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordle/app/theme/style.dart';


class GoogleTextTheme extends TextTheme {
  @override
  TextStyle? get headline1 => TextStyle( fontFamily: 'RobotoCondensed',
    fontSize: 21, fontWeight: FontWeight.w700, color: greyTint.shade700,);

  @override
  TextStyle? get headline2 => TextStyle( fontFamily: 'RobotoCondensed',
    fontSize: 21, fontWeight: FontWeight.w700, color: greyTint.shade700,);

  @override
  TextStyle? get headline3 => TextStyle( fontFamily: 'RobotoCondensed',
    fontSize: 21, fontWeight: FontWeight.w700, color: greyTint.shade700,);

  @override
  TextStyle? get headline4 => TextStyle( fontFamily: 'RobotoCondensed',
    fontSize: 21, fontWeight: FontWeight.w700, color: greyTint.shade700,);

  @override
  TextStyle? get headline5 => TextStyle( fontFamily: 'RobotoCondensed',
    fontSize: 21, fontWeight: FontWeight.w700, color: greyTint.shade700,);

  @override
  TextStyle? get headline6 => TextStyle( fontFamily: 'RobotoCondensed',
    fontSize: 21, fontWeight: FontWeight.w700, color: greyTint.shade700,);


  @override
  TextStyle? get bodyText1 => GoogleFonts.quicksand(
    fontSize: 13, fontWeight: FontWeight.w400, color: greyTint.shade700,);

  @override
  TextStyle? get bodyLarge => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w400, color: greyTint.shade700,);

  @override
  TextStyle? get bodySmall => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w400, color: greyTint.shade700,);

  @override
  TextStyle? get bodyText2 => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w400, color: greyTint.shade700,);

  @override
  TextStyle? get subtitle1 => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w400, color: greyTint.shade700,);

  @override
  TextStyle? get subtitle2 => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w400, color: greyTint.shade700,);

  @override
  TextStyle? get button => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w400, color: greyTint.shade700,);
}
