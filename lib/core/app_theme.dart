import 'package:flutter/material.dart';
ThemeData buildTheme() {
  return ThemeData(
      useMaterial3: true,
      colorScheme: colorscheme.fromSeed(seedcolor: cont color(0xFF1B8A5A))
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  );
}