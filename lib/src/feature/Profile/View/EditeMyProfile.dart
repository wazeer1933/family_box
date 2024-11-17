import 'dart:io';

import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerDerilesUser.dart';
import 'package:family_box/src/feature/Profile/Widgets/WidgetDialogEditeSMedia.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditMyProfile extends StatefulWidget {
  const EditMyProfile({super.key});

  @override
  State<EditMyProfile> createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());
  final _formKey = GlobalKey<FormState>();
 Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(1900), // Earliest date allowed
      lastDate: DateTime(2100), // Latest date allowed
    );
    if (pickedDate != null) {
      setState(() {
        controller.dateBirthController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format to display only the date
      
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_sharp), // Custom back arrow on the right
            onPressed: () {
              Navigator.pop(context); // Navigate back when pressed
            },
          ),
        ],
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "تعديل بياناتي",
            style: TextStyle(fontWeight: FontWeight.w500, color: AppColors().darkGreen,),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
               controller.selectedImage.value==null? CircleAvatar(
                  backgroundColor: AppColors().grayshade300,
                  backgroundImage: NetworkImage('${controller.imageUrlold}'), 
                  // Replace with actual image URL
                  radius: 70,
                ):GetBuilder<controllerEditeMyProfile>(builder: (con)=>CircleAvatar(
                  backgroundColor: AppColors().grayshade300,
                  backgroundImage: FileImage(con.selectedImage.value as File), 
                  // Replace with actual image URL
                  radius: 70,
                ),),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors().white,
                    child: IconButton(
                      onPressed: () {
                        
                        controller.pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.edit_note, color: Colors.blue, size: 30),
                    ),
                  ),
                ),
              ],
            ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                          TextButton(onPressed: (){
                      showDialog(context: context, builder: (context)=>widgetDialogEditeSMedia());
                    }, child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(" التواص الاجتماعي",style: TextStyle(decoration: TextDecoration.underline,fontSize: 17,fontWeight: FontWeight.w500, color: AppColors().darkGreen),),
                    )),

                    TextButton(onPressed: (){
                      showDialog(context: context, builder: (context)=>dialogidentityCardimage());
                    }, child: Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text("صور الهوية الشخصية",style: TextStyle(decoration: TextDecoration.underline,fontSize: 17,fontWeight: FontWeight.w500, color: AppColors().darkGreen),),
                    )),
                  ],
                ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.0),
                    buildTextField(readOnly: false,obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'الرجاء ادخال اسمك';
                        if (value.length < 6) return 'لايقل  اسمك عن 6 أحرف';
                        return null;
                      },
                      controller: controller.userNameController,
                      label: "الاسم الكامل",
                      widget: Icon(Icons.person),
                    ),

                    SizedBox(height: size.height * 0.01),
                    buildTextField(readOnly: true,obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'الرجاء ادخال البريد الإلكتروني';
                        if (!value.isEmail) return 'البريد الإلكتروني غير صالح';
                        return null;
                      },
                      controller: controller.EmailController,
                      label: "البريد الإلكتروني",
                      widget: Icon(Icons.email),
                      // onTap: ()=>showDialog(context: context, builder: (context)=>dialogidChangeEmail()),
                    ),
                    SizedBox(height: size.height * 0.01),
                    buildTextField(readOnly: false,obscureText: false,
                      onTap:()=>print("object"),
                      controller: controller.PhoneController,
                      label: "رقم الهاتف",
                      widget: Icon(Icons.phone),
                    ),
                    SizedBox(height: size.height * 0.01),
                    buildTextField(readOnly: true,obscureText: true,
                      onTap: ()=>showDialog(context: context, builder: (context)=>dialogidChangePassowrd()),
                      controller: controller.PasswordController,
                      label: "كلمة المرور",
                      widget: Icon(Icons.remove_red_eye),
                    ),
                    SizedBox(height: size.height * 0.01),
                    buildTextField(readOnly: true,obscureText: false,
                      // enabled: true,
                      onTap: ()=>_selectDate(context),
                      controller: controller.dateBirthController,
                      label: "تاريخ الميلاد",
                      widget: Icon(Icons.date_range_outlined),
                    ),
                    //  SizedBox(height: size.height * 0.01),
                    // buildTextField(
                    //   controller: controller.AddressController,
                    //   label: "العنوان",
                    //   widget: Icon(Icons.home_filled),
                    // ),

                     SizedBox(height: size.height * 0.01),
                    buildTextField(readOnly: false,obscureText: false,
                      controller: controller.MardingController,
                      label: "الحالة الاجتماعية",
                      widget: Icon(Icons.favorite_outline_sharp),
                    ),
                    SizedBox(height: size.height * 0.01),

                      buildTextField(readOnly: false,obscureText: false,
                      controller: controller.SpicalController,
                      label: "التخصص",
                      widget: Icon(Icons.work),
                    ),
                    SizedBox(height: size.height * 0.01),
                    RadioListTileGender(onChanged: (value) {
                      controller.onchaneegnder(value);
                    }),


                   
                    
                    SizedBox(height: size.height * 0.01),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Perform save action
                            controller.EediteUserDataToFirestore(context);
                            print("Form is valid and saved");
                          }
                        },
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors().darkGreen,
                                  AppColors().lighBrown,
                                ],
                              ),
                            ),
                            child: Text(
                              "حفظ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors().orange,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RadioListTileGender extends StatelessWidget {
  final void Function(String?)? onChanged;

  const RadioListTileGender({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<controllerEditeMyProfile>(
      builder: (controller) => Container(
        padding: EdgeInsets.only(right: 10),
        height: 50,
        decoration: BoxDecoration(
          color: AppColors().darkGreenForms,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: RadioListTile(
                value: 'Male',
                groupValue: controller.gender,
                onChanged: onChanged,
                title: Text("ذكر", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            Expanded(
              child: RadioListTile(
                value: 'Female',
                groupValue: controller.gender,
                onChanged: onChanged,
                title: Text("أنثى", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            Center(
              child: Text(
                "الجنس",
                style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class dialogidentityCardimage extends StatelessWidget {
   dialogidentityCardimage({super.key});
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(" توثيق الهوية الشخصية",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen),),
        ],
      ),
      content: Container(width: double.maxFinite,height: 300,
      // child: Image.file('',fit: BoxFit.fill,),
      child: GetBuilder<controllerEditeMyProfile>(builder: (con)=>
      con.selectedImage.value!=null?
      Image.file(con.selectedImage.value as File,fit: BoxFit.fill,):
      con.imageUrlIdentity==null?Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('لا يوجد صورة لهويتك الشخصية',style: TextStyle(color:AppColors().gray,fontWeight: FontWeight.w700)),
          TextButton(onPressed: (){
              controller.pickImage(ImageSource.gallery);
          }, child: Text(' يرجي توثيق الهوية',style: TextStyle(color:AppColors().darkGreen,decoration: TextDecoration.underline,fontWeight: FontWeight.w700)),)

        ],
      ),):
      Image.network('${con.imageUrlIdentity}',fit: BoxFit.fill,)

      ),
      ),
       actions: [
        Container(
          width: double.infinity,
          child: MaterialButton(
            color: AppColors().lighBrown,height: 40,
            onPressed: (){
              controller.pickImage(ImageSource.gallery);
            }, child: Text("اختار صورة الهوية من المعرض", style: TextStyle(color:AppColors().darkGreen,fontWeight: FontWeight.w700),))),
        SizedBox(height: 5,),
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
                controller.indentityUserImage(context);
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





class dialogidChangePassowrd extends StatelessWidget {
   dialogidChangePassowrd({super.key});
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( " اعادة تعين كلمة المرور الجديدة",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen),),
        ],
      ),
      content: Container(width: double.maxFinite,height: 200,
      // child: Image.file('',fit: BoxFit.fill,),
      child: Form(key:controller. formKey,
        child: ListView(children: [
            buildTextField1(
                       validator: (value) {
                        if (value == null || value.isEmpty) return " ادخل كلمة المرور القديمة";
                        if (value.trim()!=controller.PasswordController.text) return 'لقدادخلت كملة المرور القديمة خطاء';
                        return null;
                      },
                      // controller: controller.PasswordController,
                      label: " ادخل كلمة المرور القديمة",
                      widget: Icon(Icons.remove_red_eye),
                    ),
                    SizedBox(height: 5,),
                      buildTextField1(
                       validator: (value) {
                        if (value == null || value.isEmpty) return " ادخل كلمة المرور الجديدة";
                        if (value.length < 6) return 'لايقل  كلمة عن المرور 6 أحرف';
                        return null;
                      },
                      controller: controller.RePasswordController,
                         label: " تعين كلمة المرور الجديدة",
                      widget: Icon(Icons.remove_red_eye),
                    ),
                    SizedBox(height: 5,),
                      buildTextField1(
                        validator: (value) {
                        if (value == null || value.isEmpty) return  "  الرجاء اعادة تعين كلمة المرور الجديدة";
                        if (value.trim()!=controller.RePasswordController.text.trim()) return '  كلمة  المرور ليست مطابقة ';
                        return null;
                      },
                      // controller: controller.PasswordController,
                         label: " اعادة تعين كلمة المرور الجديدة",
                      widget: Icon(Icons.remove_red_eye),
                    )
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
                if (controller.formKey.currentState!.validate()) {
                            // Perform save action
                            controller.changePassword(context,
                            controller.PasswordController.text.trim(),
                            // '1q2w3e',
                            controller.RePasswordController.text.trim());
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




class dialogidChangeEmail extends StatelessWidget {
   dialogidChangeEmail({super.key});
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( 'تغير البريد الاكتروني',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen),),
        ],
      ),
      content: Container(width: double.maxFinite,height: 100,
      // child: Image.file('',fit: BoxFit.fill,),
      child: Form(
        child: ListView(children: [
               buildTextField(readOnly: false,obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'الرجاء ادخال البريد الإلكتروني';
                        if (!value.isEmail) return 'البريد الإلكتروني غير صالح';
                        return null;
                      },
                      controller: controller.EmailController,
                      label: "البريد الإلكتروني الجديد",
                      widget: Icon(Icons.email),
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
                if (controller.EmailController.text.isEmail==true) {
                            // Perform save action
                            controller.changeEmail(context);
                            print("Form is valid and saved");
                          }else{
                            snackBar('البريد الاكتروني غير صالح', context);
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