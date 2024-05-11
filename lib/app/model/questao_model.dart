class Questao {
  int? id;
  String? numeroQuestao;
  String? pergunta;
  String? resposta;
  String? feedback;
  String? nota;
  int? praticaId;

  Questao();

  @override
  String toString() {
    return "${'id: $id'}, ${'numetoQuestao: $numeroQuestao'}, {'pergunta: $pergunta'}, {'respota: $resposta'}, {'feedback: $feedback'} {'nota: $nota'}, {'praticaId: $praticaId'}";
  }
}
