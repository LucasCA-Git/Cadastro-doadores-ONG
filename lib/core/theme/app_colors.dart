import 'package:flutter/material.dart';

/// Paleta de cores provisória do projeto.
///
/// IMPORTANTE: estes valores são um placeholder inspirado no material
/// institucional já divulgado pela ONG (tom bordô + dourado). Quando o
/// time de design entregar o manual de marca (logomarca oficial, cores
/// exatas e tipografia), basta atualizar os valores abaixo — nenhuma
/// outra tela precisa ser alterada.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6E1423); // bordô institucional
  static const Color primaryDark = Color(0xFF4A0D18);
  static const Color secondary = Color(0xFFC08A3E); // dourado
  static const Color background = Color(0xFFFBF7F0); // creme
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF2B2320);
  static const Color textMuted = Color(0xFF6B5F58);
  static const Color success = Color(0xFF3A7D44);
  static const Color danger = Color(0xFFB3261E);
}
