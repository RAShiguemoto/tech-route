import 'package:sqflite/sqflite.dart';
import 'package:tech_route/app/model/pratica_model.dart';
import 'package:tech_route/app/model/questao_model.dart';

import '../database/conexao.dart';

class QuestaoRepository {
  Database? get db => _db;

  Database? _db;

  Future<void> _initializeDatabase() async {
    _db = await Conexao.get();
  }

  Future<List<Questao>> findAll() async {
    await _initializeDatabase();

    if (_db != null) {
      var sql = 'SELECT * FROM questao ORDER BY id ASC';
      List<Map<String, dynamic>> result = await _db!.rawQuery(sql, []);

      List<Questao> lista = List.generate(result.length, (index) {
        var linha = result[index];

        Questao questao = Questao();
        questao.id = linha['id'];
        questao.pergunta = linha['numero_questao'];
        questao.pergunta = linha['pergunta'];
        questao.resposta = linha['resposta'];
        questao.feedback = linha['feedback'];
        questao.nota = linha['nota'];
        questao.praticaId = linha['pratica_id'];

        return questao;
      });

      return lista;
    }

    return <Questao>[];
  }

  Future<List<Questao>> findByPratica(Pratica? pratica) async {
    await _initializeDatabase();

    if (_db != null) {
      var sql = 'SELECT * FROM questao WHERE pratica_id = ? ORDER BY id ASC';
      List<Map<String, dynamic>> result =
          await _db!.rawQuery(sql, [pratica!.id]);

      List<Questao> lista = List.generate(result.length, (index) {
        var linha = result[index];

        Questao questao = Questao();
        questao.id = linha['id'];
        questao.numeroQuestao = linha['numero_questao'];
        questao.pergunta = linha['pergunta'];
        questao.resposta = linha['resposta'];
        questao.feedback = linha['feedback'];
        questao.nota = linha['nota'];
        questao.praticaId = linha['pratica_id'];

        return questao;
      });

      return lista;
    }

    return <Questao>[];
  }

  Future<bool> _findId(int? questaoId) async {
    _db = await Conexao.get();

    if (_db != null) {
      var sql = 'SELECT * FROM questao WHERE id = ?';
      List<Map<String, dynamic>> result = await _db!.rawQuery(sql, [questaoId]);

      if (result.isNotEmpty) {
        return true;
      }

      return false;
    }

    return false;
  }

  save(Questao questao) async {
    _db = await Conexao.get();

    if (_db != null) {
      String sql;
      if (questao.id == null) {
        sql =
            'INSERT INTO questao(numero_questao, pergunta, resposta, feedback, nota, pratica_id) VALUES (?, ?, ?, ?, ?, ?)';
        _db!.rawInsert(sql, [
          questao.numeroQuestao,
          questao.pergunta,
          questao.resposta,
          questao.feedback,
          questao.nota,
          questao.praticaId
        ]);
      } else {
        sql =
            'UPDATE questao SET numero_questao = ?, pergunta = ?, resposta = ?, feedback = ?, nota = ?, pratica_id = ? WHERE id = ?';
        _db!.rawUpdate(sql, [
          questao.numeroQuestao,
          questao.pergunta,
          questao.resposta,
          questao.feedback,
          questao.nota,
          questao.praticaId,
          questao.id
        ]);
      }
    } else {}
  }

  delete(Questao questao) async {
    _db = await Conexao.get();

    var sql = 'DELETE FROM Questao WHERE id = ?';
    _db!.rawDelete(sql, [questao.id]);
  }
}
