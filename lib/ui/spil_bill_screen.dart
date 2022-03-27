import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:split_bill_app/controller/contact_provider.dart';
import 'package:split_bill_app/controller/utils.dart';
import 'package:split_bill_app/models/contact_item.dart';
import 'ressources/ressources.dart';

import 'widgets/contact_spilt_widget.dart';
import 'widgets/drawer.dart';
import 'widgets/txtfield_widget.dart';

class SpitBillScreen extends StatefulWidget {
  const SpitBillScreen({ Key? key }) : super(key: key);

  @override
  State<SpitBillScreen> createState() => _SpitBillScreenState();
}

class _SpitBillScreenState extends State<SpitBillScreen> {
  TextEditingController billCont = TextEditingController();
  TextEditingController tipCont  = TextEditingController();
  TextEditingController taxCont  = TextEditingController();
  
  bool autoCalculateRatio = true;
  double tip    = 0;
  double tax    = 0;
  double bill   = 0;
  double total = 0.0;
   getTotal() {
     bill  = double.tryParse(billCont.text)??0.0; 
     tax  = double.tryParse(taxCont.text)??0.0; 
     tip = double.tryParse(tipCont.text)??0.0; 
    setState(() {
      total = bill*(1+tip/100 + tax/100);
      
    });
    if(autoCalculateRatio)
    {
      ListContact listCntPrvfnc = Provider.of<ListContact>(context,listen: false);
      listCntPrvfnc.calculateAllRation(total);
    }
  }
  
  @override
  void initState(){
    billCont.addListener(getTotal);
    tipCont.addListener(getTotal);
    taxCont.addListener(getTotal);
    super.initState();
  }

  @override
  void dispose(){
    billCont.dispose();
    tipCont.dispose();
    taxCont.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double withColumnDetail = MediaQuery.of(context).size.width * .5;

    ListContact listCntPrv = Provider.of<ListContact>(context,listen: true);
    return SafeArea(
      child: GestureDetector(
        onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
        child: Scaffold(
          drawer: const SplitDrawer(),
          floatingActionButton: FloatingActionButton(
                                     child: const Icon(Icons.people),
                                     heroTag: 'splitTag',
                                     onPressed: () => Navigator.of(context).pushNamed(routeCntScreen), ),
          appBar: AppBar(
            title: const Text(appName),),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal:10, vertical: 10),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Total :\n\n ${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 30),),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton(
                              child: const Text(strSnipBill),
                              onPressed: ()async {
                               /* String scanTxt = await getImage();
                                if(double.tryParse(scanTxt) != null) {
                                  total = double.tryParse(scanTxt)!;
                                }*/
                              }),
                          ), 
                        ],
                      ),
                      SizedBox(
                        width: withColumnDetail,
                        child: Column(children: [
                          Row(children: [
                            const Text('Bill:'),
                            TxtField(controller: billCont,),
                            const Text(' %'),
                          ],),
                          Row(children: [
                            const Text('Tax:'),
                            TxtField(controller: taxCont,),
                            const Text(' %'),
                          ],),
                          Row(children: [
                            const Text('Tip:'),
                            TxtField(controller: tipCont,),
                            const Text(' %'),
                          ],),
                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Row(
                              children: [
                                const Text(autoCalculate, style: TextStyle(fontSize: 12),),
                                Switch(
                                  value: autoCalculateRatio, 
                                  onChanged:(val) => setState(()=> autoCalculateRatio = val)
                                ),
                              ],
                            ),
                          )
                        ],),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(20)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listCntPrv.selectedContacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      ContactItem contact = listCntPrv.selectedContacts[index];
                      return SizedBox(
                        width: 100,
                        child: ContactSplitWidget(contact: contact, total: total, index: index,));
                    },) 
                )
            ],),
        ),
      ),
    );
  }
}