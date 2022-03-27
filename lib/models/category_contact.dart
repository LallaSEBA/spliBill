import 'package:contacts_service/contacts_service.dart';
import 'package:split_bill_app/models/contact_item.dart';

class CategoryContact{
  String? categId;
  String categName = '';
  List<ContactItem> listContactItem =[];
  CategoryContact({required this.categName, required List<Contact> listContact} ){
    for(Contact cnt in listContact){
    listContactItem.add(ContactItem(cnt));
    }
  }

   Map<String, dynamic> tomap() {
    var map = <String, dynamic>{};
    map['categoryId']   = categId;
    map['categoryName'] = categName;

    return map;
  }

   CategoryContact.fromMap(Map<String, dynamic>? map) {
     if(map != null){
      categId        = "${map['categoryId']}";
      categName      = map['categoryName'];
     }
  }
}