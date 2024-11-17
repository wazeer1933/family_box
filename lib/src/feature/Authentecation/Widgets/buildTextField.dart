// ignore: file_names

import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class buildTextField extends StatelessWidget {
  List<TextInputFormatter>? inputFormatters=[];
  bool readOnly = false;bool obscureText = false;String? initialValue;TextInputType? keyboardType=TextInputType.text;
  bool? enabled=false;void Function()? onTap;void Function(String)? onChanged;
  String label; TextEditingController? controller;Widget widget;String? Labelvlaue;String? Function(String?)? validator;
   buildTextField({Key? key,required this.obscureText,this.initialValue,this.inputFormatters, this.keyboardType,required this.readOnly,this.controller,this.onChanged,this.onTap,this.enabled,required this.label,required this.widget,this.Labelvlaue,this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      initialValue:initialValue ,
      // onTapOutside: (event) => print(object),
    obscureText:obscureText ,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      controller: controller,textAlign: TextAlign.center,
      decoration: InputDecoration(
        
        suffixIcon: widget,
        hintTextDirection: TextDirection.rtl,
        hintText: label,
        hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.all(10),
        filled: true,fillColor: AppColors().darkGreenForms,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    
    );
  }
}




// ignore: must_be_immutable
class buildTextField1 extends StatelessWidget {

  String label; TextEditingController? controller;Widget widget;String? Labelvlaue;String? Function(String?)? validator;
   buildTextField1({Key? key ,this.controller,required this.label,required this.widget,this.Labelvlaue,this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
     
      // onTapOutside: (event) => print(object),

   
      validator: validator,
 
      controller: controller,textAlign: TextAlign.center,
      decoration: InputDecoration(
        
        suffixIcon: widget,
        hintTextDirection: TextDirection.rtl,
        hintText: label,
        hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.all(10),
        filled: true,fillColor: AppColors().darkGreenForms,
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    
    );
  }
}
