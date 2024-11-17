// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/functions/cloud_messaging.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

 class UsersControllers extends GetxController{


 final CollectionReference collectionReference =FirebaseFirestore.instance.collection("users");

    bool? GroupvalueUser;
    String? UidUsers=null;
bool? GroupvalueLogIn;
    RadioCangeUser(value){
      GroupvalueUser=value;
      update();
    }
     RadioCangeLogIn(value){
      GroupvalueLogIn=value;
      update();
    }
bool? IsAcsept;

RadioCangeIsAcsept(value){
      IsAcsept=value;
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
          "isEnable":GroupvalueLogIn,
          "isAdmin":GroupvalueUser,
          "IsAcsept":IsAcsept
        }).then((value) async{
       if(GroupvalueLogIn==true&&IsAcsept==false) {
         await PushNotificationService.sendNotificationToTopic([UidUsers],
       GroupvalueLogIn==true&&IsAcsept==false?'تم قبول حسابك ':GroupvalueLogIn==false?'تم ايقاف حسابك':'',
        GroupvalueLogIn==true&&IsAcsept==false?'تم قبول حسابك يرجي توثيق الهوية الشخصية':GroupvalueLogIn==false?'تم ايقاف حسابك':'',
        currentUserId,'Type','',context);
       }

  if(IsAcsept==true&&GroupvalueLogIn==true) {
    await PushNotificationService.sendNotificationToTopic([UidUsers],
       'تم قبول الهوية ',
        'تم قبول الهوية الشخصية',
        currentUserId,'Type','',context);
  }
      
          EasyLoading.dismiss();
          Get.back();
          snackBar('تم التعديل', context);
          });
   }else{}
   SnackbarNointernet();
   } 

}