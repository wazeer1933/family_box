
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerDerilesUser.dart';
import 'package:family_box/src/feature/Profile/verifTowStep/PagePassowrdTowStap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
class controllerVerfiTowStaps extends GetxController{
  final TextEditingController email = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController password = TextEditingController();


 final EmailOTP emailOTP = EmailOTP();

  Future<void> sendOTP(context) async {
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    emailOTP.setConfig(
      appEmail: "Allahaidanfam@example.com", // Replace with your app's email
      appName: "عائلة اللحيدان",
      userEmail: currentUserData[0]['email'], // Replace with the recipient's email
        otpLength: 6,       
                                 // Length of the OT
    );
   
    bool result = await emailOTP.sendOTP();

    if (result) {
      EasyLoading.dismiss();
      snackBar('تم ارسال كود التحقق الئ بريدك', context);
      print("OTP sent successfully");
       print("OTP code sent:");
    } else {
            EasyLoading.dismiss();
      snackBar('لم يتم ارسال كود التحقق ', context);
      print("Failed to send OTP");
    }
  }

  vreyfi(context)async{
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
   bool result=await emailOTP.verifyOTP(otp: code.text.trim());
   if (result) {
    EasyLoading.dismiss();
    Get.to(PagePassowrdTowStap());
      print("OTP  successfully");
    } else {
      EasyLoading.dismiss();
      snackBarErorr('كود التحقق خطاء', context);
          
             print("OTP code erorr:");

    }
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UsersControllersImp conuser=Get.put(UsersControllersImp());

  
savePassowrd(context)async{
  if(connected==true){
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
 await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).update({
  'PassVerifiTowStaps':password.text,
}).then((value){
  EasyLoading.dismiss();
  currentUserData[0]['PassVerifiTowStaps']=password.text;
  password.clear();
  Get.back();
  Get.back();
    conuser.fetchUser(context,false);

snackBar('تم تعين رمز التحقق بخطوتين', context);
});
  }else{
    SnackbarNointernet();
  }
}

snackBarErorr(String? message,context) {
    
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red,
        content: Row(textDirection: TextDirection.rtl,mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(message!),
            ),Icon(Icons.error_outline,color: Colors.white,)
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}


