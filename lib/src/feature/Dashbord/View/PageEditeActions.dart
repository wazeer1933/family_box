
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetChooseYoureLocation.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetDropdwonEdit.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetStepperContiner.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddActions.dart';
import 'package:family_box/src/feature/EventsFamli/View/DisplayEvents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/models/value_item.dart';
// import 'package:intl/intl.dart'

class PageEditeActions extends StatefulWidget {
  const PageEditeActions({super.key});

  @override
  State<PageEditeActions> createState() => _PageEditeActionsState();
}

DateTime datetime=DateTime.now();
  final _formKey = GlobalKey<FormState>();
String formattedMonth = DateFormat('MMMM').format(datetime);
class _PageEditeActionsState extends State<PageEditeActions> {
  final controllerAddCations controller=Get.put(controllerAddCations());
void initState() {
  print(controllerAddAction.latitude);
  // controller.FormattedDate(datetime);
// controller.date="${datetime.year}-${formattedMonth}-${datetime.day}";
  super.initState();
  
}
@override
  void dispose() {
    controllerAddAction.clearFields();
    super.dispose();
  }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(automaticallyImplyLeading: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
        title: Center(child: Text("تعديل النشاطات",style: TextStyle(color: Color(0xFF006400)),)),),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: SingleChildScrollView(
          child: GetBuilder<controllerAddCations>(builder: (controllerAddaction){
            return Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                      WidgetDropdwonEdite(
                  initialSelectedOptions: [ValueItem(label: '${controllerAddaction.actionTypeController.text}', value: 1)],
                        hitTextStyle: TextStyle(),
                        options:[
                       ValueItem(label: 'حدث', value: 1),
                       ValueItem(label: 'فعالية', value: 1),
                       ],
                       labelText: ' نوع النشاط',
                          hitText: 'اختار نوع النشاط', 
                          Labelvlaue: ' نوع النشاط',
                          searchEnabled: false,
                          onOptionSelected: (List<ValueItem> selectedOptions) {
                      for(var option in selectedOptions){
                        controller.actionTypeController.text=option.label;
                        print(controller.actionTypeController.text);
                        // ignore: unrelated_type_equality_checks
                        option.label==' ';
                       setState(() {});
                       
                       }}, 
                           validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى اختيار نوع النشاط';
                    }
                    return null;
                  },
                          ),

                       SizedBox(height: 10,),
                     
          
                 WidgetTextfiledDash ( 
                 
                  controller: controller.actionTitleController,label: "عنوان النشاط", widget: Icon(Icons.title_sharp,),Labelvlaue:"عنوان النشاط",
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
                       SizedBox(height: 10,),
                                            WidgetStepperContiner(
                          icon: Icon(Icons.date_range_outlined),
                          value: "${controller.date}",
                          onTap: () async {
                            // Show date picker
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2050),
                            );

                            if (newDate == null) return;

                            // Show time picker after selecting the date
                            TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                                  child: child!,
                                );
                              },
                            );

                            if (newTime == null) return;

                            // Combine the selected date and time
                            final DateTime dateTime = DateTime(newDate.year,newDate.month,newDate.day, newTime.hour, newTime.minute,);

                            // Format the date and time as "yyyy-MM-dd hh:mm a"
                            // controller.date =
                            //     "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
                            //     "${newTime.format(context)}";

                            controller.FormattedDate(dateTime);

                            // Update the state
                            setState(() {});
                          }, Lable: "اختار تاريخ النشاط ",
                        ),

                    
                    SizedBox(height: 10,),
                     WidgetTextfiledDash ( 
                        onTap: (){
                      print("object");
                      if(controller.latitude!=null){
                  showDialog(context: context, builder: (context)=>LocationPickerDialog());}
                 },
                  controller: controllerAddaction.address,label:controllerAddaction.address.text.isEmpty? " موقع النشاط ":"${controllerAddaction.address.text}", widget: Icon(Icons.title_sharp,),Labelvlaue:" موقع النشاط ",),
                   
                  SizedBox(height: 10,),
              
                 WidgetTextfiledDash (controller: controller.actionDescriptionController,maxLines: 3, label: "الوصف......", widget: Icon(Icons.list_alt_sharp,),Labelvlaue:"وصف  النشاط",
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length<29) {
                      return "برجي ادخال  وصف لايقل عن 30 حرف ";
                    }
                    return null;
                  },
                 ),
                  
                 ///////////////////////////////////////////////////////////////////
                Column(crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icon(Icons.check_box, color: Colors.green),
                    Text(""),

                    Center(
                      child: Obx(() {
                                      return controller.selectedImage.value == null
                      ?controllerAddaction.EditeImageUrl!=null? Image.network('${controllerAddaction.EditeImageUrl}',height: 100,width: 100,):Text("")
                      : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(controller.selectedImage.value!, height: 100, width: 100),
                      );
                                    }),
                    ),

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
                ///////////////////////////////////////////////////
                 SizedBox(height: 10,),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(width: 100,
                   child: MaterialButton(
                    minWidth: 100,
                    color: Colors.red[100],
                    onPressed: (){Get.back();},child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.error_outline_rounded,color: Colors.red,),Text("الغاء")],),),
                 ),
                 Container(width: 100,
                   child: MaterialButton(
                    minWidth: 100,
                    color: AppColors().lighBrown,
                    onPressed: (){
                      if (_formKey.currentState?.validate() ?? false) {
                            controller.EditeActions(context);
                           
                          }
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.save,color: Colors.green,),Text("حفظ")],),),
                 )
                 ],)
                   
           
          ],));
          })
        ),),
    );
  }
}


