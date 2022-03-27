import 'package:flutter/material.dart';
import 'package:split_bill_app/ui/ressources/ressources.dart';

class SplitDrawer extends StatelessWidget {
  const SplitDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[50],
      width: MediaQuery.of(context).size.width *.5,
      height: double.maxFinite,
      child: TextButton(
        onPressed: () => Navigator.of(context).pushNamed(routeCategScreen),
        child: const Text(strCateg),),
    );
  }
}