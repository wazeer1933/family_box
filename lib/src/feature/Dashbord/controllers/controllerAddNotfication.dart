import 'package:family_box/main.dart';
import 'package:family_box/src/core/functions/cloud_messaging.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:multi_dropdown/models/value_item.dart';
 abstract class controllerAddNotfication extends GetxController{
 }
class controllerAddNotficationImp extends  controllerAddNotfication{

  
  // TextEditingControllers for text fields
    late TextEditingController title=TextEditingController();
  late  TextEditingController body=TextEditingController();
  late  TextEditingController Type=TextEditingController();
  late  TextEditingController date=TextEditingController();

 List UsersRes=[];

 bool IsAll=false;
 onChanged(value) {IsAll= value!;update();}



void addNewNotficatons(context) async {
  if(connected==true){
  await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);

    // Access Firestore and update the specific chat document
    FirebaseFirestore.instance.collection('Notfications').add({
      'idUsersSender': currentUserId,
      'IdUserRecive':IsAll==false?UsersRes:['AllUsers'],
      'title': title.text,
      'body': body.text,
      'id': '',
      'type':Type.text,
      'date':date.text,
      'isRead':false,

    }).then((_) async{
      print("User UID added to idUsers array");
      await PushNotificationService.sendNotificationToTopic(IsAll==false?UsersRes:['AllUsers'],title.text, body.text,currentUserId,Type.text,'',context);
      
                     update();

    }).catchError((error) {
      update();
      print("Failed to add UID: $error");
    }).then((value){
        update();

    });  
  }else{
    SnackbarNointernet();
  }
}



  void markMessageAsRead(String docid) {
    FirebaseFirestore.instance
        .collection('Notfications')
        .doc(docid)
        .update({'isRead': true});
  }

  @override
  void onInit() {

    super.onInit();
  }






void deleteDocument( String documentId,context) async {
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  try {
    // Get a reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('Notfications');
    
    // Delete the document with the specific ID
    await collectionRef.doc(documentId).delete().then((value){
        update();
      EasyLoading.dismiss();
      snackBar('تم الحذف بنجاح', context);
    });
    
  } catch (e) {
      EasyLoading.dismiss();

    print("Error deleting document: $e");
  }
}
else{
  SnackbarNointernet();
}
}


}





