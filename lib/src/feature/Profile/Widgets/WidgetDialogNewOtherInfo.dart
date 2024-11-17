import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerDerilesUser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetDialogNewOtherInfo extends StatelessWidget {
   WidgetDialogNewOtherInfo({super.key});
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( ' معلومات جديدة',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen),),
        ],
      ),
      content: Container(width: double.maxFinite,height: 170,
      // child: Image.file('',fit: BoxFit.fill,),
      child: Form(key: controller.formKeyOtherInf,
        child: ListView(
          
          children: [
           
                
                    SizedBox(height: 5,),
                      buildTextField(readOnly: false,obscureText: false,controller: controller.NameInfoController,
                        validator: (value) {
                         // ignore: unnecessary_null_comparison
                         if(value!.isEmpty||value==null){
                          return 'برجي ادخال عنوان المعلومة';
                         }
                        return null;
                      },
                      // controller: controller.PasswordController,
                         label:' ادخال عنوان المعلومة',
                      widget: Icon(Icons.title_sharp),
                    ),



                   
                     SizedBox(height: 5,),
                       buildTextField(readOnly: false,obscureText: false,controller: controller.NotInfoController,
                        validator: (value) {
                         // ignore: unnecessary_null_comparison
                         if(value!.isEmpty||value==null){
                          return 'برجي ادخال ملاحضة المعلومة';
                         }
                        return null;
                      },
                      // controller: controller.PasswordController,
                         label:' ادخال ملاحضة للمعلومة',
                      widget: Icon(Icons.note_alt),
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
                if (controller. formKeyOtherInf.currentState!.validate()) {

                            // Perform save action
                            controller.AddNowInfo(context);
                            print("Form is valid and saved");
                          }
                            },
              child: const Text(
                "اضافة",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}