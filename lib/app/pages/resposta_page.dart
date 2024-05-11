import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tech_route/app/controller/home_page_controller.dart';
import 'package:tech_route/app/controller/questao_controller.dart';

import '../model/questao_model.dart';

class RespostaPage extends StatefulWidget {
  const RespostaPage({super.key});

  @override
  State<RespostaPage> createState() => _RespostaPageState();
}

class _RespostaPageState extends State<RespostaPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Tech Route",
            style:
                TextStyle(color: Color.fromARGB(255, 33, 35, 38), fontSize: 16),
          ),
        ),
        backgroundColor: Colors.amber[600],
      ),
      body: MyBody(formKey),
      bottomNavigationBar: MyBottomNavigatorBar(),
    );
  }
}

class MyBody extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const MyBody(this.formKey, {super.key});

  @override
  State<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  @override
  Widget build(BuildContext context) {
    final questaoController = context.watch<QuestaoController>();

    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: widget.formKey,
              child: Column(
                children: [
                  Text(
                    'Questão ${questaoController.questaoSelecionada?.numeroQuestao}',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    questaoController.questaoSelecionada?.pergunta ?? '',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    readOnly:
                        _isRespondida(questaoController.questaoSelecionada),
                    maxLines: 8,
                    initialValue:
                        questaoController.questaoSelecionada?.resposta,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Resposta é obrigatória!';
                      }
                      return null;
                    },
                    onSaved: (newValue) => questaoController
                        .questaoSelecionada?.resposta = newValue,
                    decoration: const InputDecoration(
                      labelText: 'Resposta:',
                      hintText: 'Insira sua resposta aqui ...',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible:
                        !_isRespondida(questaoController.questaoSelecionada),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.green,
                        elevation: 3,
                      ),
                      onPressed: () {
                        if (widget.formKey.currentState?.validate() ?? false) {
                          widget.formKey.currentState?.save();
                          questaoController.enviarResposta(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Enviar Resposta',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        _isRespondida(questaoController.questaoSelecionada),
                    child: Text(
                      'Feedback: ${questaoController.questaoSelecionada!.feedback}',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBottomNavigatorBar extends StatefulWidget {
  const MyBottomNavigatorBar({super.key});

  @override
  State<MyBottomNavigatorBar> createState() => _MyBottomNavigatorBarState();
}

class _MyBottomNavigatorBarState extends State<MyBottomNavigatorBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.amber[600],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('questoes');
        },
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.turn_left_rounded,
                size: 35,
                color: const Color.fromARGB(255, 33, 35, 38),
              ),
              Text(
                'Voltar',
                style: TextStyle(color: const Color.fromARGB(255, 33, 35, 38)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isRespondida(Questao? questao) {
  if (questao!.nota != null && questao.nota!.isNotEmpty) return true;
  return false;
}
