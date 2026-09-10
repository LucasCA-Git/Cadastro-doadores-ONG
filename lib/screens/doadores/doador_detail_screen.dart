import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/doadores_provider.dart';
import 'doador_form_screen.dart';

/// Tela de detalhe de um doador, com atalhos para editar ou remover.
class DoadorDetailScreen extends StatelessWidget {
  const DoadorDetailScreen({super.key, required this.doadorId});

  final String doadorId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoadoresProvider>();
    final doador = provider.buscarPorId(doadorId);

    if (doador == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Doador')),
        body: const Center(child: Text('Este doador não existe mais.')),
      );
    }

    final formatoData = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(doador.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DoadorFormScreen(doador: doador),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmarRemocao(context, provider, doador.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (doador.ativo ? AppColors.success : AppColors.danger)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              doador.ativo ? 'Ativo' : 'Inativo',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: doador.ativo ? AppColors.success : AppColors.danger,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _InfoTile(icone: Icons.phone, titulo: 'Telefone', valor: doador.telefone),
          _InfoTile(icone: Icons.email_outlined, titulo: 'E-mail', valor: doador.email),
          _InfoTile(
            icone: Icons.location_on_outlined,
            titulo: 'Endereço',
            valor: doador.endereco,
          ),
          _InfoTile(
            icone: Icons.volunteer_activism,
            titulo: 'Tipo de doação',
            valor: doador.tipoDoacao.label,
          ),
          _InfoTile(
            icone: Icons.repeat,
            titulo: 'Frequência',
            valor: doador.frequencia.label,
          ),
          if (doador.valorEstimado != null)
            _InfoTile(
              icone: Icons.attach_money,
              titulo: 'Valor estimado',
              valor: 'R\$ ${doador.valorEstimado!.toStringAsFixed(2)}',
            ),
          _InfoTile(
            icone: Icons.event,
            titulo: 'Cadastrado em',
            valor: formatoData.format(doador.dataCadastro),
          ),
          if (doador.observacoes != null && doador.observacoes!.isNotEmpty)
            _InfoTile(
              icone: Icons.notes,
              titulo: 'Observações',
              valor: doador.observacoes,
            ),
        ],
      ),
    );
  }

  Future<void> _confirmarRemocao(
    BuildContext context,
    DoadoresProvider provider,
    String id,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover doador'),
        content: const Text('Tem certeza que deseja remover este cadastro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await provider.remover(id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icone, required this.titulo, this.valor});

  final IconData icone;
  final String titulo;
  final String? valor;

  @override
  Widget build(BuildContext context) {
    if (valor == null || valor!.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icone, color: AppColors.primary),
        title: Text(titulo, style: const TextStyle(fontSize: 12)),
        subtitle: Text(
          valor!,
          style: const TextStyle(fontSize: 15, color: AppColors.textDark),
        ),
      ),
    );
  }
}
