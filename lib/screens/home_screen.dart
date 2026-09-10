import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../providers/doadores_provider.dart';
import '../widgets/stat_card.dart';
import 'doadores/doadores_list_screen.dart';

/// Painel inicial do app: visão geral rápida + acesso aos módulos.
///
/// Apenas "Doadores" está funcional nesta primeira entrega. Os módulos
/// futuros (Beneficiários e Relatórios) aparecem como preview, conforme
/// o roadmap descrito na documentação do projeto.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoadoresProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Santo Angelus'),
      ),
      body: RefreshIndicator(
        onRefresh: provider.carregar,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _CabecalhoInstitucional(),
            const SizedBox(height: 20),
            Text(
              'Visão geral',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    titulo: 'Doadores cadastrados',
                    valor: '${provider.totalDoadores}',
                    icone: Icons.volunteer_activism,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    titulo: 'Doadores ativos',
                    valor: '${provider.totalAtivos}',
                    icone: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatCard(
              titulo: 'Doações recorrentes mensais',
              valor: '${provider.totalDoacoesMensais}',
              icone: Icons.calendar_month,
            ),
            const SizedBox(height: 24),
            Text(
              'Módulos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _ModuloTile(
              icone: Icons.people_alt,
              titulo: 'Doadores',
              subtitulo: 'Cadastrar, consultar e gerenciar doadores',
              habilitado: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DoadoresListScreen(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _ModuloTile(
              icone: Icons.diversity_3,
              titulo: 'Beneficiários',
              subtitulo:
                  'Colo de Mãe, Missão de Rua, Caminhando na Fé, Taekwondo',
              habilitado: false,
              onTap: () => _emBreve(context),
            ),
            const SizedBox(height: 10),
            _ModuloTile(
              icone: Icons.bar_chart,
              titulo: 'Relatórios',
              subtitulo: 'Indicadores de doações e atendimentos',
              habilitado: false,
              onTap: () => _emBreve(context),
            ),
          ],
        ),
      ),
    );
  }

  void _emBreve(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Módulo previsto para uma próxima fase do projeto.'),
      ),
    );
  }
}

class _CabecalhoInstitucional extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.church, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Missão Católica Santo Angelus',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '"Ser o sustento para o corpo e para a alma"',
                  style: TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuloTile extends StatelessWidget {
  const _ModuloTile({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.habilitado,
    required this.onTap,
  });

  final IconData icone;
  final String titulo;
  final String subtitulo;
  final bool habilitado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icone,
          color: habilitado ? AppColors.primary : AppColors.textMuted,
        ),
        title: Text(titulo),
        subtitle: Text(subtitulo),
        trailing: habilitado
            ? const Icon(Icons.chevron_right)
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Em breve',
                  style: TextStyle(fontSize: 11),
                ),
              ),
      ),
    );
  }
}
