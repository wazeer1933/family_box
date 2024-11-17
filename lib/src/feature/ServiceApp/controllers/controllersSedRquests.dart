import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class controllerSendRequset extends GetxController {

  final TextEditingController typeRequest = TextEditingController();
  final TextEditingController discriptionRquest = TextEditingController();

  String?UidUser="DWDI3ENEJDENDIE";
  Future<void> addRequestUsers(context) async {
  if (connected==true) {
    
  
    try {
       await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
      await  FirebaseFirestore.instance
          .collection('RequestsUsers').doc().set({
        'idUserRqu': currentUserId,
        'createdAt':"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
        'typeRequest':typeRequest.text,
        'discriptionRquest':discriptionRquest.text,
        'state':0,
         // Optional field for tracking
      });
  EasyLoading.dismiss();
  
    snackBar('تم ارسال الطلب بنجاح', context);
      Get.back();
      update();
    } catch (e) {
      EasyLoading.dismiss();

  
    }
  }else{
    SnackbarNointernet();
  }
  }

String? uidDoc;
  Future<void> UpdateRequestUsers(context,state) async {
  if(connected==true){
    try {
       await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
      await  FirebaseFirestore.instance
          .collection('RequestsUsers').doc(uidDoc).update({
        'state':state,
         // Optional field for tracking
      });
  EasyLoading.dismiss();
  
    snackBar('تم تعديل الطلب بنجاح', context);
      Get.back();
      update();
    } catch (e) {
      EasyLoading.dismiss();

  
    }
  }else{
    SnackbarNointernet();
  }
  }
  @override
  void onInit() {
    super.onInit();
    print("=======================");
  }

  
  
}




