/// Tipo de contribuição que o doador oferece.
enum TipoDoacao {
  financeira,
  itensBens,
  servicosVoluntariado;

  String get label {
    switch (this) {
      case TipoDoacao.financeira:
        return 'Financeira';
      case TipoDoacao.itensBens:
        return 'Itens / Bens';
      case TipoDoacao.servicosVoluntariado:
        return 'Serviços / Voluntariado';
    }
  }
}

/// Frequência com que a doação costuma acontecer.
enum FrequenciaDoacao {
  unica,
  mensal,
  trimestral,
  anual;

  String get label {
    switch (this) {
      case FrequenciaDoacao.unica:
        return 'Única';
      case FrequenciaDoacao.mensal:
        return 'Mensal';
      case FrequenciaDoacao.trimestral:
        return 'Trimestral';
      case FrequenciaDoacao.anual:
        return 'Anual';
    }
  }
}

/// Representa um doador cadastrado na ONG Santo Angelus.
///
/// Este é o modelo mínimo para o MVP (cadastro + consulta). Campos como
/// histórico de doações efetivas, recibos e vínculo com projetos
/// específicos (Colo de Mãe, Missão de Rua, etc.) ficam para uma
/// próxima fase, descrita na documentação do projeto.
class Doador {
  final String id;
  String nome;
  String telefone;
  String? email;
  String? endereco;
  TipoDoacao tipoDoacao;
  FrequenciaDoacao frequencia;
  double? valorEstimado;
  bool ativo;
  String? observacoes;
  final DateTime dataCadastro;

  Doador({
    required this.id,
    required this.nome,
    required this.telefone,
    this.email,
    this.endereco,
    required this.tipoDoacao,
    required this.frequencia,
    this.valorEstimado,
    this.ativo = true,
    this.observacoes,
    DateTime? dataCadastro,
  }) : dataCadastro = dataCadastro ?? DateTime.now();

  Doador copyWith({
    String? nome,
    String? telefone,
    String? email,
    String? endereco,
    TipoDoacao? tipoDoacao,
    FrequenciaDoacao? frequencia,
    double? valorEstimado,
    bool? ativo,
    String? observacoes,
  }) {
    return Doador(
      id: id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      endereco: endereco ?? this.endereco,
      tipoDoacao: tipoDoacao ?? this.tipoDoacao,
      frequencia: frequencia ?? this.frequencia,
      valorEstimado: valorEstimado ?? this.valorEstimado,
      ativo: ativo ?? this.ativo,
      observacoes: observacoes ?? this.observacoes,
      dataCadastro: dataCadastro,
    );
  }
}
