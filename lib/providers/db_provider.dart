import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _dataBase;
  static final DBProvider db = DBProvider._();
  int versionPath = 1;
  DBProvider._();

  Future<Database> get database async {
    if (_dataBase != null) return _dataBase!;

    _dataBase = await initDB();

    return _dataBase!;
  }

  Future<Database> initDB() async {
    versionPath++;
    //Path de donde almacenamos la base de datos
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'ScansDB.db');
    print(path);

    return await openDatabase(
      path,
      version: versionPath,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE Scans(
              id INTEGER PRIMARY KEY,
              type TEXT,
              value TEXT
            )
        ''');
      },
    );
  }

  newScanRaw(ScanModel newScan) async {
    final id = newScan.id;
    final type = newScan.type;
    final value = newScan.value;

    //Verifica la BD
    final db = await database;

    final res = await db.rawInsert('''
      INSERT INTO Scans( id, type, value)
        VALUES($id, $type, $value)
    ''');
    return res;
  }

  Future<int> newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.insert('Scans', newScan.toJson());
    //Es el ID del ultimo registro insertado
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>?> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
  }

  Future<List<ScanModel>?> getScanByType(String type) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE type = '$type'    
    ''');

    return res.isNotEmpty ? res.map((s) => ScanModel.fromJson(s)).toList() : [];
  }

  Future<int> updateScan(ScanModel updateScan) async {
    final db = await database;
    final res = await db.update('Scans', updateScan.toJson(),
        where: 'id = ?', whereArgs: [updateScan.id]);

    return res;
  }

  Future<int> deleteScanById(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('''
        DELETE FROM Scans
    ''');
    return res;
  }
}
