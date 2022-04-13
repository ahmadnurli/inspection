import 'dart:io';
import 'package:inspection/helpers/helpers.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DiagnosisDatabaseProvider {
  DiagnosisDatabaseProvider._();

  static final DiagnosisDatabaseProvider db = DiagnosisDatabaseProvider._();
  Database? _database;

  Future<Database?> get database async {
    // ignore: unnecessary_null_comparison
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'diagnosis.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Diagnosis (id integer primary key AUTOINCREMENT, title TEXT, remark TEXT, img TEXT)');
    });
  }

  addItemToDatabase(Diagnosis diagnosis) async {
    final db = await database;
    var raw = await db!.insert('Diagnosis', diagnosis.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  updateItem(Diagnosis item) async {
    final db = await database;
    var response = await db!.update('Diagnosis', item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
    return response;
  }

  Future<Diagnosis?> getItemWithId(int id) async {
    final db = await database;
    var response =
        await db!.query('Diagnosis', where: 'id = ?', whereArgs: [id]);
    return response.isNotEmpty ? Diagnosis.fromMap(response.first) : null;
  }

  Future<List<Diagnosis>> getAllDiagnosis() async {
    final db = await database;
    var response = await db!.query('Diagnosis');
    List<Diagnosis> list = response.map((e) => Diagnosis.fromMap(e)).toList();
    for (var item in list) {
      print('getAllDiagnosis: ${item.remark}');
    }
    print('getAllDiagnosis: ${list.length}');

    return list;
  }

  deleteItemWithId(int id) async {
    final db = await database;
    return db!.delete('Diagnosis', where: 'id = ?', whereArgs: [id]);
  }

  deleteAllItems() async {
    final db = await database;
    db!.delete('Diagnosis');
  }
}
