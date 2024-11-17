import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ContollerLogIn.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class dialogNewPassowrd extends StatelessWidget {
   dialogNewPassowrd({super.key});
  ControllerLogIn controllerLogIn = Get.put(ControllerLogIn());
 final List<TextEditingController> textControllers = 
      List.generate(6, (index) => TextEditingController());
   

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('إعادة تعين كلمة مرور جديدة',style: AppTextStyles.titleStyle,),),
      content: Container(height: 200,width: double.maxFinite,child: SingleChildScrollView(
        child: Form(key: controllerLogIn.formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 buildTextField(
                          readOnly: false,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' الرجاء ادخال كلمةالمرور ';
                            } else if (value.length < 6) {
                              return 'كلمة المرور ضعيفة';
                            }
                            return null;
                          },
                          controller: controllerLogIn.PassController,
                          label: "كلمة المرور الجديدة",
                          widget: Icon(Icons.remove_red_eye),
                        ),
                        SizedBox(height: 10),
                        buildTextField(
                          readOnly: false,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' الرجاء اعادة تعين كلمةالمرور ';
                            } else if (value != controllerLogIn.PassController.text) {
                              return ' كلمة المرورليست مطابقة ';
                            }
                            return null;
                          },
                          label: "اعادة تعين كلمة المرور",
                          widget: Icon(Icons.remove_red_eye),
                        ),
          ],),
        ),
      ),),
      actions: [
        Center(child: TextButton(onPressed: (){
                    if (controllerLogIn.formKey.currentState!.validate()) {
                      controllerLogIn.updateUserPassowrd(context);
                    }
                 
        }, child: Text('حفظ',style: AppTextStyles.titleStyle,)),)
      ],
    );
  }
}