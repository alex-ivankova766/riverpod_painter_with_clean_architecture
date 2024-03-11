import 'package:flutter/material.dart';

class CustomTheme {
  ThemeData theme() {
    return ThemeData(
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }
}
