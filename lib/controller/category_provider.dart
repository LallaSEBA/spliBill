
import 'package:flutter/widgets.dart';
import '../models/category_contact.dart';
import 'dbmanager.dart';

class ListCategory with ChangeNotifier {
  List<CategoryContact> listcategory = [];
  getCategories()async{
      listcategory = await DBManager.getAllCategies();
      notifyListeners();
  }
}