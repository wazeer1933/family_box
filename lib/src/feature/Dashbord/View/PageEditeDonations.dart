import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetDropdwonEdit.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetImageDDWONEite.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetStepperContiner.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:family_box/src/feature/Dashbord/controllers/ControllerEdietDonations.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerGetDatausers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/models/value_item.dart';


class PageEditeDonations extends StatefulWidget {
  const PageEditeDonations({super.key});

  @override
  State<PageEditeDonations> createState() => _PageEditeDonationsState();
}

class _PageEditeDonationsState extends State<PageEditeDonations> {
  final _formKey = GlobalKey<FormState>();

  String? typeDonation;
  String? idUserDonation;
  DateTime datetime = DateTime.now();

  @override
  void initState() {
  // controller. date = "${datetime.year}-${datetime.month}-${datetime.day}";
    super.initState();
  }
final UserController userController = Get.put(UserController());
 final EditeDonationControllerImp controller = Get.put(EditeDonationControllerImp());
  @override
  Widget build(BuildContext context) {
    print("==========================${controller.imageUrlEdite}");
    print(controller.donationDescriptionController.text);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
        title: Center(child: Text("تعديل تبرعات")),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                WidgetTextfiledDash(
                  controller: controller.donationTitleController,
                  label: "عنوان التبرع",
                  widget: Icon(Icons.attach_money),
                  Labelvlaue: "عنوان التبرع",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "برجي ادخال عنوان التبرع   ";
                    }else if(value.length>25){
                      return 'لايجب ان يزيد عن 25 حرف';
                    }else if(value.length<10){
                      return 'لايجب ان يقل عن 10 احرف';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                WidgetDropdwonEdite(
                  // selectedOptions: [ValueItem(label: 'label', value: 1)],
                
                  initialSelectedOptions: [ValueItem(label: '${controller.donationTypeController.text}', value: 1)],
                  hitText: 'اختار نوع التبرع',
                  Labelvlaue: ' نوع التبرع',
                  hitTextStyle: TextStyle(),
                  options: [
                    ValueItem(label: 'الملابس', value: 1),
                    ValueItem(label: 'الاسكان', value: 2),
                    ValueItem(label: 'الطعام', value: 3),
                    ValueItem(label: 'المال', value: 4),
                    ValueItem(label: 'المشاريع', value: 5),
                  ],
                  
                  onOptionSelected: (List<ValueItem<dynamic>> selectedOptions) {
                    for(var option in selectedOptions){
                        // option.label==' ';
                        controller.donationTypeController.text=option.label;
                        print(controller.donationTypeController.text);
                       setState(() {});}
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى اختيار نوع التبرع';
                    }
                    return null;
                  }, searchEnabled: false,
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (userController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return WidgetImageDDWONEite(
                    initialSelectedOptions: [ValueItem(label: '${controller.userName}', value: 1)],
                    hitText: 'اختارالشخص المتبرع لة',
                    Labelvlaue: ' الشخص المتبرع لة',
                    hitTextStyle: TextStyle(),
                    options: userController.userList.toList(),
                    onOptionSelected: <User>(List<ValueItem<dynamic>> selectedOptions) {
                      for(var option in selectedOptions){
                        // option.label==' ';
                        controller.recipientIdController.text=option.value.uid;
                        print(controller.recipientIdController.text);
                       setState(() {});
                       }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار الشخص المتبرع لة';
                      }
                      return null;
                    }, searchEnabled: true,
                  );
                }),
                SizedBox(height: 10),
                WidgetTextfiledDash(
                  controller: controller.donationCostController,
                  label: "تكلفة التبرع",
                  widget: Icon(Icons.attach_money),
                  Labelvlaue: "تكلفة التبرع",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "برجي ادخال تكلفه التبرع تكلفة التبرع ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                WidgetStepperContiner(
                  icon: Icon(Icons.date_range_outlined),
                  Lable: "التاريخ",
                  value: controller.date!,
                  onTap: () async {
                    DateTime? NewDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2050),
                    );
                    if (NewDate == null) return;
                    controller.date = "${NewDate.year}-${NewDate.month}-${NewDate.day}";
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                WidgetTextfiledDash(
                  controller: controller.donationDescriptionController,
                  maxLines: 3,
                  label: "الوصف......",
                  widget: Icon(Icons.list_alt_sharp),
                  Labelvlaue: "وصف  التبرع",
                   validator: (value) {
                    if (value == null || value.isEmpty || value.length<29) {
                      return "برجي ادخال  وصف لايقل عن 30 حرف ";
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon(Icons.check_box, color: Colors.green),
                    Text(""),

              Obx(() {
                  print(controller.imageUrlEdite);
                return 
                controller.selectedImage.value == null 
                    ? Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Image.network(
                        '${controller.imageUrlEdite}',height: 100, width: 100,
                        fit: BoxFit.cover
                        
                        ),
                    )
                    // Text('يرجي اختيار صورة',style: TextStyle(color: Colors.red),)
                    : Padding(
                      padding: const EdgeInsets.all(8.0),child:
                      Image.file(controller.selectedImage.value!, height: 100, width: 100));
              }),
             

                    TextButton(
                      onPressed: () {
                        Get.bottomSheet(
                    BottomSheet(
                      
                      onClosing: () {},
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(title:Center(child: Text("اخنتار من",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)) ,),
                          ListTile(
                            // leading: Icon(Icons.camera),
                            title: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera),
                                Text('الكيمراء'),

                              ],
                            ),
                            onTap: () {
                              controller.pickImage(ImageSource.camera);
                              Get.back();
                            },
                          ),
                          ListTile(
                            
                            title: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo),
                                Text('المعرض'),
                              ],
                            ),
                            onTap: () {
                              controller.pickImage(ImageSource.gallery);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                      
                      child: Text(
                        "تحميل صورة ",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
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
                          children: [
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
                        color: AppColors().lighBrown,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            print("fs");
                            controller.EditeDonation(context);
                           
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.save, color: Colors.green),
                            Text("حفظ"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



