import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WidgetStepperContiner extends StatelessWidget {
  String Lable;String value;Widget icon;void Function()? onTap;
   WidgetStepperContiner({super.key,required this.Lable,required this.icon,required this.value,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end,mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("$Lable",style: TextStyle(color: Color(0xFF006400),fontSize: 15,fontWeight: FontWeight.w700),),
        GestureDetector(onTap: onTap,
          child: Container(margin: EdgeInsets.symmetric(vertical: 5,),padding: EdgeInsets.only(right: 10,left: 20),height: 50,width: double.infinity,decoration: BoxDecoration(color: AppColors().darkGreenForms,border: Border.all(width: 1,color: Colors.white,),borderRadius: BorderRadius.circular(10)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,textDirection: TextDirection.ltr,children: [Text(""),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("$value",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400)),
                        ),icon],),
                        ),
        ),
      ],
    );
  }
}