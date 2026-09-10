import 'package:flutter/foundation.dart';

import '../data/doador_repository.dart';
import '../models/doador.dart';

/// Estado central da tela de doadores: carregamento, lista completa,
/// filtro de busca e operações de CRUD. As telas apenas "escutam" este
/// provider (via [Consumer]/[context.watch]) e chamam seus métodos.
class DoadoresProvider extends ChangeNotifier {
  DoadoresProvider(this._repository) {
    carregar();
  }

  final DoadorRepository _repository;

  List<Doador> _doadores = [];
  bool _carregando = false;
  String _termoBusca = '';

  bool get carregando => _carregando;
  String get termoBusca => _termoBusca;

  List<Doador> get doadores {
    if (_termoBusca.trim().isEmpty) return List.unmodifiable(_doadores);
    final termo = _termoBusca.toLowerCase();
    return _doadores
        .where((d) => d.nome.toLowerCase().contains(termo))
        .toList(growable: false);
  }

  int get totalDoadores => _doadores.length;
  int get totalAtivos => _doadores.where((d) => d.ativo).length;
  int get totalDoacoesMensais =>
      _doadores.where((d) => d.frequencia == FrequenciaDoacao.mensal).length;

  Future<void> carregar() async {
    _carregando = true;
    notifyListeners();
    _doadores = await _repository.listar();
    _carregando = false;
    notifyListeners();
  }

  void buscar(String termo) {
    _termoBusca = termo;
    notifyListeners();
  }

  Future<void> adicionar(Doador doador) async {
    await _repository.adicionar(doador);
    await carregar();
  }

  Future<void> atualizar(Doador doador) async {
    await _repository.atualizar(doador);
    await carregar();
  }

  Future<void> remover(String id) async {
    await _repository.remover(id);
    await carregar();
  }

  Doador? buscarPorId(String id) {
    try {
      return _doadores.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
