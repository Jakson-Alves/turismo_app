import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../model/ponto_turistico.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_turismo.db';
  static const _dbVersion = 2;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${PontoTuristico.nomeTabela} (
        ${PontoTuristico.campoId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PontoTuristico.campoNome} TEXT,
        ${PontoTuristico.campoDescricao} TEXT NOT NULL,
        ${PontoTuristico.campoData} TEXT,
        ${PontoTuristico.campoDiferenciais} TEXT,
        ${PontoTuristico.campoLatitude} TEXT,
        ${PontoTuristico.campoLongitude} TEXT,
        ${PontoTuristico.campoFinalizada} INTEGER NOT NULL DEFAULT 0
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 1:
        await db.execute(''' 
          ALTER TABLE ${PontoTuristico.nomeTabela}
          ADD ${PontoTuristico.campoFinalizada} INTEGER NOT NULL DEFAULT 0;
        ''');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}