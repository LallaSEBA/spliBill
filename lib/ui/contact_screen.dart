import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_bill_app/controller/contact_provider.dart';
import 'package:split_bill_app/controller/dbmanager.dart';
import 'package:split_bill_app/models/category_contact.dart';
import 'ressources/ressources.dart';
import 'widgets/contact_widget.dart';


class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key, }) : super(key: key);
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];
  TextEditingController researchCont = TextEditingController();
  TextEditingController categCont   = TextEditingController();
  bool onAddingCateg = false;

  findContact(){
    Provider.of<ListContact>(context, listen:false).findContact(researchCont.text);
  }
  
  @override
  void initState() {
    super.initState();
    researchCont.addListener(findContact);
    Provider.of<ListContact>(context, listen:false).loadContacts();
  }
 
  @override
  void dispose() {
    researchCont.dispose();
    categCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ListContact listCntPrv = Provider.of<ListContact>(context,listen: true);
    ListContact listCntPrvFnc = Provider.of<ListContact>(context,listen: false);
    contacts = listCntPrv.contacts;
    selectedContacts = listCntPrv.selectedContacts;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(appName),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
             padding: const EdgeInsets.all(10),
             child: Row(
               children: [
                 Flexible(
                   child: TextField(
                     controller: researchCont,
                     decoration: const InputDecoration(
                       label:Text(strSearch),
                       prefixIcon: Icon(Icons.search),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.all( Radius.circular(20)),
                         borderSide: BorderSide(
                          color: Colors.black
                         )
                       )),
                   ),
                 ),
                 TextButton(onPressed: ()=>listCntPrvFnc.unSelectAllContact(), child: const Text(strUnselectAll))
               ],
             ),),
           if(selectedContacts.isNotEmpty)
           Container(color: Colors.teal[50],
             width: double.infinity,
             child: Stack(
               children: [
                 SizedBox(
                    height: 160,
                   child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedContacts.length,
                    scrollDirection:Axis.horizontal ,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = selectedContacts[index];
                      return SizedBox(
                        width: 100,
                        child: ContactWidget(contact: contact, isIconAbove: true,));
                    },
                  ),
                 ),
                 Positioned(
                   bottom: 5,
                   right: 10,
                   child: Padding(
                     padding: const EdgeInsets.only(top:8.0),
                     child: Row(
                       children: [
                         if(onAddingCateg)
                         SizedBox(
                           width: 100, 
                           child: TextField(controller: categCont,)),
                         FloatingActionButton(
                           heroTag: 'contactTag',
                           child: const Text(strAddCateg, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                           onPressed: ()async{
                             if(onAddingCateg && categCont.text.isNotEmpty) {
                               await DBManager.addCategory(CategoryContact(categName: categCont.text, listContact: selectedContacts));
                             }
                             categCont.text = '';
                             setState(() => onAddingCateg = !onAddingCateg);
                           }),
                       ],
                     ),
                   ),
                 )
               ],
             ),
           ),         
          Expanded(
             child: Container(
               padding: const EdgeInsets.all(20),
               child: ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = contacts[index];
                  return ContactWidget(contact: contact, isIconAbove: false,);
                },
            ),
             ),
           ),
        
        ]
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
