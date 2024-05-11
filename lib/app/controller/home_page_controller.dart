import 'package:flutter/material.dart';
import 'package:tech_route/app/controller/questao_controller.dart';
import 'package:tech_route/app/model/pratica_model.dart';
import 'package:tech_route/app/repository/pratica_repository.dart';
import 'package:tech_route/app/util/format_util.dart';

class HomePageController with ChangeNotifier {
  String? tecnologiaEstudo = '';

  criarNovaPratica(BuildContext context) async {
    _exibirDialogCarregamento(context);

    Pratica pratica = Pratica();
    pratica.dataCriacao =
        formatarStringDataParaPersistir(DateTime.now().toString());
    pratica.tecnologia = tecnologiaEstudo;

    PraticaRepository().save(pratica);

    List<Pratica> lastSaveList = await PraticaRepository().findLastSave();

    if (lastSaveList.isNotEmpty) {
      pratica = lastSaveList[0];
    } else {
      return;
    }

    await QuestaoController().gerarQuestoes(pratica);

    Navigator.of(context).pop();

    Navigator.of(context).pushReplacementNamed('praticas');

    tecnologiaEstudo = '';
    notifyListeners();
  }
}

_exibirDialogCarregamento(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(child: CircularProgressIndicator());
    },
  );
}
