import 'dart:async';
import 'dart:io';
import 'package:firstapp/screens/analysis/card_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class invoice_details {
  String tag;
  String invNum;
  String name;
  String date;
  String quantity;
  String amount;
  int? type;

  invoice_details({
    required this.tag,
    required this.invNum,
    required this.name,
    required this.date,
    required this.quantity,
    required this.amount,
    this.type,
  });
  factory invoice_details.fromMap(Map<String, dynamic> json) => invoice_details(
        tag: json['tag'],
        invNum: json['invNum'],
        name: json['name'],
        date: json['date'],
        quantity: json['quantity'],
        amount: json['amount'],
        type: json['type'],
      );
  Map<String, dynamic> toMap() {
    return {
      'tag': tag,
      'invNum': invNum,
      'name': name,
      'date': date,
      'quantity': quantity,
      'amount': amount,
      'type': type,
    };
  }
}

class DetailHelper {
  DetailHelper._privateConstructor();
  static final DetailHelper instance = DetailHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documensDirectory = await getApplicationDocumentsDirectory();
    String path = join(documensDirectory.path, 'detail.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE DETAIL(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,tag TEXT,invNum TEXT,name TEXT,date TEXT,quantity TEXT,amount TEXT,type INTEGER)
''');
  }

  Future<List<invoice_details>> getDetail(String tag, String invNum) async {
    Database db = await instance.database;
    var detail = await db.rawQuery(
        'SELECT * FROM detail WHERE invNum = ? AND tag = ?', [invNum, tag]);
    List<invoice_details> detailList = detail.isNotEmpty
        ? detail.map((c) => invoice_details.fromMap(c)).toList()
        : [];
    return detailList;
  }

  Future<void> updateType(CardInfo cards, int type) async {
    Database db = await instance.database;

    await db.rawUpdate(
        'UPDATE detail SET tag = ? , invNum = ? , name = ? ,date = ? ,quantity =? ,amount =? ,type = ? WHERE invNum = ? AND name = ?',
        [
          cards.tag,
          cards.invnum,
          cards.name,
          cards.date,
          cards.quantity,
          cards.amount,
          type,
          cards.invnum,
          cards.name
        ]);
  }

  Future<int> add(invoice_details detail) async {
    Database db = await instance.database;
    return await db.insert('detail', detail.toMap());
  }

  Future<void> delete() async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM detail');
  }
}
