import 'package:contacts_service/contacts_service.dart';


class ContactItem extends Contact{
  List<Item>? phone;
  double ratio = 0;
  double totalRatio = 0;
  ContactItem(Contact cnt){
   //Contact cnt = ListContact.allContacts.firstWhere((element) => element.identifier == id, orElse: ()=> Contact());
   avatar = cnt.avatar;
   phone  = cnt.phones;
   displayName   = cnt.displayName;
   familyName    = cnt.familyName;
   identifier    = cnt.identifier;
   givenName = cnt.givenName;
  }

  Map<String, dynamic> tomap() {
    var map = <String, dynamic>{};
    map['cntId']    = identifier;
    map['cntName']  = displayName??'';

    return map;
  }
  @override
  String initials(){
   return super.initials();
  }

   ContactItem.fromMap(Map<String, dynamic>? map) {
     if(map != null){
      identifier       = map['cntId'];
      displayName      = map['cntName'];
     }
  }
   
   
   ContactItem.fromList(List list) {
    identifier  = list[0].toString();
    displayName = list[1].toString();
  }
  


  List tolist() {
    var map = [];
    map = [ identifier, displayName,];

    return map;
  }


}