import '../models/doador.dart';

/// Contrato de acesso a dados dos doadores.
///
/// Hoje existe apenas a implementação [InMemoryDoadorRepository], usada
/// para o front funcionar de forma independente (sem precisar de um
/// backend pronto) durante a apresentação. Nas próximas fases, uma nova
/// classe (ex.: `FirebaseDoadorRepository` ou `ApiDoadorRepository`)
/// implementa esta mesma interface e é trocada em um único lugar
/// (`main.dart`), sem precisar alterar nenhuma tela.
abstract class DoadorRepository {
  Future<List<Doador>> listar();
  Future<void> adicionar(Doador doador);
  Future<void> atualizar(Doador doador);
  Future<void> remover(String id);
}

/// Implementação simples em memória, com alguns registros de exemplo
/// para já demonstrar a listagem, busca e o cadastro funcionando.
class InMemoryDoadorRepository implements DoadorRepository {
  final List<Doador> _doadores = [
    Doador(
      id: '1',
      nome: 'Maria de Fátima Souza',
      telefone: '(81) 99999-1111',
      email: 'maria.fatima@example.com',
      tipoDoacao: TipoDoacao.financeira,
      frequencia: FrequenciaDoacao.mensal,
      valorEstimado: 50,
      observacoes: 'Apoia o Colo de Mãe.',
    ),
    Doador(
      id: '2',
      nome: 'Supermercado Bom Preço',
      telefone: '(81) 98888-2222',
      tipoDoacao: TipoDoacao.itensBens,
      frequencia: FrequenciaDoacao.mensal,
      observacoes: 'Doa alimentos para a Sopa Santa Dulce e São Francisco.',
    ),
    Doador(
      id: '3',
      nome: 'João Pedro Alves',
      telefone: '(81) 97777-3333',
      tipoDoacao: TipoDoacao.servicosVoluntariado,
      frequencia: FrequenciaDoacao.unica,
      ativo: false,
      observacoes: 'Ajudou na reforma do espaço do Caminhando na Fé.',
    ),
  ];

  @override
  Future<List<Doador>> listar() async {
    // Pequeno delay simulando uma chamada assíncrona real (rede/banco).
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_doadores);
  }

  @override
  Future<void> adicionar(Doador doador) async {
    _doadores.add(doador);
  }

  @override
  Future<void> atualizar(Doador doador) async {
    final index = _doadores.indexWhere((d) => d.id == doador.id);
    if (index != -1) {
      _doadores[index] = doador;
    }
  }

  @override
  Future<void> remover(String id) async {
    _doadores.removeWhere((d) => d.id == id);
  }
}
