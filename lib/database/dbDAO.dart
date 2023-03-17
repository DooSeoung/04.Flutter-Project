import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as dbdb;
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper{

  //DatabaseHelper는 user-definde, 주로 DBHelper
  static Future<Database> database() async {
    final dbpath = await dbdb.getDatabasesPath();
    return dbdb.openDatabase(path.join(dbpath,'caldb.db'),
        onCreate: (db, version){
          return db.execute( //테이블 생성
            //'''CREATE TABEL sawont(id TEXT PRIMARY KEY, irum TEXT, tel TEXT)''');
              '''CREATE TABLE calt(id TEXT PRIMARY KEY, title TEXT, content TEXT, startd TEXT, endd TEXT, checkBox INTEGER)''');

        }, version: 1);
  }

  //CRUD 중 R
  static Future<List<Map<String, Object?>>> getAllCal(String dbt) async {
    final db = await DatabaseHelper.database();
    return db.query(dbt);//조회
  }
  // 예) 'id':30 =====> key:value를 List에 넣어 반환한다

  static Future<List<Map<String, Object?>>> getCal(String dbt, String startd) async {
    final db = await DatabaseHelper.database();
    return db.query(dbt, where: 'startd = ?', whereArgs: [startd]);//조회
  }
  //CRUD 중 C
  static Future<void> insertCal(String dbt, Map<String, Object> data) async {
    final db = await DatabaseHelper.database();
    db.insert(dbt, data);//조회
  }//sawon에 key:value map data를 insert

  //CRUD 중 U
  static Future<void> updateCal(String dbt, Map<String, Object> data, String id) async {
    final db = await DatabaseHelper.database();
    db.update(dbt, data, where: 'id = ?', whereArgs: [id]);//조회
    // sawont 테이블에서 검색인자는 id인데 해당 id인 자료를 찾아
    // key:value map data로 update
  }

  //CRUD 중 D
  static Future<void> deleteCal(String dbt, String id) async {
    final db = await DatabaseHelper.database();
    db.delete(dbt, where: 'id = ?', whereArgs: [id]);//조회
  }
//sawont에서 검색인자는 id인데 해당 id인 자료를 찾아 delete
//Futer + async + await이므로 CRUD 모두 비동기 방식을 처리됨

  //------------------------------------------
  static Future<List<Map<String, Object?>>> getDateTimes(String dbt) async{
    final db = await DatabaseHelper.database();
    return db.query(dbt, columns: ['startd'],distinct: true, orderBy: 'startd');
                                          // 날짜의 중복을 제거
  }
  static Future<List<Map<String, Object?>>> getEvents(String dbt, startd) async{
    final db = await DatabaseHelper.database();
    return db.query(dbt, where: 'startd = ?', whereArgs: [startd], orderBy: 'startd');
  }
}