// ignore: file_names

import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WidgetTextfiledDash extends StatelessWidget {
  bool? enabled=true;void Function()? onTap;
  String label;TextEditingController? controller;Widget widget;String? Labelvlaue;int? maxLines = 1;String? Function(String?)? validator;
   WidgetTextfiledDash({Key? key,this.onTap,this.enabled, this.controller,required this.label,required this.widget,this.Labelvlaue,this.maxLines,this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("$Labelvlaue",style: TextStyle(color: Color(0xFF006400),fontSize: 15,fontWeight: FontWeight.w600),textDirection: TextDirection.rtl,),
        TextFormField(
          onTap: onTap,
          enabled:enabled ,
          validator:validator ,
          maxLines: maxLines,
          controller: controller,textAlign: TextAlign.center,
          
          decoration: InputDecoration(
           
            suffixIcon: widget,
            hintTextDirection: TextDirection.rtl,
            hintText: label,
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.all(10),
            filled: true,fillColor:AppColors().darkGreenForms,
            border: InputBorder.none,
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8.0,),

            ),
            focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        
        ),
      ],
    );
  }
}
