import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/doador_repository.dart';
import 'providers/doadores_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SantoAngelusApp());
}

class SantoAngelusApp extends StatelessWidget {
  const SantoAngelusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Troque `InMemoryDoadorRepository()` por uma implementação real
        // (Firebase, API própria, etc.) quando o backend estiver pronto —
        // nenhuma tela precisa mudar por causa disso.
        ChangeNotifierProvider(
          create: (_) => DoadoresProvider(InMemoryDoadorRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Santo Angelus - Cadastro de Doadores',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );
  }
}
