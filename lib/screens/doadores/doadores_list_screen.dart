import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/doadores_provider.dart';
import '../../widgets/doador_card.dart';
import 'doador_detail_screen.dart';
import 'doador_form_screen.dart';

/// Lista de doadores com busca por nome e atalho para cadastro/edição.
class DoadoresListScreen extends StatelessWidget {
  const DoadoresListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoadoresProvider>();
    final doadores = provider.doadores;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doadores'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Novo doador'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DoadorFormScreen()),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: provider.buscar,
              decoration: const InputDecoration(
                hintText: 'Buscar doador pelo nome...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: provider.carregando
                ? const Center(child: CircularProgressIndicator())
                : doadores.isEmpty
                    ? const _ListaVazia()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90, top: 4),
                        itemCount: doadores.length,
                        itemBuilder: (context, index) {
                          final doador = doadores[index];
                          return DoadorCard(
                            doador: doador,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    DoadorDetailScreen(doadorId: doador.id),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _ListaVazia extends StatelessWidget {
  const _ListaVazia();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Nenhum doador encontrado.\nToque em "Novo doador" para cadastrar.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
