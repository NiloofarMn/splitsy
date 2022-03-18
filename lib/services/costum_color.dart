import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class MyColors {
  MyColors._(); // this basically makes it so you can instantiate this class

  static const MaterialColor pink = MaterialColor(
    0xFFBC3BAC,
    <int, Color>{
      50: Color(0xFFFBF6FA),
      100: Color(0xFFE9B8E3),
      200: Color(0xFFECADE4),
      300: Color(0xFFD195C5),
      400: Color(0xFFD04BC0), //
      500: Color(0xFFBC3BAC),
      600: Color(0xFF932E80), //
      700: Color(0xFF5B1258),
      800: Color(0xFF521045),
      900: Color(0xFF440142),
    },
  );

  static const MaterialColor green = MaterialColor(
    0xFF389653,
    <int, Color>{
      50: Color(0xFFECFEF1),
      100: Color(0xFFCCF2D6),
      200: Color(0xFF8FDAA5),
      300: Color(0xFF6FCB8A),
      400: Color(0xFF51B06D),
      500: Color(0xFF389653),
      600: Color(0xFF268040),
      700: Color(0xFF135726),
      800: Color(0xFF072C11),
      900: Color(0xFF010F05),
    },
  );

  static const MaterialColor blue = MaterialColor(
    0xFF3BA6C6,
    <int, Color>{
      50: Color(0xFFF2FCFF),
      100: Color(0xFFCFE7EE),
      200: Color(0xFFAACFDA),
      300: Color(0xFF8EC2D1),
      400: Color(0xFF6FB3C7),
      500: Color(0xFF56AEC8),
      600: Color(0xFF3BA6C6),
      700: Color(0xFF23819D),
      800: Color(0xFF0B4556),
      900: Color(0xFF042731),
    },
  );

  static const MaterialColor yellow = MaterialColor(
    0xFFF3DA2F,
    <int, Color>{
      50: Color(0xFFFFFEF7),
      100: Color(0xFFFBF5CD),
      200: Color(0xFFF6EA98),
      300: Color(0xFFF6E572),
      400: Color(0xFFF5E052), //
      500: Color(0xFFF3DA2F),
      600: Color(0xFFEED20D), //
      700: Color(0xFFC4AD0C),
      800: Color(0xFF675C0D),
      900: Color(0xFF2C2704),
    }, //
  );

  static const Map<int, Color> people = {
    1: Color(0xFFC0392B),
    2: Colors.amber, //Color(0xFFF1C40F),
    3: Color(0xFF9B59B6),
    4: Color(0xFF2980B9),
    5: Color(0xFF27AE60),
    6: Color(0xFF979A9A),
    7: Color(0xFF5B1C9F),
    8: Color(0xFFCA6F1E), //  F39C12
    9: Color(0xFF943126),
    10: Color(0xFF1ABC9C),
  };

  static Map<int, BoxDecoration> sheetColors = {
    1: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.springWarmt),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    2: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.sunnyMorning),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ), //Color(0xFFF1C40F),
    3: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.rareWind),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    4: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.temptingAzure),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    5: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.meanFruit),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    6: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.wildApple),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    7: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.redSalvation),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    8: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.teenNotebook),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    9: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.japanBlush),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    10: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.aqua),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    11: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.ver),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    12: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.gradeGrey),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    13: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.lemonGate),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
    14: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        colors: GradientColors.shadyWater),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
      ),
    ),
  };
  static Map<int, Color> fontColors = {
    1: Colors.pink.shade800,
    2: Colors.deepOrange.shade900,
    3: Colors.teal,
    4: Colors.green.shade800,
    5: Colors.purple,
    6: Colors.purple.shade400,
    7: Colors.deepPurple.shade100,
    8: Colors.indigo.shade400,
    9: Colors.pink.shade800,
    10: Colors.cyan.shade100,
    11: Colors.lime.shade100,
    12: Colors.blueGrey.shade100,
    13: Colors.lime.shade900,
    14: Colors.lightBlue.shade900,
  };
}
