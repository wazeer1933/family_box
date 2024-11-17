import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/ResetCodePassWord.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/dialogCodeVerifi.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/dialogForgetPassword.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ControllerLogIn extends GetxController{
  final TextEditingController PassController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final UsersControllersImp conuser=Get.put(UsersControllersImp());
  final FirebaseAuth auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
 final List<TextEditingController> textControllers = 
      List.generate(6, (index) => TextEditingController());

Future<bool> checkEmailExists(context) async {
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: EmailController.text.trim())
        
        .where('password',isEqualTo: PassController.text.trim())
     // Only need to check if one document exists
        .get();
        if(querySnapshot.docs.isNotEmpty){
       sherd(querySnapshot.docs.first.id,context);
        
        }else{
        EasyLoading.dismiss();
snackBar(' خطاء يرجي التحقق من الايميل او كلمة المرور', context);
        }
    return querySnapshot.docs.isNotEmpty; // True if email exists
  } catch (e) {
        EasyLoading.dismiss();
    print("Error checking email existence: $e");
    return false; // Handle errors appropriately in production
  }
  }else{
   SnackbarNointernet();
    return false;
  }
}




Future<bool> checkPassVerifi(context) async {
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: EmailController.text.trim())
        .where('password',isEqualTo: PassController.text.trim()).where('PassVerifiTowStaps',isNull: false)
        .get();
        if(querySnapshot.docs.isNotEmpty){
          EasyLoading.dismiss();
        showDialog(context: context, builder: (context)=>dialogCodeVerifi());
        }else{
          Login(context);
        }
    return querySnapshot.docs.isNotEmpty; // True if email exists
  } catch (e) {
        EasyLoading.dismiss();
    print("Error checking email existence: $e");
    return false; // Handle errors appropriately in production
  }
  }else{
   SnackbarNointernet();
    return false;
  }
}


Future<bool> checkPasswordForget(context) async {
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: EmailController.text.trim()).get();
        if(querySnapshot.docs.isNotEmpty){
          PassController.text=querySnapshot.docs.first['password'];
          // changPassword(querySnapshot.docs.first.id, context);
          EasyLoading.dismiss();
          showDialog(context: context, builder: (context)=>dialogPasswordForget());
          sendOTP(context);
        }else{
          EasyLoading.dismiss();
         snackBarErorr('هاذا الايمل غير موجود', context);

        }
    return querySnapshot.docs.isNotEmpty; // True if email exists
  } catch (e) {
        EasyLoading.dismiss();
    print("Error checking email existence: $e");
    return false; // Handle errors appropriately in production
  }
  }else{
   SnackbarNointernet();
    return false;
  }
}






Future<bool> checkPassVerifiCode(context,code) async {
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: EmailController.text.trim())
        .where('password',isEqualTo: PassController.text.trim()).where('PassVerifiTowStaps',isEqualTo: code)
        .get();
        if(querySnapshot.docs.isNotEmpty){
        Login(context);
        }else{
          EasyLoading.dismiss();
         snackBar('رمز التحقق بخطوتين خطاء', context);

        }
    return querySnapshot.docs.isNotEmpty; // True if email exists
  } catch (e) {
        EasyLoading.dismiss();
    print("Error checking email existence: $e");
    return false; // Handle errors appropriately in production
  }
  }else{
   SnackbarNointernet();
    return false;
  }
}





Login(context)async{
  if(connected==true){
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
  try {
  // ignore: unused_local_variable
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: EmailController.text.trim(),
    password: PassController.text
  ).then((value){
    sherd2(auth.currentUser!.uid, context);
  });
} on FirebaseAuthException catch (e) {
  
  if (e.code == 'user-not-found') {
    snackBar(' خطاء يرجي التحقق من الايميل ', context);
    EasyLoading.dismiss();
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
snackBar(' خطاء يرجي التحقق من كلمة المرور', context); 
    EasyLoading.dismiss(); }
    else if (e.code == 'Too-many-attempts') {
    print('Wrong password provided for that user.');
snackBar('لقد اجريت العديد من المحاولات  الخاطئة', context); 
    EasyLoading.dismiss(); }else{
snackBar(' خطاء يرجي التحقق من الايميل و كلمة المرور', context);
EasyLoading.dismiss();
    }
}}else{
  SnackbarNointernet();
}
}

sherd(uid,context)async{
  await sharedPreferences.setString('uid',uid).then((value){
    currentUserId=uid;
    //  EasyLoading.dismiss();
          conuser.fetchUser(context,false);
  });
 
}
sherd2(uid,context){
    currentUserId=auth.currentUser!.uid;
    //  EasyLoading.dismiss();
          conuser.fetchUser(context,false);

 
}


final EmailOTP emailOTP = EmailOTP();

  Future<void> sendOTP(context) async {
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    emailOTP.setConfig(
      appEmail: "Allahaidanfam@example.com", // Replace with your app's email
      appName: "عائلة اللحيدان",
      userEmail: EmailController.text, // Replace with the recipient's email
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

  vreyfiForgetVerifi(context,code)async{
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
   bool result=await emailOTP.verifyOTP(otp: code.trim());
   if (result) {
    EasyLoading.dismiss();
      Get.to(ResetCodePassWord());
      print("OTP  successfully");
    } else {
      EasyLoading.dismiss();
      snackBarErorr('كود التحقق خطاء', context);
          
             print("OTP code erorr:");

    }
  }


  vreyfiForgetPassword(context,code)async{
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
   bool result=await emailOTP.verifyOTP(otp: code.trim());
   if (result) {
    EasyLoading.dismiss();
    // PassController.clear();
   checkPassVerifi(context);
      // showDialog(context: context, builder: (context)=>dialogNewPassowrd());s
      print("OTP  successfully");
    } else {
      EasyLoading.dismiss();
      snackBarErorr('كود التحقق خطاء', context);
          
             print("OTP code erorr:");

    }
  }


Future<void> updateUserCode(code,context) async {
  if(connected==true){
      print("No user found with the provided email and password.");

 await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: EmailController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print("No user found with the provided email and sadsd.");

      print("isfound");
      String documentId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('users').doc(documentId).update({
        'PassVerifiTowStaps': code,
      });
      EasyLoading.dismiss();
snackBar('تم تعديل الرمز بنجاح', context);
Get.back();
Get.back();

    } else {
      EasyLoading.dismiss();

      print("No user found with the provided email and password.");
    }
  } catch (e) {
      EasyLoading.dismiss();
    print("Error updating user name: $e");
  }
  }else{
    SnackbarNointernet();
  }
}






Future<void> updateUserPassowrd(context) async {
  if(connected==true){
      print("No user found with the provided email and password.");

 await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: EmailController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print("No user found with the provided email and sadsd.");

      print("isfound");
      String documentId = querySnapshot.docs.first.id;
      String oldPassword = querySnapshot.docs.first['password'];

      
         changePassword(context, oldPassword, PassController.text, documentId);
    } else {
      EasyLoading.dismiss();

      print("No user found with the provided email and password.");
    }
  } catch (e) {
      EasyLoading.dismiss();
    print("Error updating user name: $e");
  }
  }else{
    SnackbarNointernet();
  }
}


// changPassword(documentId,context)async{
//   await FirebaseFirestore.instance.collection('users').doc(documentId).update({
//         'password':'1q2w3e4r',
//       });
//       EasyLoading.dismiss();
//       PassController.clear();
// snackBar('تم تعديل كلمة المرور بنجاح', context);
// Get.back();
// Get.back();
// }














 Future<void> changePassword(BuildContext context, String oldPassword, String newPassword,idDo) async {
      if(connected==true){
  
    User? user = auth.currentUser;
    try{
   await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: EmailController.text.trim(),
    password: oldPassword
  );
  } on FirebaseAuthException catch (e) {
    print(e);
  }
    if (user != null) {
      // Get the user's email to reauthenticate
      String email = user.email!;
      print(email);
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword).then((value)async{
          // changPassword(idDo,context);
          await FirebaseAuth.instance.signOut();
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
      EasyLoading.dismiss();
                  // snackBar('كلمة السر القديمة خاطئة', context);

        } else {
      EasyLoading.dismiss();
                snackBar('لم يتم اعادة التعين يرجي المحاولة', context);

          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
        }
      }
    } else {
      EasyLoading.dismiss();
        snackBar('لم يتم اعادة التعين يرجي المحاولة', context);
      
    }
 }else{
    SnackbarNointernet();
  }
  }




// @override
//   void onInit() {
//     textControllers.forEach((element) { 
//       textControllers[0].clear();
//       textControllers[1].clear();
//       textControllers[2].clear();
//       textControllers[3].clear();
//       textControllers[4].clear();
//       textControllers[5].clear();


//     });
//     super.onInit();
//   }

}

