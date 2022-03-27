import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:split_bill_app/models/contact_item.dart';

class ListContact with ChangeNotifier {
  List<Contact> contacts = [];
  static List<Contact> allContacts = [];
  List<ContactItem> selectedContacts = [];

  Future<void> loadContacts() async {
   contacts = await ContactsService.getContacts();  
   allContacts = contacts;
   notifyListeners();
  }
  String formatPhoneNumber(String? phone){
    if(phone!=null) {
      return phone.replaceAllMapped(RegExp(r'\D'), (Match m)=>m[0]=='+'?'+':'');
    } else {
      return "";
    }
  }

  void findContact(String researchCont){
   List<Contact> filtredContacts = [];
   filtredContacts.addAll(allContacts);
   String formatrechWord = formatPhoneNumber(researchCont);
   if(researchCont.isNotEmpty){
     String rechWord = researchCont.toLowerCase();
     filtredContacts.retainWhere((element) {
       if(isSelected(element)>-1) {
         return false;
       } 
       else {
              bool nameMatched = element.displayName.toString().toLowerCase().contains(rechWord);
              if(nameMatched) {
                return true;
              } 
                else if(element.phones != null && formatrechWord.isNotEmpty){
                Item phone = element.phones!.firstWhere((nbPhone) {
                    String formatPhone = formatPhoneNumber(nbPhone.value);
                    return formatPhone.contains(formatrechWord);
                    }, orElse: () => Item());
                  bool isNotNull = phone.value != null;  
                return (isNotNull);
                }
                else {
                  return false;
                }
      }
     });
       contacts = filtredContacts;
     
   }
   else {
       contacts = allContacts;
   }
   notifyListeners();
  }
  
  int isSelected(Contact cnt){
    int index = selectedContacts.indexWhere((element) => element.identifier==cnt.identifier);
    return index;
  }
  selectContact(Contact cnt,){
    selectedContacts.add(ContactItem(cnt));
    contacts.removeAt(contacts.indexWhere((element) => element.identifier == cnt.identifier));
    notifyListeners();
  }

  unSelectContact(Contact cnt,){
    selectedContacts.removeAt(selectedContacts.indexWhere((element) => element.identifier == cnt.identifier));
    contacts.add(cnt);
    notifyListeners();
  }
  unSelectAllContact(){
    selectedContacts.clear();
    contacts = allContacts;
    notifyListeners();
  }

  calculateRation(double value, int index, total){
    if(value >100 ) {
      selectedContacts[index].ratio = 100;
    }
    else {
      selectedContacts[index].ratio = value;
    }      
    if(selectedContacts.length-1>0) {
      for(ContactItem cnt in selectedContacts){
        cnt.totalRatio = total*cnt.ratio/100;
        if(selectedContacts[index].identifier != cnt.identifier) {
          cnt.ratio = (100-selectedContacts[index].ratio)/(selectedContacts.length-1);
          cnt.totalRatio = total*cnt.ratio/100;
        }
     }
    }
    notifyListeners();
  }
  calculateAllRation(total){
    if(selectedContacts.isNotEmpty) {
      for(ContactItem cnt in selectedContacts){
          cnt.ratio = 100/selectedContacts.length;
          cnt.totalRatio = total*cnt.ratio/100;
      }
    }
    notifyListeners();
  }

  changeSelectedList(sltContacts){
    unSelectAllContact();
    selectedContacts = sltContacts;
    
    notifyListeners();
  }
}