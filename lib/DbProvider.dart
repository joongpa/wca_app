import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'JSONModels/Competition.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'CompetitionTable.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
            CREATE TABLE competitions(
              class TEXT,
              url TEXT,
              id TEXT,
              name TEXT,
              website TEXT,
              short_name TEXT,
              city TEXT,
              venue_address TEXT,
              venue_details TEXT,
              latitude_degrees REAL,
              longitude_degrees REAL,
              country_iso2 TEXT,
              start_date TEXT,
              registration_open TEXT,
              registration_close TEXT,
              announced_at TEXT,
              end_date TEXT,
              competitor_limit INT
            )
          '''
        );
      }
    );
  }

  Future<List<Competition>> getComps() async {
    final db = await database;
    var results = await db.query('competitions');

    return compute(convertToList, results);
  }

  void add(Competition comp) async {
    final db = await database;
    await db.insert('competitions', comp.toJsonSimple());
  }

  Future<Competition> getComp(int id) async {
    final db = await database;
    List<Map> result = await db.query("favorites",
        where: 'id = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return Competition.fromJsonSimple(result.first);
    }

    return null;
  }

  void removeAll() async {
    final db = await database;
    await db.delete('competitions');
  }

  Future<int> get length async {
    final db = await database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM competitions'));
  }
}

List<Competition> convertToList(results) {
  return (results.isNotEmpty) ? results.map<Competition>((c) => Competition.fromJsonSimple(c)).toList() : [];
}