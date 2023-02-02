import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/main.dart';

class MySize {
  static double width = 0;
  static double height = 0;

  static double indexCardHeight = 0;
  static double indexCardWidth = 0;

  static double startButtonLength = 0;
  static double detailFeaturePadding = 0;
  static double detailFeaturePaddingTopAndBottom = 0;

  static double size64 = 0;
  static double size60 = 0;
  static double size56 = 0;
  static double size48 = 0;
  static double size32 = 0;
  static double size24 = 0;
  static double size16 = 0;
  static double size12 = 0;
  static double size8 = 0;
  static double size4 = 0;
  static double size2 = 0;

  static void setSize(double width2, double height2) {
    width = width2;
    height = height2;

    indexCardHeight = width * 0.55;
    indexCardWidth = indexCardHeight * 4 / 3;
    startButtonLength = width * 0.8;
    detailFeaturePadding = width * 0.1;
    detailFeaturePaddingTopAndBottom = width * 0.04;

    // set size for text
    size64 = width * 1;
    size60 = width * 0.9;
    size32 = width * 0.5;
    size24 = width * 0.375;
    size16 = width * 0.25;
    size12 = width * 0.1875;
    size8 = width * 0.125;
    size4 = width * 0.0625;
    size2 = width * 0.03125;
  }

  //no dark
  static TextStyle get recipesDetailFeatureValueStyle {
    if (MyApp.notifier.value == ThemeMode.light) {
      return const TextStyle(
          color: Color.fromRGBO(70, 47, 77, 1),
          fontFamily: 'Montserrat',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
          height: 1.5714285714285714);
    }
    return const TextStyle(
        color: Color.fromRGBO(70, 47, 77, 1),
        fontFamily: 'Montserrat',
        fontSize: 14,
        letterSpacing:
            0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.bold,
        height: 1.5714285714285714);
  }

  static TextStyle get recipesDetailFeatureNameStyle {
    if (MyApp.notifier.value == ThemeMode.light) {
      return const TextStyle(
          color: Color.fromRGBO(70, 47, 77, 1),
          fontFamily: 'Montserrat',
          fontSize: 15,
          letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
          fontWeight: FontWeight.normal,
          height: 1.4);
    }
    return const TextStyle(
        color: Color.fromRGBO(70, 47, 77, 1),
        fontFamily: 'Montserrat',
        fontSize: 10,
        letterSpacing:
            0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.normal,
        height: 1.4);
  }

  static Color get cardColor {
    if (MyApp.notifier.value == ThemeMode.light) {
      return const Color(0xFFF9E3D5);
    }
    return const Color(0xFFF9E3D5);
  }

  static Color get buttonColor {
    if (MyApp.notifier.value == ThemeMode.light) {
      return const Color(0xFFF2894F);
    }
    return const Color(0xFFF2894F);
  }

  //Appbar Text Style
  static TextStyle get appbarTextStyle {
    if (MyApp.notifier.value == ThemeMode.light) {
      return const TextStyle(
          color: Color.fromRGBO(70, 47, 77, 1),
          fontFamily: 'Montserrat',
          fontSize: 30,
          letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
          fontWeight: FontWeight.normal,
          height: 1.4);
    }
    return const TextStyle(
        color: Color.fromRGBO(70, 47, 77, 1),
        fontFamily: 'Montserrat',
        fontSize: 50,
        letterSpacing:
            0 /*percentages not used in flutter. defaulting to zero*/,
        fontWeight: FontWeight.normal,
        height: 1.4);
  }

  static Color get purpleDark {
    return Color.fromRGBO(70, 47, 77, 1);
  }

  static Color get iconColor {
    return Colors.blue;
  }

  static getScaledSizeHeight(int size) {
    return size * height / 812;
  }
}
