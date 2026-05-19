import 'package:flutter/material.dart';
import 'screens/gestion_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Hunger Games Complete Simulator',
    theme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
        brightness: Brightness.dark,
      ).copyWith(
        primary: Colors.amberAccent,
        secondary: Colors.deepPurpleAccent,
        surface: const Color(0xFF16161A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0B0C0E),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: const Color(0xFF0B0C0E),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      cardColor: const Color(0xFF1A1B22),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.06)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111214),
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.04))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Colors.amberAccent, width: 1.2)),
      ),
      textTheme: TextTheme(
        bodyLarge: const TextStyle(color: Colors.white70, fontSize: 15),
        bodyMedium: const TextStyle(color: Colors.white60, fontSize: 14),
        titleLarge: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
      ),
    ),
    home: GestionScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
