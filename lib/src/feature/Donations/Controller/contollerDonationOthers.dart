// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class contollerDonationOthers extends GetxController {
  
TextEditingController controller=TextEditingController();


 Future<void> addDonationSharingUsers(context,type) async {
     if(connected==true){
    try {
       await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
      await  FirebaseFirestore.instance
          .collection('donationPayments').add
          ({
        'userId': currentUserId,
        'createdAt': '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        'cost':controller.text,
        'type':type,
      }).then((value) {
 EasyLoading.dismiss();
                                    snackBar ('تم  لمساهمة بتجاح شكرا لك ', context);
      controller.clear();
      update();
      Get.back();
      Get.back();
      Get.back();

      });
 
    } catch (e) {
      EasyLoading.dismiss();
    }
  }else{
    SnackbarNointernet();
  }
 }
}