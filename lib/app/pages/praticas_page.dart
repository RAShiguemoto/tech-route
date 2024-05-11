import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_route/app/controller/questao_controller.dart';
import 'package:tech_route/app/model/pratica_model.dart';
import 'package:tech_route/app/repository/pratica_repository.dart';
import 'package:tech_route/app/util/format_util.dart';

class PraticasPage extends StatefulWidget {
  const PraticasPage({super.key});

  @override
  State<PraticasPage> createState() => _PraticasPageState();
}

class _PraticasPageState extends State<PraticasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Lista de Práticas",
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
    return FutureBuilder<List<Pratica>>(
      future: PraticaRepository().findAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Algum erro aconteceu!"));
        } else if (snapshot.hasData) {
          List<Pratica> praticas = snapshot.data!;
          return _buildPraticaListView(context, praticas);
        } else {
          return const Center(child: Text("Nenhum dado disponível"));
        }
      },
    );
  }

  Widget _buildPraticaListView(BuildContext context, List<Pratica> praticas) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        itemCount: praticas.length,
        itemBuilder: (context, index) {
          Pratica pratica = praticas[index];
          final questaoControle = context.watch<QuestaoController>();
          return Card(
            color: const Color.fromARGB(255, 33, 35, 38),
            child: GestureDetector(
              onTap: () {
                questaoControle.visualizarQuestoes(context, pratica);
              },
              child: ListTile(
                  textColor: Colors.white,
                  leading: Icon(
                    Icons.school,
                    color: Colors.amber[600],
                    size: 30,
                  ),
                  title: Text(
                    'Tecnologia: ${pratica.tecnologia ?? 'Não identificado'}',
                    style: TextStyle(color: Colors.amber[600], fontSize: 14),
                  ),
                  subtitle: Text(
                    formatarStringDataParaExibir(pratica.dataCriacao),
                    style: TextStyle(fontSize: 13),
                  )),
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
          Navigator.of(context).pushReplacementNamed('/');
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
