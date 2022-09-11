import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Header {
  String tag;
  String date;
  String time;
  String seller;
  String address;
  String invNum;
  String barcode;
  String amount;
  String w;
  Header({
    required this.tag,
    required this.date,
    required this.time,
    required this.seller,
    required this.address,
    required this.invNum,
    required this.barcode,
    required this.amount,
    required this.w,
  });
  factory Header.fromMap(Map<String, dynamic> json) => Header(
        tag: json['tag'],
        date: json['date'],
        time: json['time'],
        seller: json['seller'],
        address: json['address'],
        invNum: json['invNum'],
        barcode: json['barcode'],
        amount: json['amount'],
        w: json['w'],
      );
  Map<String, dynamic> toMap() {
    return {
      'tag': tag,
      'date': date,
      'time': time,
      'seller': seller,
      'address': address,
      'invNum': invNum,
      'barcode': barcode,
      'amount': amount,
      'w': w,
    };
  }
}

class HeaderHelper {
  HeaderHelper._privateConstructor();
  static final HeaderHelper instance = HeaderHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documensDirectory = await getApplicationDocumentsDirectory();
    String path = join(documensDirectory.path, 'header.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE HEADER(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,tag TEXT,date TEXT,time TEXT,seller TEXT,address TEXT,invNum TEXT,barcode TEXT,amount TEXT,w TEXT)
''');
  }

  Future<List<Header>> getAll() async {
    Database db = await instance.database;
    var header = await db.query('header', orderBy: 'tag');
    List<Header> headerList =
        header.isNotEmpty ? header.map((c) => Header.fromMap(c)).toList() : [];
    return headerList;
  }

  Future<List<Header>> getHeader(String current) async {
    Database db = await instance.database;
    var header = await db.query('header',
        orderBy: 'date', where: '"tag" = ?', whereArgs: [current]);
    List<Header> headerList =
        header.isNotEmpty ? header.map((c) => Header.fromMap(c)).toList() : [];
    return headerList;
  }

  Future<List<Header>> getHeader_date(String current) async {
    Database db = await instance.database;
    var header =
        await db.query('header', where: '"date" = ?', whereArgs: [current]);
    List<Header> headerList =
        header.isNotEmpty ? header.map((c) => Header.fromMap(c)).toList() : [];
    return headerList;
  }

  Future<bool> getScanHeader(String invNum, String date) async {
    Database db = await instance.database;
    var header = await db.query('header',
        where: '"invNum" = ? AND date = ?', whereArgs: [invNum, date]);
    List<Header> headerList =
        header.isNotEmpty ? header.map((c) => Header.fromMap(c)).toList() : [];
    if (headerList.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<int> add(Header header) async {
    Database db = await instance.database;
    return await db.insert('header', header.toMap());
  }

  Future<void> delete() async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM header');
  }

  Future<void> deleteold(String invNum) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM header WHERE invNum = ?', [invNum]);
  }

  Future<bool> checkHeader(String inv, String date) async {
    Database db = await instance.database;
    var header = await db.query('header',
        where: '"invNum" = ? AND date = ?', whereArgs: [inv, date]);
    List<Header> headerList =
        header.isNotEmpty ? header.map((c) => Header.fromMap(c)).toList() : [];
    if (headerList.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<Topbar> count(String current) async {
    Database db = await instance.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(*) FROM header WHERE tag = ?', [current])) ??
        0;

    var amount = await db.query('header',
        columns: ['amount'], where: '"tag" = ? ', whereArgs: [current]);
    List<Header> amountList =
        amount.isNotEmpty ? amount.map((c) => Header.fromMap(c)).toList() : [];
    var wamount = await db.query('header',
        columns: ['w'],
        where:
            '"tag" = ? AND ("w" = ? OR "w" = ? OR "w" = ? OR "w" = ? OR "w" = ? OR "w" = ? OR "w" = ? OR "w" = ? OR "w" = ?)',
        whereArgs: [
          current,
          '500',
          '10000000',
          '2000000',
          '200000',
          '40000',
          '10000',
          '4000',
          '1000',
          '200'
        ]);
    List<Header> wamountList = wamount.isNotEmpty
        ? wamount.map((c) => Header.fromMap(c)).toList()
        : [];
    int total = 0;
    int winamount = 0;
    for (Header h in amountList) {
      total += int.parse(h.amount);
    }
    for (Header h in wamountList) {
      winamount += int.parse(h.w);
    }
    return Topbar(count: count, total: total, winamount: winamount);
  }

  Future<void> update(Header h, String m) async {
    Database db = await instance.database;

    await db.rawUpdate(
        'UPDATE header SET tag = ? , date = ? ,time = ? ,seller =? ,address =? ,invNum = ? ,barcode = ? ,amount = ? ,w = ? WHERE invNum = ? AND tag = ?',
        [
          h.tag,
          h.date,
          h.time,
          h.seller,
          h.address,
          h.invNum,
          h.barcode,
          h.amount,
          m,
          h.invNum,
          h.tag
        ]);
  }
}

class Topbar {
  int count;

  int total;
  int winamount;
  Topbar({
    required this.count,
    required this.total,
    required this.winamount,
  });
}
