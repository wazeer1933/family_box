



import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetDropDwon.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:family_box/src/feature/ServiceApp/controllers/controllersSedRquests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/models/value_item.dart';

class RequsetService extends StatefulWidget {
  const RequsetService({super.key});

  @override
  State<RequsetService> createState() => _RequsetServiceState();
}

class _RequsetServiceState extends State<RequsetService>with SingleTickerProviderStateMixin {
  final _keyForm=GlobalKey<FormState>();
 
 final controllerSendRequset contoller=Get.put(controllerSendRequset());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(child: Center(child:  Text(
                'طلب خدمة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:AppColors().darkGreen,
                ),
              ),),),
        content: Container(width: double.maxFinite,height: 300,
          child: Form(
            key: _keyForm,
            child: ListView(
              children: [
                DropDwon(hitText:'اختار نوع الطلب',Labelvlaue: ' نوع الطلب',
                       hitTextStyle:TextStyle(),options:const [
                         ValueItem(label: 'حدث', value: 1),
                         ValueItem(label: 'مناسبة', value: 1),
                         ValueItem(label: 'تبرع', value: 1),
                         ValueItem(label: 'اضافة الئ الشجرة ', value: 1),
                         ValueItem(label: 'ادارة', value: 1),
                         ValueItem(label: 'توثيق الهوية', value: 1),
                         ValueItem(label: 'اخرئ', value: 1)
                         ],
                     
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        for(var option in selectedOptions){
                          contoller.typeRequest.text=option.label;
                          // print(controller.actionTypeController.text);
                          // ignore: unrelated_type_equality_checks
                          option.label==' ';
                         setState(() {
                           
                         });
                         }}, 
                         validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار  الطلب';
                      }
                      return null;
                    }, searchEnabled: false,
                         
                         ),
                SizedBox(height: 20),
                WidgetTextfiledDash(
                  controller: contoller.discriptionRquest,
                  maxLines: 3,
                  label: "الوصف......",
                  widget: Icon(Icons.list_alt_sharp),
                  Labelvlaue: "وصف  سبب الطلب",
                   validator: (value) {
                    if (value == null || value.isEmpty || value.length<10) {
                      return "برجي ادخال  وصف لايقل عن 10 حرف ";
                    }
                    return null;
                  },
                ),
               
              ],
            ),
          ),
        ),
        actions: [
           Row(textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Container(
                  
                  child: ElevatedButton(
                    onPressed: () {
                      if(_keyForm.currentState?.validate() ?? false){
                        contoller.addRequestUsers(context);
                      }
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.send,textDirection: TextDirection.rtl,size: 20,),SizedBox(width: 5,),
                        Text('ارسال',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                       backgroundColor: AppColors().darkGreen, // Use backgroundColor instead of primary
                          foregroundColor: Colors.white,
                    
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Container(
                  
                  child: ElevatedButton(
                    onPressed: () {Get.back();},
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.error_outline,textDirection: TextDirection.rtl,size: 20,),SizedBox(width: 5,),
                        Text('الغاء',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                       backgroundColor: AppColors().darkGreen,
                        foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
           ],)
        ],
    );
  }
}
