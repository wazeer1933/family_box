import 'dart:math';

import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/core/functions/cloud_messaging.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String verificationId;

  final userNameController = TextEditingController();
  final PhoneController = TextEditingController();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final RePasswordController = TextEditingController();
  String gender = "Male"; // Default gender selection

onChanged(value)
{
gender=value;
update();
}
Future<void> verifyPhoneNumber(context) async {
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      _auth.signInWithCredential(authResult);
      // Handle sign in
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
            if (authException.code == 'invalid-phone-number') {
        // Invalid phone number entered
      snackBar("رقم غير فعال" , context);
         EasyLoading.dismiss();
    
        print('Invalid phone number format.');
      } else if (authException.code == 'too-many-requests') {
        // Too many verification requests
      snackBar("لقد اجريت العديد من الطلبات يرجي المحاولة في وقت اخر" , context);
         EasyLoading.dismiss();


        print('Too many verification attempts. Please try again later.');
      }else{
      snackBar("لن نتمكن من ارسال رسالة الئ رقمك" , context);
         EasyLoading.dismiss();
      }
      // ... Handle other potential errors
      print('Phone number verification failed. Code: ${authException.code}');
      
    };
    final PhoneCodeSent smsSent = (String verId, [int? forceResendingToken]) {
      verificationId = verId;
      print("======================================================$verificationFailed");
            snackBar("تم ارسال رسالة نصيةالئ رقمك", context);
            EasyLoading.dismiss();

    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationId = verId;
      print(verificationFailed);

    };
    await _auth.verifyPhoneNumber(
      phoneNumber: "+${PhoneController.text.trim()}",
      timeout: Duration(seconds: 0),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );

  }

  // Method to sign in with phone number
  // void signInWithPhoneNumber() async {
  
  //   await EasyLoading.show(
  //       status: '...انتظر',
  //       maskType: EasyLoadingMaskType.black,
  //       dismissOnTap: true);
        
  //   await _auth.verifyPhoneNumber(
  //     timeout: const Duration(minutes: 2),
  //     phoneNumber:'+${ PhoneController.text}',
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await _auth.signInWithCredential(credential);
  //       Get.snackbar("Success", "Phone number automatically verified");
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       EasyLoading.dismiss();
  //       Get.snackbar("Error", e.message ?? "Unknown error occurred");
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       this.verificationId = verificationId;
  //       EasyLoading.dismiss();
  //       Get.to(SegininVeryfation()); // Navigate to the verification screen
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       EasyLoading.dismiss();
  //       this.verificationId = verificationId;
  //     },
  //   );
  // }

  // Verify OTP code
  void verifyOTP(String otp,context) async {
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        EasyLoading.dismiss();
        saveUserDataToFirestore(context);
        Get.offAll(PageHome()); // Navigate to the home screen
      }
    } catch (e) {
        EasyLoading.dismiss();
    
      Get.snackbar("Error", "Failed to sign in");
    }
  }



Future<bool> checkEmailExists() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        // .where('phone',isEqualTo: PhoneController.text.trim())
        .where('email', isEqualTo: EmailController.text.trim())
        .limit(1) // Only need to check if one document exists
        .get();
final querySnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .where('phone',isEqualTo: PhoneController.text.trim())
        // .where('email', isEqualTo: EmailController.text.trim())
        .limit(1) // Only need to check if one document exists
        .get();
    return querySnapshot.docs.isNotEmpty ||querySnapshot2.docs.isNotEmpty?true:false; // True if email exists
  } catch (e) {
    print("Error checking email existence: $e");
    return false; // Handle errors appropriately in production
  }
}




  Future<void> signInEmail(context) async {
  if(connected==true){

     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);

bool exists = await checkEmailExists();
if(exists){
  EasyLoading.dismiss();
snackBarErorr('هاذا الحساب مسجل مسبقا ', context);

 
}else{
  EasyLoading.dismiss();
   saveUserDataToFirestore(context);

}}else{
  SnackbarNointernet();
}
  }


  Future<void> signInWithEmailAndPassword(context) async {
    if(connected==true){
         await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);

bool exists = await checkEmailExists();
if(exists){
  EasyLoading.dismiss();
snackBarErorr('هاذا الحساب مسجل مسبقا ', context);

}else{
  try {
  // ignore: unused_local_variable
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: EmailController.text.trim(),
    password: PasswordController.text.trim(),
  ).then((value){
    sUserDataToFirestore(context);
  });
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
            snackBarErorr('كلمة السر ضعيفة', context);
            EasyLoading.dismiss();
  } else if (e.code == 'email-already-in-use') {
                snackBarErorr('الحساب مسجل مسبقا', context);
            EasyLoading.dismiss();
  }else if (e.code == 'invalid-email') {
        snackBarErorr('بريد غير صالح', context);}
        
} catch (e) {
  EasyLoading.dismiss();
  print(e);
}
//  try {
//       await _auth.signInWithEmailAndPassword(
//         email: EmailController.text,
//         password: PasswordController.text,
//       ).then((value) {
//         saveUserDataToFirestore(context);
//       });
//       // Navigate to the next screen or show a success message
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         snackBarErorr('كلمة السر ضعيفة', context);
//       } else if (e.code == 'invalid-email') {
//         snackBarErorr('بريد غير صالح', context);
//       } else if (e.code == 'user-not-found') {
//         // errorMessage = 'No user found with this email.';
//       } else if (e.code == 'wrong-password') {
//         // errorMessage = 'Wrong password provided.';
//       } else {
//         print(e);
//         EasyLoading.dismiss();
//       }

//       // Display the error message using a Snackbar
     
//     }
}}else{
  SnackbarNointernet();
}
  }





String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

  // Save user data to Firestore
  void saveUserDataToFirestore(context) async {
    // User? user = _auth.currentUser;
    // if (user != null) {
    String uid=generateRandomString(40);
      await _firestore.collection("users").doc(uid).set({
        "name": userNameController.text,
        "email": EmailController.text,
        "phone": PhoneController.text.trim(),
        "password":PasswordController.text.trim(),
        "gender": gender,
        "uid": uid,
        'isAdmin':false,
        'isEnable':false,
        'tree':'',
        'maride':'',
        'dateBithe':'',
        'image':'',
        'spical':'',
        'IsAcsept':false,
        'imageUrlIdentity':'',
        'updateDate':'',
        'ckeckTowStaps':''
        // 'address':
      }).then((value)async{
        // await sharedPreferences.setString('uid',uid);
        EasyLoading.dismiss();
      Navigator.of(context).pushNamedAndRemoveUntil('loginSgin', (route) => false);
snackBar('تم ارسال طلبك طلبك تحت المراجعة', context);
      await PushNotificationService.sendNotificationToTopic(['isAdmin'],'طلب  مراجعة الحساب  تسحيل حساب','${userNameController.text} : طلب تحق',currentUserId,'حساب','',context);

        FirebaseFirestore.instance.collection('Notfications').add({
      'idUsersSender': currentUserId,
      'IdUserRecive':['isAdmin'],
      'title': 'طلب  مراجعة الحساب  تسحيل حساب',
      'body':'${userNameController.text} : طلب تحق',
      'id': '',
      'type':'حساب',
      'date':'${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      'isRead':false,

    }).then((value){
cleartext();
    });
      });
    // }
  
}






 // Save user data to Firestore
  void sUserDataToFirestore(context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).set({
        "name": userNameController.text,
        "email": EmailController.text,
        "phone": PhoneController.text.trim(),
        "password":PasswordController.text.trim(),
        "gender": gender,
        "uid": user.uid,
        'isAdmin':false,
        'isEnable':false,
        'tree':'',
        'maride':'',
        'dateBithe':'',
        'image':'',
        'spical':'',
        'IsAcsept':false,
        'imageUrlIdentity':'',
        'updateDate':'',
        'ckeckTowStaps':''
        // 'address':
      }).then((value)async{
        await sharedPreferences.setString('uid',user.uid);
        EasyLoading.dismiss();
      Navigator.of(context).pushNamedAndRemoveUntil('loginSgin', (route) => false);
snackBar('تم ارسال طلبك طلبك تحت المراجعة', context);
      await PushNotificationService.sendNotificationToTopic(['isAdmin'],'طلب  مراجعة الحساب  تسحيل حساب','${userNameController.text} : طلب تحق',currentUserId,'حساب','',context);

        FirebaseFirestore.instance.collection('Notfications').add({
      'idUsersSender': currentUserId,
      'IdUserRecive':['isAdmin'],
      'title': 'طلب  مراجعة الحساب  تسحيل حساب',
      'body':'${userNameController.text} : طلب تحق',
      'id': '',
      'type':'حساب',
      'date':'${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
      'isRead':false,

    }).then((value){
cleartext();
    });
      });
    }
  
}










cleartext(){
  EmailController.clear();
  userNameController.clear();
  PhoneController.clear();
  PasswordController.clear();
  Get.back();

}



  final TextEditingController userName= TextEditingController();
  final TextEditingController Phone = TextEditingController();
  final TextEditingController message = TextEditingController();


ChatConnet(context){
  try{
     FirebaseFirestore.instance
          .collection('ChatConnet').doc(currentUserId).set({
        // 'numberUser':Phone.text,
        'message':message.text,
        'name':userName.text,
        'createdAt':"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
        'uidUser':currentUserId,

      }).then((value) {
           FirebaseFirestore.instance
          .collection('ChatConnet').doc(currentUserId).collection('messages').add({
            'message':message.text,
            'isRead':false,
            'uidUser':currentUserId,
            'timestamp':FieldValue.serverTimestamp(),
            'attachments':[],
            'isAdmin':false
          });
          message.clear();
          snackBar('تم ارسال رسالتك سيتم مراجعتها', context);
      });
      }
      catch (e){

      }
}




}

  snackBar(String? message,context) {
    
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: appColors.primary,
        content: Row(textDirection: TextDirection.rtl,mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(message!),Icon(Icons.turned_in_sharp,color: Colors.white,)
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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