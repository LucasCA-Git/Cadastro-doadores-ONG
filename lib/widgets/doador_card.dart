import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/doador.dart';

/// Card de um doador na listagem principal.
class DoadorCard extends StatelessWidget {
  const DoadorCard({
    super.key,
    required this.doador,
    required this.onTap,
  });

  final Doador doador;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.12),
          foregroundColor: AppColors.primary,
          child: Text(
            doador.nome.isNotEmpty ? doador.nome[0].toUpperCase() : '?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          doador.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${doador.tipoDoacao.label} · ${doador.frequencia.label} · ${doador.telefone}',
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (doador.ativo ? AppColors.success : AppColors.danger)
                .withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            doador.ativo ? 'Ativo' : 'Inativo',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: doador.ativo ? AppColors.success : AppColors.danger,
            ),
          ),
        ),
      ),
    );
  }
}
