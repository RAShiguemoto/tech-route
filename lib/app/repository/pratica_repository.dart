import 'package:sqflite/sqflite.dart';
import 'package:tech_route/app/model/pratica_model.dart';

import '../database/conexao.dart';

class PraticaRepository {
  Database? get db => _db;

  Database? _db;

  Future<void> _initializeDatabase() async {
    _db = await Conexao.get();
  }

  Future<List<Pratica>> findAll() async {
    await _initializeDatabase();

    if (_db != null) {
      var sql = 'SELECT * FROM pratica ORDER BY id ASC';
      List<Map<String, dynamic>> result = await _db!.rawQuery(sql, []);

      List<Pratica> lista = List.generate(result.length, (index) {
        var linha = result[index];

        Pratica pratica = Pratica();
        pratica.id = linha['id'];
        pratica.dataCriacao = linha['data_criacao'];
        pratica.tecnologia = linha['tecnologia'];

        return pratica;
      });

      return lista;
    }

    return <Pratica>[];
  }

  Future<List<Pratica>> findLastSave() async {
    await _initializeDatabase();

    if (_db != null) {
      var sql = 'SELECT * FROM pratica ORDER BY id DESC LIMIT 1';
      List<Map<String, dynamic>> result = await _db!.rawQuery(sql, []);

      List<Pratica> lista = List.generate(result.length, (index) {
        var linha = result[index];

        Pratica pratica = Pratica();
        pratica.id = linha['id'];
        pratica.dataCriacao = linha['data_criacao'];
        pratica.tecnologia = linha['tecnologia'];

        return pratica;
      });

      return lista;
    }

    return <Pratica>[];
  }

  Future<bool> _findId(int? praticaId) async {
    _db = await Conexao.get();

    if (_db != null) {
      var sql = 'SELECT * FROM pratica WHERE id = ?';
      List<Map<String, dynamic>> result = await _db!.rawQuery(sql, [praticaId]);

      if (result.isNotEmpty) {
        return true;
      }

      return false;
    }

    return false;
  }

  save(Pratica pratica) async {
    _db = await Conexao.get();

    if (_db != null) {
      String sql;
      if (pratica.id == null) {
        sql = 'INSERT INTO Pratica(data_criacao, tecnologia) VALUES (?,?)';
        _db!.rawInsert(sql, [pratica.dataCriacao, pratica.tecnologia]);
      } else {
        sql =
            'UPDATE Pratica SET data_criacao = ?, tecnologia = ?, WHERE id = ?';
        _db!.rawUpdate(
            sql, [pratica.dataCriacao, pratica.tecnologia, pratica.id]);
      }
    } else {}
  }

  delete(Pratica pratica) async {
    _db = await Conexao.get();

    var sql = 'DELETE FROM Pratica WHERE id = ?';
    _db!.rawDelete(sql, [pratica.id]);
  }
}
