import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

class ControllerChatConnet extends GetxController{
  final TextEditingController messageController=TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<XFile>? files = [];

  // Pick multiple files and upload them to Firebase Storage
  Future<List<String>?> pickAndUploadFiles() async {
    if(connected==true){
    await EasyLoading.show(status: 'انتظر يتم التحميل', maskType: EasyLoadingMaskType.black);
    files = await picker.pickMultiImage(); // Multiple image selection

    if (files != null && files!.isNotEmpty) {
      List<String> downloadUrls = [];
      for (var file in files!) {
        File fileToUpload = File(file.path);
        String fileName = file.name;
        Reference storageRef = FirebaseStorage.instance.ref().child('chat_files/$fileName');
        UploadTask uploadTask = storageRef.putFile(fileToUpload);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      EasyLoading.dismiss();
      return downloadUrls; // Return uploaded file URLs
    }
    EasyLoading.dismiss();
    return null;
    }else{
      SnackbarNointernet();
      return null;
    }
  }



ChatConnet(chatId,message,List<String> attachments,isAdmin){
  try{
     FirebaseFirestore.instance
          .collection('ChatConnet').doc(chatId).update({
        // 'numberUser':Phone.text,
        'message':message,
        // 'name':userName.text,
        'createdAt':"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
        // 'uidUser':currentUserId,

      }).then((value) {
           FirebaseFirestore.instance
          .collection('ChatConnet').doc(chatId).collection('messages').add({
            'message':message,
            'isRead':false,
            'uidUser':currentUserId,
            'timestamp':FieldValue.serverTimestamp(),
            'attachments':attachments,
            'isAdmin':isAdmin
          });
          update();
          // snackBar('تم ارسال رسالتك سيتم مراجعتها', context);
      });
      }
      catch (e){

      }
}


ChatConnetFirestMessage(context,message,userName,String PhoneDoc,List<String> attachments,isAdmin){
  try{
     FirebaseFirestore.instance
          .collection('ChatConnet').doc(PhoneDoc).set({
        // 'numberUser':Phone.text,
        'message':message,
        'name':userName,
        'createdAt':"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
        'uidUser':PhoneDoc,

      }).then((value) {
           FirebaseFirestore.instance
          .collection('ChatConnet').doc(PhoneDoc).collection('messages').add({
            'message':message,
            'isRead':false,
            'uidUser':currentUserId,
            'timestamp':FieldValue.serverTimestamp(),
            'attachments':attachments,
            'isAdmin':isAdmin

          });
          message.clear();
          snackBar('تم ارسال رسالتك سيتم مراجعتها', context);
          update();
      });
      }
      catch (e){

      }
}






   void markMessageAsRead(String messageId,chatId) {
    FirebaseFirestore.instance
        .collection('ChatConnet')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  } 
}