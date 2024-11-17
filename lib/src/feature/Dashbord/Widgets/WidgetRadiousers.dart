import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WidgetRadioUsers extends StatelessWidget {
  Function(Object?)? onChanged;
  Object? groupValue;
  Object value;
  String Textlable;
   WidgetRadioUsers({super.key,this.onChanged,this.groupValue,required this.Textlable,required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(Textlable,style: TextStyle(fontWeight: FontWeight.w700),),
          Radio(
            value: value,
           groupValue: groupValue,
          onChanged:onChanged,
              
        ) ,],),
    );
  }
}