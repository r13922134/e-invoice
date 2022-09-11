import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class WinningList {
  String tag;
  String superPrizeNo;
  String firstPrizeNo1;
  String firstPrizeNo2;
  String firstPrizeNo3;
  String spcPrizeNo;

  WinningList({
    required this.tag,
    required this.superPrizeNo,
    required this.firstPrizeNo1,
    required this.firstPrizeNo2,
    required this.firstPrizeNo3,
    required this.spcPrizeNo,
  });
  factory WinningList.fromMap(Map<String, dynamic> json) => WinningList(
        tag: json['tag'],
        superPrizeNo: json['superPrizeNo'],
        firstPrizeNo1: json['firstPrizeNo1'],
        firstPrizeNo2: json['firstPrizeNo2'],
        firstPrizeNo3: json['firstPrizeNo3'],
        spcPrizeNo: json['spcPrizeNo'],
      );
  Map<String, dynamic> toMap() {
    return {
      'tag': tag,
      'superPrizeNo': superPrizeNo,
      'firstPrizeNo1': firstPrizeNo1,
      'firstPrizeNo2': firstPrizeNo2,
      'firstPrizeNo3': firstPrizeNo3,
      'spcPrizeNo': spcPrizeNo,
    };
  }
}

class WlistHelper {
  WlistHelper._privateConstructor();
  static final WlistHelper instance = WlistHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documensDirectory = await getApplicationDocumentsDirectory();
    String path = join(documensDirectory.path, 'wlist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE WLIST(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,tag TEXT,superPrizeNo TEXT,firstPrizeNo1 TEXT,firstPrizeNo2 TEXT,firstPrizeNo3 TEXT,spcPrizeNo TEXT)
''');
  }

  Future<List<WinningList>> get(String current) async {
    Database db = await instance.database;
    var wlist =
        await db.query('wlist', where: '"tag" = ?', whereArgs: [current]);

    List<WinningList> wwList = wlist.isNotEmpty
        ? wlist.map((c) => WinningList.fromMap(c)).toList()
        : [];
    return wwList;
  }

  Future<bool> checkWlist(String tag) async {
    Database db = await instance.database;
    var wlist = await db.query('wlist', where: '"tag" = ? ', whereArgs: [tag]);
    List<WinningList> wwList = wlist.isNotEmpty
        ? wlist.map((c) => WinningList.fromMap(c)).toList()
        : [];
    if (wwList.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<int> add(WinningList w) async {
    Database db = await instance.database;
    return await db.insert('wlist', w.toMap());
  }
}
