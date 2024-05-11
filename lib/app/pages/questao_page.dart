import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_route/app/controller/questao_controller.dart';
import 'package:tech_route/app/model/questao_model.dart';

class QuestaoPage extends StatefulWidget {
  const QuestaoPage({super.key});

  @override
  State<QuestaoPage> createState() => _QuestaoPageState();
}

class _QuestaoPageState extends State<QuestaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Questões",
            style:
                TextStyle(color: Color.fromARGB(255, 33, 35, 38), fontSize: 16),
          ),
        ),
        backgroundColor: Colors.amber[600],
      ),
      body: MyBody(),
      bottomNavigationBar: MyBottomNavigatorBar(),
    );
  }
}

class MyBody extends StatefulWidget {
  const MyBody({super.key});

  @override
  State<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  @override
  Widget build(BuildContext context) {
    final questaoController = context.watch<QuestaoController>();

    return FutureBuilder<List<Questao>>(
      future: questaoController.findQuestoesByPratica(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Algum erro aconteceu!"));
        } else if (snapshot.hasData) {
          List<Questao> questoes = snapshot.data!;
          return _buildQuestaoListView(context, questoes);
        } else {
          return const Center(child: Text("Nenhum dado disponível"));
        }
      },
    );
  }

  Widget _buildQuestaoListView(BuildContext context, List<Questao> questoes) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        itemCount: questoes.length,
        itemBuilder: (context, index) {
          Questao questao = questoes[index];
          final questaoControle = context.watch<QuestaoController>();

          return Card(
            color: const Color.fromARGB(255, 33, 35, 38),
            child: GestureDetector(
              onTap: () {
                questaoControle.responderQuestaoSelecionada(context, questao);
              },
              child: ListTile(
                dense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                textColor: Colors.white,
                title: Text(
                  '${questao.numeroQuestao ?? ''}',
                  style: TextStyle(color: Colors.amber[600], fontSize: 14),
                ),
                subtitle: Text(
                  '${_formatarTamanhoPergunta(questao.pergunta ?? '')}',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  textAlign: TextAlign.justify,
                ),
                trailing: Column(
                  children: [
                    Text('Nota: '),
                    Text(
                      '${questao.nota ?? '-'}',
                      style: TextStyle(color: Colors.amber[600], fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
          Navigator.of(context).pushReplacementNamed('praticas');
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

String _formatarTamanhoPergunta(String pergunta) {
  if (pergunta.length > 150) {
    return "${pergunta.substring(0, 150)} ...";
  }

  return pergunta;
}
