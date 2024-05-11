import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tech_route/app/model/pratica_model.dart';
import 'package:tech_route/app/model/questao_model.dart';
import 'package:tech_route/app/repository/questao_repository.dart';

class QuestaoController with ChangeNotifier {
  Pratica? praticaSelecionada;
  Questao? questaoSelecionada;

  gerarQuestoes(Pratica pratica) async {
    final model = _getModelo();

    for (int i = 1; i <= 5; i++) {
      final content = [
        Content.text(
            'Faça uma pergunta aleatória simples (para iniciantes) sobre uma das seguintes tecnologias: (${pratica.tecnologia}). Gostaria de testar meus conhecimentos específicos da área.')
      ];

      final response = await model.generateContent(content);
      _salvarQuestao(pratica, response.text, '${i}/5');
    }
  }

  GenerativeModel _getModelo() {
    final apiKey = _getApiKey();

    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    return model;
  }

  String _getApiKey() {
    const apiKey = '<TAG>';

    print('API KEY: ${apiKey}');

    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    return apiKey;
  }

  _salvarQuestao(Pratica pratica, String? pergunta, String? numeroQuestao) {
    Questao questao = Questao();
    questao.praticaId = pratica.id;
    questao.numeroQuestao = numeroQuestao;
    questao.pergunta = pergunta;

    QuestaoRepository().save(questao);
  }

  visualizarQuestoes(BuildContext context, Pratica pratica) {
    praticaSelecionada = pratica;
    Navigator.of(context).pushReplacementNamed('questoes');
  }

  Future<List<Questao>> findQuestoesByPratica() async {
    List<Questao> questoes =
        await QuestaoRepository().findByPratica(praticaSelecionada);

    return questoes;
  }

  responderQuestaoSelecionada(BuildContext context, Questao questao) async {
    questaoSelecionada = questao;

    if (questaoSelecionada!.nota != null &&
        questaoSelecionada!.nota!.isNotEmpty &&
        (questaoSelecionada!.feedback == null ||
            questaoSelecionada!.feedback!.isEmpty)) {
      await _receberFeedabck(context);
    }

    Navigator.of(context).pushReplacementNamed('resposta');
  }

  enviarResposta(BuildContext context) async {
    _exibirDialogCarregamento(context);
    await avaliarResposta();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('questoes');
  }

  avaliarResposta() async {
    final model = _getModelo();

    final content = [
      Content.text(
          'Baseado na pergunta: ${questaoSelecionada?.pergunta}. Avalie minha resposta de 0 à 10. Preciso que retorne somente a nota, exemplo: 1.0, 5.5, 8.5, 10 \n\n Resposta: ${questaoSelecionada?.resposta}.')
    ];

    final response = await model.generateContent(content);
    _salvarRespostaEAvaliacao(response.text);
  }

  _salvarRespostaEAvaliacao(String? nota) {
    questaoSelecionada?.nota = nota;
    QuestaoRepository().save(questaoSelecionada!);
  }

  _exibirDialogCarregamento(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _receberFeedabck(BuildContext context) async {
    _exibirDialogCarregamento(context);

    final model = _getModelo();

    final content = [
      Content.text(
          'Baseado na pergunta: ${questaoSelecionada?.pergunta}. \n\n Resposta: ${questaoSelecionada?.resposta} \n\n Nota: ${questaoSelecionada?.nota}. \n\n Me dê um feedback do porque tirei essa nota, e se for uma nota ruim, como deveria ter respondido.')
    ];

    final response = await model.generateContent(content);
    _salvarFeedback(response.text);

    Navigator.of(context).pop();
  }

  _salvarFeedback(String? feedback) {
    questaoSelecionada?.feedback = feedback;
    QuestaoRepository().save(questaoSelecionada!);
  }
}
