

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static late Database db ;
  static Future<void> open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    db = await openDatabase(path,version: 1,
    onCreate : (Database db, int version) async {
      // When creating the db, create the table
        await db.execute(
            """
            CREATE TABLE Test (
              id INTEGER PRIMARY KEY, 
              name TEXT, 
              value INTEGER, 
              num REAL)
            """);
      }
    );

  }

  static Future<List<Map>> select(String sql,List params) async{
    // ignore: unnecessary_null_comparison
    if(db==null){
      await open();
    }
    List<Map> list = await db.rawQuery(sql,params);
    return list ;
  }



  static Future<int> insert(String sql,List params) async{
      // ignore: unnecessary_null_comparison
      if(db==null){
        await open();
      }
      int re = await db.rawInsert(sql,params);
      return re ;
  }


  static Future<int> update(String sql,List params) async{
    // ignore: unnecessary_null_comparison
    if(db==null){
        await open();
    }
    
    int re = await db.rawUpdate(sql,params);
    return re ;
  
  }


    static Future<int> delete(String sql,List params) async{
    // ignore: unnecessary_null_comparison
    if(db==null){
        await open();
    }
    
    int re = await db.rawDelete(sql,params);
    return re ;
  
  }

 


}