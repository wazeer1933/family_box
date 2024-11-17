// ignore_for_file: unused_field

import 'dart:io';

import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class controllerEditeMyProfile extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final formKeySm= GlobalKey<FormState>();
  final formKeyOtherInf= GlobalKey<FormState>();



  late String verificationId;

  final userNameController = TextEditingController();
  final PhoneController = TextEditingController();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final RePasswordController = TextEditingController();
  final GenderController = TextEditingController();
  final dateBirthController = TextEditingController();
  final AddressController = TextEditingController();
  final MardingController = TextEditingController();
  final SpicalController = TextEditingController();


String? imageUrlold;

  String? gender; // Default gender selection

onchaneegnder(value){
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
      phoneNumber: "+${PhoneController.text}",
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
  void verifyOTP(String otp) async {
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
        // saveUserDataToFirestore();
        Get.offAll(PageHome()); // Navigate to the home screen
      }
    } catch (e) {
        EasyLoading.dismiss();
    
      Get.snackbar("Error", "Failed to sign in");
    }
  }
String? uidDoc;
  Rx<File?> selectedImage = Rx<File?>(null);
 Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);
      update();
    }
  }
    // Function to upload the image to Firebase Storage and get the URL
  Future<String?> uploadImage(File image) async {
    if(connected==true){
    try {
      String fileName = 'profile/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }}else{
    SnackbarNointernet();
    return null;
  }
  }
  final UsersControllersImp conuser=Get.put(UsersControllersImp());

  // Save user data to Firestore
  void EediteUserDataToFirestore(context) async {
    if(connected==true){
    // User? user = _auth.currentUser;
    // if (user != null) {
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
      String? imageUrl;
    if(selectedImage.value!=null){
    imageUrl= await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
      Get.snackbar('Error', 'لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }}
      
      await _firestore.collection("users").doc(currentUserId).update({
        "name": userNameController.text,
        "email": EmailController.text,
        "phone": PhoneController.text,
        "password":PasswordController.text,
        "gender": gender,
        'maride':MardingController.text,
        'spical':SpicalController.text,
        'dateBithe':dateBirthController.text,
        'image':selectedImage.value!=null? imageUrl:imageUrlold,
      }).then((value){
        Get.back();
        selectedImage.value=null;
        EasyLoading.dismiss();
        snackBar('تم التعديل بنجاح', context);
        conuser.fetchUser(context,true);
      });
    // }
   }else{
    SnackbarNointernet();
  }
  }

String? imageUrlIdentity;
  void indentityUserImage(context) async {
  if(connected==true){

    // User? user = _auth.currentUser;
    // if (user != null) {
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
      String? imageUrl;
    if(selectedImage.value!=null){
    imageUrl= await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
    
      return;
    }}
       
      await _firestore.collection("users").doc(currentUserId).update({
        'imageUrlIdentity':selectedImage.value!=null? imageUrl:imageUrlIdentity
      }).then((value){
        Get.back();
        imageUrlIdentity=imageUrl;
        selectedImage.value=null;
        EasyLoading.dismiss();
        snackBar('تم الاضافة بنجاح', context);
      });
    }else{
    SnackbarNointernet();
  }
  }
  



  Future<void> changePassword(BuildContext context, String oldPassword, String newPassword) async {
      if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    User? user = _auth.currentUser;

    if (user != null) {
      // Get the user's email to reauthenticate
      String email = user.email!;
      print(email);
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword).then((value){
          changePassowrd(context);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
                  snackBar('كلمة السر القديمة خاطئة', context);

        } else {
      EasyLoading.dismiss();
        snackBar('لم يتم اعادة التعين بنجاح', context);

          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
        }
      }
    } else {
      EasyLoading.dismiss();
        snackBar('لم يتم اعادة التعين بنجاح', context);
      
    }
 }else{
    SnackbarNointernet();
  }
  }




User? user = FirebaseAuth.instance.currentUser;
changePassowrd(context)async{
  // if(connected==true){
  //   await EasyLoading.show(
  //       status: '...انتظر',
  //       maskType: EasyLoadingMaskType.black,
  //       dismissOnTap: true);
     
    await _firestore.collection("users").doc(currentUserId).update({
        'password':RePasswordController.text
      }).then((value)async{
        Get.back();
        PasswordController.text=RePasswordController.text;
        RePasswordController.clear();
        EasyLoading.dismiss();
        update();
        snackBar('تم اعادة التعين بنجاح', context);
      });
 
}


changeEmail(context)async{
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    await _firestore.collection("users").doc(currentUserId).update({
        'email':RePasswordController.text
      }).then((value)async{
        await user!.updateEmail(EmailController.text.trim());
      await user!.reload();
        Get.back();
        EmailController.clear();
    
        EasyLoading.dismiss();
        update();
        snackBar('تم تغير الايمل  بنجاح', context);
      });
  }else{
    SnackbarNointernet();
  }
}


///////////////////////////////////////////////
  final whattsappController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final xController = TextEditingController();
  SuioalMedia(context)async{
    if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    await _firestore.collection("users").doc(currentUserId).collection('SuioalMedia').doc(currentUserId).set
    ({
        'whattsapp':whattsappController.text.trim(),
        'facebook':facebookController.text,
        'instagram':instagramController.text,
        'x':xController.text,

      }).then((value){
        Get.back();
        EasyLoading.dismiss();
        update();
        snackBar('تم  بنجاح', context);
      });
    }else{
      SnackbarNointernet();
;    }
}

void openSuioalMedia({required String urls}) async {
  final Uri url = Uri.parse(urls);

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not open ";
  }
}

  final NameInfoController = TextEditingController();
  final NotInfoController = TextEditingController();


AddNowInfo(context)async{
  if(connected==true){
   await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    await _firestore.collection("users").doc(currentUserId).collection('InfoOther').add
    ({
        'name':NameInfoController.text,
        'body':NotInfoController.text
      }).then((value){
        Get.back();
        NameInfoController.clear();
        EasyLoading.dismiss();
        update();
        snackBar('تم  بنجاح', context);
      });
  }else{
    SnackbarNointernet();
  }
}



DeleteInfo(context,doc)async{
  if(connected==true){
   await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    await _firestore.collection("users").doc(currentUserId).collection('InfoOther').doc(doc).delete().then((value){
      Get.back();
        NameInfoController.clear();
        EasyLoading.dismiss();
        update();
        snackBar('تم الحذف بنجاح', context);
    });
}else{
  SnackbarNointernet();
}
}
}

  snackBar(String? message,context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green,
        content: Row(textDirection: TextDirection.rtl,mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(message!),Icon(Icons.turned_in_sharp,color: Colors.white,)
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }