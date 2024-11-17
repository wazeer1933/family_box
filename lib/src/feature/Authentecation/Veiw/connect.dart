// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


// ignore: must_be_immutable
class ContactPage extends StatelessWidget {
 AuthController controllerImp=Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("تواصل معنا", style: TextStyle(color:appColors.primary))),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contact Info Section
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  Form(
                  key:_formKey ,
                  child: Column(
                    children: [
                        buildTextField ( readOnly: currentUserData.isNotEmpty?true: false,obscureText: false,
                         validator: (value){
                      if (value == null || value.isEmpty) {return ' الرجاء ادخال اسمك';}else if(value.length<6){return 'لايقل  اسمك علئ 6 ارحرف';}return null;},
                        controller:controllerImp. userName, label: "الاسم الكامل", widget: Icon(Icons.person,),),
                                   SizedBox(height:15),
                  
                                   buildTextField(readOnly: currentUserData.isNotEmpty?true: false,obscureText: false,
                           validator: (value){
                      if (value == null || value.isEmpty) {return ' الرجاء ادخال رقم الهاتف';}
                      else if(value.isPhoneNumber&&value.trim().length==12){return null;}return ' رقم الهاتف غير صالح';},
                        controller:controllerImp. Phone,label:"رقم الهاتف",widget: Icon(Icons.phone,), ),
                  SizedBox(height:0),
                  
                        WidgetTextfiledDash (controller: controllerImp.message,maxLines: 3, label: "الرسالة" ,widget: Icon(Icons.list_alt_sharp,),Labelvlaue:" ",
                      validator: (value) {
                        if (value == null||value.length<1) {
                          return 'يرجي كتابة رسالتك';
                        }
                        return null;
                      },
                     ),
                      
                     ///////////////////////////////////////////////////////////////////
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Send Button
              ElevatedButton(
                onPressed: () {
                   if (_formKey.currentState?.validate() ?? false) {
                              if(currentUserId==null||currentUserId==''){
                                snackBarErorr('يرجي تسجل دخولك او انشاء حساب لتمكن من مراسلة الصندوق', context);
                            }else{
                             controllerImp.ChatConnet(context);}
                            }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                ),
                child:  Text("أرسل", style:AppTextStyles.titleStylePageSize.copyWith(color: appColors.white)),
              ),
              const SizedBox(height: 32),
              // Contact Information Section
               Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("معلومات التواصل",
                      style:AppTextStyles.titleStylePageSize),
                  const SizedBox(height: 12),
                ///////////////////////////////////////////////////////////////////////////////////////////////
                StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('setings').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
        
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text(" لا يتوفر بيـانـات تـواصـل"));
            }
        
            // Assuming phone number is stored in the first document
            var phoneData = snapshot.data!.docs.first['phone'] ?? 'غير متوفر';
            var whattsapp = snapshot.data!.docs.first['whattsapp'] ?? 'غير متوفر';
            var email = snapshot.data!.docs.first['email'] ?? 'غير متوفر';
        
        
            return Column(
              children: [
                



                  GestureDetector(onTap: ()=>launchPhoneDialer("$phoneData",'tel'),
                    child:  Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("$phoneData", style: TextStyle(fontSize: 18)),SizedBox(width: 10,),
                        CircleAvatar(child: Icon(Icons.call),backgroundColor: appColors.lighBrown,),],),
                  ),
                  const SizedBox(height: 8),
                   GestureDetector(onTap: ()=>launchUrlString("mailto:$email"),
                    child:  Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("$email", style: TextStyle(fontSize: 18)),SizedBox(width: 10,),
                        CircleAvatar(child: Icon(Icons.email),backgroundColor: appColors.lighBrown,),],),
                  ),
                 
                  const SizedBox(height: 8),
                   GestureDetector(onTap: ()=>launchUrlString("https://wa.me/+$whattsapp"),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("راسلنا على واتساب", style: TextStyle(fontSize: 18)),SizedBox(width: 10,),
                        CircleAvatar(child: Icon(Icons.chat),backgroundColor: appColors.lighBrown,),],),
                  ),
              ],
            );
          },
        ),
                ///////////////////////////////////////////////////////////////////////////////////////////////////////      

 




                 
                ],
              ),
              const SizedBox(height: 16),
              // Social Media Buttons Row
              
            ],
          ),
        ),
      ),
    );
  }
}


void launchPhoneDialer(String phoneNumber,scheme) async {
  final Uri phoneUri = Uri(scheme:scheme , path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneUri';
  }
}