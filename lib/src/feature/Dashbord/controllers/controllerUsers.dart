// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

abstract class UsersControllers extends GetxController{

}
class UsersControllersImp extends UsersControllers{
 final CollectionReference collectionReference =FirebaseFirestore.instance.collection("users");
  final FirebaseAuth auth = FirebaseAuth.instance;

    String? GroupvalueUser;
    String? UidUsers=null;
String? GroupvalueLogIn;
    RadioCangeUser(value){
      GroupvalueUser=value as String?;
      update();
    }
     RadioCangeLogIn(value){
      GroupvalueLogIn=value as String?;
      update();
    }


   ContolUsers(context)async{
    if(connected==true){
    // ignore: unused_local_variable
    // bool isActive=GroupvalueLogIn as bool ;
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
     await collectionReference.doc(UidUsers).update({
          "isActive":GroupvalueLogIn,
          "TypeLogin":GroupvalueUser,
        }).then((value) {
          EasyLoading.dismiss();
          Get.back();
          snackBar('تم التعديل', context);
          });
          }else{
      SnackbarNointernet();
    }
   }
   

    fetchUser(context,from) async 
  {
    try {
      QuerySnapshot querySnapshot = (await FirebaseFirestore.instance .collection('users').where('uid',isEqualTo: currentUserId).get());

      // Mapping documents to list
    
        currentUserData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
    print(currentUserData);
    update();
      await FirebaseMessaging.instance  .subscribeToTopic('AllUsers');
      await FirebaseMessaging.instance  .subscribeToTopic('${currentUserData[0]['uid']}');
        await sharedPreferences.setBool('IsEnable',currentUserData[0]['isEnable']);
        // currentUserId='${sharedPreferences.getString('uid')}';
        currentUserId=auth.currentUser!.uid;
        IsEnable=currentUserData[0]['isEnable'];
        IsEnable=sharedPreferences.getBool('IsEnable')??false;
        if(IsEnable==true&&from==false){
     EasyLoading.dismiss();
      Navigator.of(context).pushNamedAndRemoveUntil('homePageApp', (route) => false);
        }else if(IsEnable==false&&from==false){
           EasyLoading.dismiss();
      Navigator.of(context).pushNamedAndRemoveUntil('loginSgin', (route) => false);
          snackBar('مسجل دخول ولاكن غير مخول يرجي التواصل مع الادارة', context);
        }
        else{
      Navigator.of(context).pushNamedAndRemoveUntil('loginSgin', (route) => false);
        }
        if(currentUserData[0]['isAdmin']==true)
      await FirebaseMessaging.instance  .subscribeToTopic('isAdmin');
         
    
    } catch (e) {
      print('Error fetching users: $e');
    update();

    }
  }
}