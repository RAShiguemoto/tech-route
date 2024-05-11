import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tech_route/app/database/scripts/pratica_script.dart';
import 'package:tech_route/app/database/scripts/questao_script.dart';

class Conexao {
  static Database? _db;

  static Future<Database?> get() async {
    if (_db != null) {
      return _db;
    } else {
      try {
        var path = join(await getDatabasesPath(), 'techrouteproducao.db');
        _db = await openDatabase(path, version: 1, onCreate: (db, v) {
          db.execute(createTablePratica);
          db.execute(createTableQuestao);
        }, onUpgrade: (db, oldV, newV) {});

        return _db;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}
