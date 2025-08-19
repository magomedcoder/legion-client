import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF121212),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF0E0E0E),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    surfaceTintColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  dividerTheme: DividerThemeData(color: Colors.white24, thickness: 1, space: 1),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1A1A1A),
    hintStyle: TextStyle(color: Colors.white60),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.white10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.white10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: const BorderSide(color: Colors.white12, width: 1.5),
    ),
  ),

  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withOpacity(0.18);
        }
        return Colors.white.withOpacity(0.12);
      }),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.white)),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withOpacity(0.18);
        }
        return Colors.white.withOpacity(0.12);
      }),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withOpacity(0.18);
        }
        return Colors.white.withOpacity(0.12);
      }),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
);
