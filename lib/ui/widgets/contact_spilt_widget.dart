import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_bill_app/controller/contact_provider.dart';
import 'package:split_bill_app/models/contact_item.dart';

import 'txtfield_widget.dart';
class ContactSplitWidget extends StatefulWidget {
  final ContactItem contact;
  final double total;
  final int index;
  const ContactSplitWidget({ Key? key, required this.contact, required this.total, required this.index, }) : super(key: key);

  @override
  State<ContactSplitWidget> createState() => _ContactSplitWidgetState();
}

class _ContactSplitWidgetState extends State<ContactSplitWidget> {
    TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ListContact listCntPrvfnc = Provider.of<ListContact>(context,listen: false);
    listener(){
      //contact.ratio = double.parse( controller.text);
      
      listCntPrvfnc.calculateRation(double.tryParse(controller.text)??0, widget.index, widget.total);
    }
    controller.addListener(listener);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile( title: Text(widget.contact.displayName.toString()),
                  subtitle:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.contact.phones != null && widget.contact.phones!.isNotEmpty?
                                     widget.contact.phones![0].value.toString():''),
                      
                      Text(widget.contact.totalRatio.toStringAsFixed(2), style:const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                      Text('${widget.contact.ratio.toStringAsFixed(2)} %', style:const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 60,
                        child: TxtField(controller: controller,)),
                      const Text(' %'),
                    ],
                  ),
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: widget.contact.avatar!=null
                                ? CircleAvatar(backgroundImage: MemoryImage(widget.contact.avatar!))
                                : CircleAvatar(child:Text(widget.contact.displayName!=null?
                                                widget.contact.initials():'')),
                  ),
                ),
      );
    }
}