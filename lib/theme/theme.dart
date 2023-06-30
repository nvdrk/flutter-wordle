import 'dart:ui' as ui show lerpDouble;
import 'package:flutter/material.dart';



part 'data/colors.dart';
part 'data/material.dart';
part 'data/radius.dart';
part 'data/spacing.dart';
part 'data/typography.dart';

abstract class MoveTheme {
  const MoveTheme({
    required this.brightness,
    required this.palette,
    required this.radius,
    required this.spacing,
  });

  final Brightness brightness;
  final Palette palette;
  final ThemeRadius radius;
  final Spacing spacing;

  ThemeData get material;
}

class LightTheme extends MoveTheme with MaterialThemeMixin {
  const LightTheme({
    super.palette = const Palette.gray(),
    super.radius = const ThemeRadius(),
    super.spacing = const Spacing(),
  }) : super(brightness: Brightness.light);
}

mixin ThemeDataMixin<T extends StatefulWidget> on State<T> {
  final theme = const LightTheme().material;
}
