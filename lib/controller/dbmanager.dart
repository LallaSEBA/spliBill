import 'dart:async';
import 'package:split_bill_app/models/category_contact.dart';

import '../models/contact_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager{
  static String cntTable       = 'Contact';
  static String categoryTable  = 'Category';
  static String cntId          = 'cntId';
  static String cntName        = 'cntName';
  static String categoryId     = 'categoryId';
  static String categoryName   = 'categoryName';

  static Database? _db;
  

  static Future<void> intDB() async {
    if (_db!=null){
      return;
    }
    try{
      String dbpath = await getDatabasesPath();
   //  Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(dbpath, "splitapp.db");
     _db = await openDatabase(path, version: 1,
                     onCreate: (dbb, version)async{
                                  String sql = "CREATE TABLE $categoryTable($categoryId INTEGER PRIMARY KEY AUTOINCREMENT , $categoryName Text)";
                                  await dbb.execute(sql);
                                  sql = "CREATE TABLE $cntTable($cntId Text, $cntName TEXT, $categoryId INTEGER, PRIMARY KEY($cntId, $categoryId))";
                                  await dbb.execute(sql);
                                  
            });
    // ignore: empty_catches
    }catch(e){
    }
  }

  static Future<int> addCategory(CategoryContact categ )  async{
    var result   = await _db!.insert(categoryTable, {categoryName: categ.categName},  conflictAlgorithm: ConflictAlgorithm.replace);
    for(ContactItem cnt in categ.listContactItem){
      await addcontact(cnt, result ); 
    }
    return result;
  }
  Future<int> updateCateg(CategoryContact categ)  async{
    var result   = await _db!.update(cntTable,  {categoryName: categ.categName}, where:'$categoryId=?',whereArgs: [categ.categId],);
    return result;
  }
  static Future<List<CategoryContact> > getAllCategies() async{
    List<Map<String, dynamic> > map = await _db!.rawQuery('SELECT * FROM  $categoryTable ', );
    List<CategoryContact> listCateg = [];
    for(Map<String, dynamic> m in map)
    {
      CategoryContact categ = CategoryContact.fromMap(m);
      List<ContactItem> listItm = await getcontactByCateg( m[categoryId]);
      categ.listContactItem = listItm;
      listCateg.add(categ);
    }
    return listCateg;
  }

  static Future getCategyId(String idCateg)async{
    List<Map> map = await _db!.rawQuery('SELECT $categoryName FROM  $categoryTable WHERE ($categoryId = ?)', [idCateg]);
    return map.isNotEmpty? map[0]:null;
  }

  // add contact
  static Future<int> addcontact(ContactItem cntItem, int categ )  async{
    Map<String, dynamic> map = cntItem.tomap();
    map[categoryId] = '$categ';
    var result   = await _db!.insert(cntTable, map,  conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  //delete contact
  static Future<int> deletecontact(cnt, categ)  async{
    int result;
    result = await _db!.delete(cntTable,where:'( $cntId=? and $categoryId=? )',whereArgs: [cnt, categ] );
    
    return result;
  }

  //get all contact
  static Future<List> getAllcontact() async{
    List<Map<String, dynamic>>  result = await _db!.query(cntTable,);
    List listCnt = result.map((item) => ContactItem.fromMap(item)).toList();

    return listCnt;
  }
  
  static Future<ContactItem> getcontactById(String idcontact)async{
    List<Map> map = await _db!.rawQuery('SELECT * FROM  $cntTable WHERE ($cntId = ?)', [idcontact]);
    return ContactItem.fromMap(map.isNotEmpty?  {'id': map[0][cntId], 'name': map[0][cntName]}:null);
  }

  static Future<List<ContactItem>> getcontactByCateg(int categ)async{
    List<Map> map = await _db!.rawQuery('SELECT * FROM  $cntTable WHERE ($categoryId = ?)', [categ]);
    List<ContactItem> cntList =[];
    for (var element in map) {
      ContactItem itemCnt = ContactItem.fromMap(map.isNotEmpty?  {cntId: element[cntId], cntName: element[cntName]}:null);
      cntList.add(itemCnt);
    }
    return cntList;
  }

  //get contacts count
  static Future<int?> getcontactCount()async{
    return Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM  $cntTable'));
  }
}