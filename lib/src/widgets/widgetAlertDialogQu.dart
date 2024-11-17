import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

// ignore: must_be_immutable
class widgetAlertDialogQu extends StatelessWidget {
  String? title;
  Widget? widget;
  void Function()? onPressed;
   widgetAlertDialogQu({super.key,this.onPressed,this.widget,this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                              title: Center(child: CircleAvatar(backgroundColor: Colors.red,child: widget),),
                              content: Container(height: 50,width: double.maxFinite,child: Center(child: 
                              Text('$title',style: TextStyle(color: AppColors().darkGreen,fontWeight: FontWeight.w600,fontSize: 16),)
                              ,),),
                              actions: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Container(width: 90,
                   child: MaterialButton(
                    minWidth: 15,
                    color: Colors.red[100],
                    onPressed: (){Get.back();},child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.error_outline_rounded,color: Colors.red,),Text("الغاء",style: TextStyle(fontWeight: FontWeight.bold))],),),
                 ),
                 Container(width: 90,
                   child: MaterialButton(
                    minWidth: 150,
                    color:AppColors().lighBrown,
                    onPressed:onPressed ,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.save,color: Colors.green,),Text("نعم",style: TextStyle(fontWeight: FontWeight.bold),)],),),
                 )
                 ],)
                              ],
                            );
  }
}


                                    