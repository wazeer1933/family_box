import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetDropDwon.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetStepperContiner.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/widgetdropDwon2.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddNotfication.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerGetDatausers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/value_item.dart';

class PageNewNotficatons extends StatefulWidget {
  const PageNewNotficatons({super.key});

  @override
  State<PageNewNotficatons> createState() => _PageNewNotficatonsState();
}

class _PageNewNotficatonsState extends State<PageNewNotficatons> {
final UserController userController = Get.put(UserController());
  final _keyForm=GlobalKey<FormState>();
final controllerAddNotficationImp controller=Get.put(controllerAddNotficationImp());
@override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    userController.userList.clear();
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
        ],
        title: Center(child: Text("ارسال اشعار ",style: AppTextStyles.titleStylePageSize,),),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                        
                  child: Form(
                    key: _keyForm,
                    child: GetBuilder<controllerAddNotficationImp>(builder: (con)=>Column(
                      children: [
                        Row(textDirection: TextDirection.rtl,
                          children: [
                             Text("كل المستخدمين",style: AppTextStyles.titleStyle,),
                            Checkbox(
                              value:con. IsAll,
                             onChanged: con.onChanged,),
                          ],
                        ),
                        if(con.IsAll!=true) Obx(() {
                          // addIfTreeNotFound('1');
                          userController.userList.sort((a, b) => a.value.tree.compareTo(b.value.tree));
                          
                          if (userController.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          }
                                  
                          return DropDwonWithImage(
                            selectionType: SelectionType.multi,
                            hitText: 'اختار المستلمين',
                            LabelValue: 'اختار المستلمين',
                            hitTextStyle: TextStyle(),
                            options: userController.userList.toList(),
                            onOptionSelected: <User>(List<ValueItem<dynamic>> selectedOptions) {
                              setState(() {
                                controller.UsersRes = selectedOptions.map((item) => item.value.uid).toList();
                              });
                              print("Selected labels: ${controller.UsersRes}");
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى اختيار المستلمين';
                              }
                              return null;
                            },
                            searchEnabled: true,
                          );
                        }),
                        SizedBox(height: 10),
                        WidgetTextfiledDash(
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length < 5) {
                              return "يرجى إدخال عنوان لا يقل عن 5 حروف";
                            }
                            return null;
                          },
                          controller: controller.title,
                          label: "عنوان الإشعار",
                          widget: Icon(Icons.title_rounded),
                          Labelvlaue: "عنوان الإشعار",
                        ),
                        SizedBox(height: 10),
                        WidgetTextfiledDash(
                          validator: (value) {
                            if (value == null || value.isEmpty || value.length < 10) {
                              return "يرجى إدخال وصف لا يقل عن 10 حروف";
                            }
                            return null;
                          },
                          controller: controller.body,
                          maxLines: 3,
                          label: "الوصف......",
                          widget: Icon(Icons.list_alt_sharp),
                          Labelvlaue: "وصف الإشعار",
                        ),
                        ///////////////////////////////////////////////////////////
                        SizedBox(height: 10),
                      
                         DropDwon(hitText:'اختار نوع الاشعار',Labelvlaue: ' نوع الاشعار',
                   hitTextStyle:TextStyle(),options:const [
                     ValueItem(label: 'حدث', value: 1),
                     ValueItem(label: 'فعالية', value: 2),
                     ValueItem(label: 'تبرع', value: 3),
                     ValueItem(label: 'اخرئ', value: 4),
                    //  ValueItem(label: 'فعالية', value: 2),
                                
                     ],
                                   
                  onOptionSelected: (List<ValueItem> selectedOptions) {
                    for(var option in selectedOptions){
                      controller.Type.text=option.label;
                      print(controller.Type.text);
                      // ignore: unrelated_type_equality_checks
                      option.label==' ';
                     setState(() {});
                     
                     }}, 
                     validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى اختيار نوع الاشعار';
                  }
                  return null;
                                  }, searchEnabled: false,
                     
                     ),
                     //////////////////////////////////////////////////////////////////
                     
                                          WidgetStepperContiner(
                        icon: Icon(Icons.date_range_outlined),
                        value: "${controller.date.text}",
                        onTap: () async {
                          // Show date picker
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2050),
                          );
                          if (newDate == null) return;
                          
                          controller.date.text='${newDate.year}-${newDate.month}-${newDate.day}';
                          // Update the state
                          setState(() {});
                        }, Lable: "اختار تاريخ  ",
                      ),
                         
                      ],
                    ),),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                  Container(
                    width: 100,
                    child: MaterialButton(
                      minWidth: 100,
                      color: Colors.red[100],
                      onPressed: () {
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.error_outline_rounded, color: Colors.red),
                          Text("الغاء"),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: MaterialButton(
                      minWidth: 100,
                      color: Colors.blue[100],
                      onPressed: () {
                        if (_keyForm.currentState?.validate() ?? false) {
                          controller.addNewNotficatons(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.send, color: Colors.green),
                          Text("ارسال"),
                        ],
                      ),
                    ),
                  ),
                                ],
                              ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}