import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class contrllerSettingsapp extends GetxController{
    final formKey = GlobalKey<FormState>();

  final TextEditingController phone = TextEditingController();
  final TextEditingController whattsapp = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController privacy = TextEditingController();
updatedata(context,doc)async{
  if(connected==true){
   await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    // ignore: avoid_single_cascade_in_expression_statements
    await FirebaseFirestore.instance.collection("setings").doc(doc).update({
        'phone':phone.text,
        'whattsapp':whattsapp.text,
        'email':email.text,
        // 'privacy'
      }).then((value){
        Get.back();
        EasyLoading.dismiss();
        update();
        snackBar('تم  بنجاح', context);
      });
  }else{
    SnackbarNointernet();
  }
}


updatedataprivacy(context,doc)async{
  if(connected==true){
   await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
    // ignore: avoid_single_cascade_in_expression_statements
    await FirebaseFirestore.instance.collection("setings").doc(doc).update({
        'privacy':privacy.text
      }).then((value){
        Get.back();
        EasyLoading.dismiss();
        update();
        snackBar('تم  بنجاح', context);
      });
  }else{
    SnackbarNointernet();
  }
}
}