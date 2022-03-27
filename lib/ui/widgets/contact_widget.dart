import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_bill_app/controller/dbmanager.dart';
import '../../controller/contact_provider.dart';

class ContactWidget extends StatelessWidget {
  final Contact contact;
  final bool isIconAbove;
  final String? categ ;
  const ContactWidget({ Key? key, required this.contact, this.isIconAbove=false, this.categ }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ListContact listCntPrv = Provider.of<ListContact>(context,listen: false);
    if(isIconAbove) {
      Contact c = contact;
    print("initials: ${c.initials()}");
    print("initials: ${contact.displayName}");
      return ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                          const SizedBox(height: 8,), 
                    Stack(alignment: Alignment.topLeft,
                        children: [
                          contact.avatar!=null
                                  ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar!))
                                  : CircleAvatar(child:Text(contact.displayName!=null?
                                                  contact.initials():'')),
                          Positioned(
                            top: -17,
                            right: -13,
                            child: SizedBox(
                              height: 50,
                              width: 40,
                              child: TextButton(
                                onPressed: () async{ 
                                  if(categ!=null) {
                                    await DBManager.deletecontact(contact.identifier, categ);
                                  }
                                  else {
                                    listCntPrv.unSelectContact(contact,);
                                  }
                                },
                                child: const Text('X', textAlign: TextAlign.center, 
                                              style: TextStyle( color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),]),
                          const SizedBox(height: 8,), 
                          Text(contact.displayName.toString(),
                               maxLines: 2,
                               overflow: TextOverflow.clip,),
                 ],
                ),
                subtitle: 
                 const Text('', style: TextStyle(fontSize: 0),),
              );
    } else {
      return ListTile( title: Text(contact.displayName.toString()),
                subtitle:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(contact.phones!=null && contact.phones!.isNotEmpty?
                                   contact.phones![0].value.toString():''),
                    SizedBox(
                      height: 30,
                      width: 40,
                      child: FloatingActionButton(
                        heroTag: null,
                        child: const Icon(Icons.check), 
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: (){

                                  listCntPrv.selectContact(contact,);
                        }))
                  ],
                ),
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: contact.avatar!=null
                              ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar!))
                              : CircleAvatar(child:Text(contact.displayName!=null?
                                              contact.initials():'')),
                       
                  ),
              );
    }
  }
}