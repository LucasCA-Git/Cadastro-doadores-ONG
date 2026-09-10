import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/doador.dart';
import '../../providers/doadores_provider.dart';

/// Formulário de cadastro/edição de doador.
///
/// Se [doador] for informado, o formulário abre em modo de edição;
/// caso contrário, cria um novo registro.
class DoadorFormScreen extends StatefulWidget {
  const DoadorFormScreen({super.key, this.doador});

  final Doador? doador;

  @override
  State<DoadorFormScreen> createState() => _DoadorFormScreenState();
}

class _DoadorFormScreenState extends State<DoadorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _enderecoController;
  late final TextEditingController _valorController;
  late final TextEditingController _observacoesController;

  late TipoDoacao _tipoDoacao;
  late FrequenciaDoacao _frequencia;
  late bool _ativo;

  bool _salvando = false;

  bool get _editando => widget.doador != null;

  @override
  void initState() {
    super.initState();
    final doador = widget.doador;
    _nomeController = TextEditingController(text: doador?.nome ?? '');
    _telefoneController = TextEditingController(text: doador?.telefone ?? '');
    _emailController = TextEditingController(text: doador?.email ?? '');
    _enderecoController = TextEditingController(text: doador?.endereco ?? '');
    _valorController = TextEditingController(
      text: doador?.valorEstimado?.toString() ?? '',
    );
    _observacoesController =
        TextEditingController(text: doador?.observacoes ?? '');
    _tipoDoacao = doador?.tipoDoacao ?? TipoDoacao.financeira;
    _frequencia = doador?.frequencia ?? FrequenciaDoacao.mensal;
    _ativo = doador?.ativo ?? true;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _enderecoController.dispose();
    _valorController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);
    final provider = context.read<DoadoresProvider>();

    final valorTexto = _valorController.text.trim().replaceAll(',', '.');
    final valorEstimado = valorTexto.isEmpty ? null : double.tryParse(valorTexto);

    if (_editando) {
      final atualizado = widget.doador!.copyWith(
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        endereco: _enderecoController.text.trim().isEmpty
            ? null
            : _enderecoController.text.trim(),
        tipoDoacao: _tipoDoacao,
        frequencia: _frequencia,
        valorEstimado: valorEstimado,
        ativo: _ativo,
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
      );
      await provider.atualizar(atualizado);
    } else {
      final novo = Doador(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        nome: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        endereco: _enderecoController.text.trim().isEmpty
            ? null
            : _enderecoController.text.trim(),
        tipoDoacao: _tipoDoacao,
        frequencia: _frequencia,
        valorEstimado: valorEstimado,
        ativo: _ativo,
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
      );
      await provider.adicionar(novo);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar doador' : 'Novo doador'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome completo *'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Informe o nome do doador'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                labelText: 'Telefone / WhatsApp *',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Informe um telefone de contato'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _enderecoController,
              decoration: const InputDecoration(labelText: 'Endereço'),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<TipoDoacao>(
              value: _tipoDoacao,
              decoration: const InputDecoration(labelText: 'Tipo de doação'),
              items: TipoDoacao.values
                  .map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text(tipo.label),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _tipoDoacao = value);
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<FrequenciaDoacao>(
              value: _frequencia,
              decoration: const InputDecoration(labelText: 'Frequência'),
              items: FrequenciaDoacao.values
                  .map((freq) => DropdownMenuItem(
                        value: freq,
                        child: Text(freq.label),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _frequencia = value);
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor estimado (R\$) — opcional',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _observacoesController,
              decoration: const InputDecoration(labelText: 'Observações'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Doador ativo'),
              value: _ativo,
              onChanged: (value) => setState(() => _ativo = value),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvando ? null : _salvar,
                icon: _salvando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_editando ? 'Salvar alterações' : 'Cadastrar doador'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
