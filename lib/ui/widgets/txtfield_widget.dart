import 'package:flutter/material.dart';

class TxtField extends StatelessWidget {
  final TextEditingController? controller;
  const TxtField({ Key? key, this.controller }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.only(left:8.0),
      child: TextField(
             controller: controller,
             keyboardType: const TextInputType.numberWithOptions(decimal: true),),
    );
  }
}