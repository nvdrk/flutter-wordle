part of '../theme.dart';



class HeadlineTextStyle extends RobotoTextStyle {
  const HeadlineTextStyle({
    super.color,
    super.fontSize = 18,
    super.fontWeight = FontWeight.bold,
    super.decoration = TextDecoration.none,
    super.overflow,
  });
}

class BodyTextStyle extends MontserratTextStyle {
  const BodyTextStyle({
    super.color,
    super.fontSize = 15,
    super.fontWeight = FontWeight.w300,
    super.decoration = TextDecoration.none,
    super.overflow,
  });
}

class ButtonTextStyle extends RobotoTextStyle {
  const ButtonTextStyle({
    super.color,
    super.fontSize,
    super.fontWeight = FontWeight.bold,
    super.decoration = TextDecoration.none,
    super.overflow,
  });
}

class MontserratTextStyle extends TextStyle {
  const MontserratTextStyle({
    super.color,
    super.backgroundColor,
    super.fontSize,
    super.fontWeight,
    super.fontStyle,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.leadingDistribution,
    super.locale,
    super.foreground,
    super.background,
    super.shadows,
    super.fontFeatures,
    super.decoration = TextDecoration.none,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.debugLabel = 'Montserrat',
    super.overflow,
    super.inherit = true,
  }) : super(fontFamily: 'Montserrat');
}

class RobotoTextStyle extends TextStyle {
  const RobotoTextStyle({
    super.color,
    super.backgroundColor,
    super.fontSize,
    super.fontWeight,
    super.fontStyle,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.leadingDistribution,
    super.locale,
    super.foreground,
    super.background,
    super.shadows,
    super.fontFeatures,
    super.decoration = TextDecoration.none,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.debugLabel = 'RobotoCondensed',
    super.overflow,
    super.inherit = true,
  }) : super(fontFamily: 'RobotoCondensed');
}
