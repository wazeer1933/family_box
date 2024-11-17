import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuDonations.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:family_box/src/feature/Dashbord/controllers/contrllerSettingsapp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageSettingsApp extends StatefulWidget {
  const PageSettingsApp({super.key});

  @override
  State<PageSettingsApp> createState() => _PageSettingsAppState();
}

class _PageSettingsAppState extends State<PageSettingsApp> {
  final contrllerSettingsapp controller = Get.put(contrllerSettingsapp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_forward_ios_sharp))
        ],
        title: Center(
          child: Text('إعدادات التطبيق', style: AppTextStyles.titleStyle),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('setings').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ShimmerBox());
            }
        
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("لا يتوفر"));
            }
        
            // Assuming phone number is stored in the first document
            var phoneData = snapshot.data!.docs.first['phone'] ?? 'غير متوفر';
            var whattsapp = snapshot.data!.docs.first['whattsapp'] ?? 'غير متوفر';
            var email = snapshot.data!.docs.first['email'] ?? 'غير متوفر';
            var privacy = snapshot.data!.docs.first['privacy'] ?? 'غير متوفر';
        
        
            return Column(
              children: [
                Card(color: Colors.white,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    leading: IconButton(onPressed: (){
                      controller.email.text=email;
                      controller.phone.text=phoneData;
                      controller.whattsapp.text=whattsapp;
                      print(snapshot.data!.docs.first.id);
                      showDialog(context: context, builder: (context)=>dialogidEditeconnectData(doc: snapshot.data!.docs.first.id,));}, icon: Icon(Icons.edit_square,color: appColors.primary,)),
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text('بـيانـات الـتواصـل', style: AppTextStyles.titleStyle),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(phoneData, style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),
                            CircleAvatar(
                              child: Icon(Icons.call),
                              backgroundColor: appColors.lighBrown,
                            ),
                          ],
                        ),
                      ),
            
            
                        Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(whattsapp, style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),
                            CircleAvatar(
                              child: Icon(Icons.chat),
                              backgroundColor: appColors.lighBrown,
                            ),
                          ],
                        ),
                      ),
            
                        Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(email, style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),
                            CircleAvatar(
                              child: Icon(Icons.email),
                              backgroundColor: appColors.lighBrown,
                            ),
                          ],
                        ),
                      ),
            
                    ],
                  ),
                ),
                Card(color: Colors.white,
                  child: ExpansionTile(
                    leading: IconButton(onPressed: (){
                      controller.privacy.text=privacy;
                     
                      print(snapshot.data!.docs.first.id);
                      showDialog(context: context, builder: (context)=>dialogidEditeprivacyData(doc: snapshot.data!.docs.first.id,));}, icon: Icon(Icons.edit_square,color: appColors.primary,)),
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text('سيـاسـة الـخـصـوصيـة', style: AppTextStyles.titleStyle),
                    ),
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(privacy,style: AppTextStyles.subtitleStyle.copyWith(fontSize: 17),textDirection: TextDirection.rtl,),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}







// ignore: must_be_immutable
class dialogidEditeconnectData extends StatelessWidget {
  String doc;
   dialogidEditeconnectData({super.key,required this.doc});
  final contrllerSettingsapp controller = Get.put(contrllerSettingsapp());
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( 'تحديث بـيانـات الـتواصـل ',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen),),
        ],
      ),
      content: Container(width: double.maxFinite,height: 200,
      // child: Image.file('',fit: BoxFit.fill,),
      child: Form(key: controller.formKey,
        child: ListView(children: [
               buildTextField(
                          readOnly: false,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' الرجاء ادخال البريد الاكتروني';
                            } else if (value.isEmail) {
                              return null;
                            }
                            return 'البريد الاكتروني غير صالح';
                          },
                          controller: controller.email,
                          label: "البريد الاكتروني",
                          widget: Icon(Icons.email),
                        ),
                          SizedBox(height: 10,),
                         buildTextField(
                          readOnly: false,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' الرجاء ادخال رقم الواتساب';
                            } else if (value.isPhoneNumber && value.trim().length == 12) {
                              return null;
                            }
                            return ' رقم الواتساب غير صالح';
                          },
                          controller: controller.whattsapp,
                          label: "رقم الواتساب",
                          widget: Icon(Icons.chat),
                        ),
                         SizedBox(height: 10,),
                         buildTextField(
                          readOnly: false,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ' الرجاء ادخال رقم الهاتف';
                            } else if (value.isPhoneNumber) {
                              return null;
                            }
                            return ' رقم الهاتف غير صالح';
                          },
                          controller: controller.phone,
                          label: "رقم الهاتف",
                          widget: Icon(Icons.phone),
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
                if (controller.formKey.currentState!.validate()) {
                          controller.updatedata(context, doc);
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

























// ignore: must_be_immutable
class dialogidEditeprivacyData extends StatelessWidget {
  String doc;
   dialogidEditeprivacyData({super.key,required this.doc});
  final contrllerSettingsapp controller = Get.put(contrllerSettingsapp());
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( 'تحديث بـيانـات الـسياسـة ',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700,color: AppColors().darkGreen),),
        ],
      ),
      content: Container(width: double.maxFinite,height: 200,
      // child: Image.file('',fit: BoxFit.fill,),
      child: Form(key: controller.formKey,
        child: ListView(children: [
                WidgetTextfiledDash (controller: controller.privacy,maxLines: 4, label: "الـسياسـة......", widget: Icon(Icons.list_alt_sharp,),Labelvlaue:"",
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length<100) {
                      return "برجي ادخال  بيانات الـسياسـة لاتقل عن 100 حرف ";
                    }
                    return null;
                  },
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
                if (controller.formKey.currentState!.validate()) {
                          controller.updatedataprivacy(context, doc);
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