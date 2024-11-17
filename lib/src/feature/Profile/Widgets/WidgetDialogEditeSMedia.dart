import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerDerilesUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class widgetDialogEditeSMedia extends StatelessWidget {
   widgetDialogEditeSMedia({super.key});
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( 'روابط التواصل الاجتماعي',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen),),
        ],
      ),
      content: Container(width: double.maxFinite,height: 250,
      // child: Image.file('',fit: BoxFit.fill,),
      child: Form(key: controller.formKeySm,
        child: ListView(
          
          children: [
           
                
                    SizedBox(height: 5,),
                      buildTextField(readOnly: false,obscureText: false,controller: controller.whattsappController,
                        validator: (value) {
                          
                        if (value == null || value.isEmpty) return  "  الرجاء ادخال رابط الواتس اب الخاص بك";
                        if (value.trim().isPhoneNumber==false) return 'ليس   رقم هاتف ';
                        if (value.trim().length<12||value.trim().length>12) return 'ليس   رقم هاتف ';
                        
                        return null;
                      },
                      // controller: controller.PasswordController,
                         label:" رقم الواتس اب مع رمز الدولة",
                      widget: Icon(Icons.link),
                    ),



                     SizedBox(height: 5,),
                      buildTextField(readOnly: false,obscureText: false,controller: controller.xController,
                        validator: (value) {
                        if (value == null || value.isEmpty) return  " الخاص بك  x الرجاء ادخال رابط ";
                        if (value.trim().isURL==false) return 'ليس   رابط ';
                        return null;
                      },
                      // controller: controller.PasswordController,
                         label:'ادخل ربط حسابك علئ x ',
                      widget: Icon(Icons.link),
                    ),


                     SizedBox(height: 5,),
                      buildTextField(readOnly: false,obscureText: false,controller: controller.facebookController,
                        validator: (value) {
                        if (value == null || value.isEmpty) return  "  الرجاء ادخال رابط الفيسبوك الخاص بك";
                        if (value.trim().isURL==false) return 'ليس  رابط ';
                        return null;
                      },
                      // controller: controller.PasswordController,
                         label:'ادخل ربط حسابك علئ الفيسبوك ',
                      widget: Icon(Icons.link),
                    ),
                     SizedBox(height: 5,),


                      buildTextField(readOnly: false,obscureText: false,controller: controller.instagramController,
                        validator: (value) {
                        if (value == null || value.isEmpty) return  "  الرجاء ادخال رابط  الانستجرام الخاص بك";
                        if (value.trim().isURL==false) return 'ليس رابط ';
                        return null;
                      },
                      // controller: controller.PasswordController,
                        label:'ادخل ربط علئ الانستجرام ',
                      widget: Icon(Icons.link),
                    ),

        ],),
      )
      ),
       actions: [
       
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: 70,
              height: 40,
              color: Colors.red,
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "الغاء",
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: 70,
              height: 40,
              color: AppColors().darkGreen,
              onPressed: () {
                if (controller. formKeySm.currentState!.validate()) {
                            // Perform save action
                            controller.SuioalMedia(context);
                            print("Form is valid and saved");
                          }
                            },
              child: const Text(
                "حفظ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}