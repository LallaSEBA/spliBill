import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_bill_app/controller/category_provider.dart';
import '../controller/contact_provider.dart';
import '../models/category_contact.dart';
import 'ressources/ressources.dart';
import 'widgets/contact_widget.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, }) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryContact> listcategory = [];
  @override
  void initState() {
      super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    Provider.of<ListCategory>(context,listen: false).getCategories();
    listcategory =  Provider.of<ListCategory>(context,listen: true).listcategory;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(appName),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             if(listcategory.isNotEmpty)
             Container(color: Colors.teal[50],
               width: double.infinity,
               child: ListView.builder(
                shrinkWrap: true,
                itemCount: listcategory.length,
                itemBuilder: (BuildContext context, int index) {
                  CategoryContact categ = listcategory[index];
                  return Container(
                    padding: const EdgeInsets.all(20),
                    height: 230,
                    width: double.infinity,
                    color: Colors.orange[50],
                    child: Column(
                      children: [
                        Text('Ctegory: ${categ.categName}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        if(categ.listContactItem.isNotEmpty)      
                       SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: categ.listContactItem.length,
                          itemBuilder: (BuildContext context, int indexI) {
                            Contact contact = categ.listContactItem[indexI];
                            return SizedBox(
                              width: 100,
                              child: ContactWidget(contact: contact, isIconAbove: true, categ:categ.categId ,));
                          },
                        ),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    child: const Icon(Icons.check),
                    onPressed: ()=> Provider.of<ListContact>(context,listen: false)
                                    .changeSelectedList(categ.listContactItem)),
                  const Divider(endIndent: 17, thickness: 2,)
                ],
              ),);
                },
                ),
             ),         
            
          
          ]
          ),
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
