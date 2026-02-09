import 'package:flutter/material.dart';

class TemaCustomizado {
  static final ThemeData temaPadrao = ThemeData(
    useMaterial3: true,
    
    // Cores Principais da OLX
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff6a1b9a), // Roxo OLX
      primary: const Color(0xff6a1b9a),    // Roxo Principal
      secondary: const Color(0xfff28000),  // Laranja de destaque (botões)
      surface: Colors.white,
    ),

    // Configuração da AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff6a1b9a),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Botões Elevados (usados para "Anunciar", "Entrar", etc.)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xfff28000), // Laranja OLX
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    ),

    // Configuração das Abas (Tabs)
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Color(0xfff28000), // Linha laranja na aba ativa
    ),

    // Estilo dos Campos de Texto (Inputs)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff6a1b9a), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );
}