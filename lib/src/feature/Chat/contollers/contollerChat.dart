import 'dart:io';

import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Chat/Models/modelChats.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // FirebaseStorage _storage = FirebaseStorage.instance;
final TextEditingController nameChat=TextEditingController();
  Stream<List<ChatModel>> getMessages(String chatId) {
    return _firestore.collection('chats/$chatId/messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList());
  }

  Future<void> sendMesage(String chatId, ChatModel message) async {
    await _firestore.collection('chats/$chatId/messages').add(message.toMap());
  }
String senderId="DWDI3ENEJDENDIE";
 bool IsGroup=false;
 List UsersChat=[];
   Future<void> AddChat(context) async {
    if(connected==true){
    try {
       await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);

 String? imageUrl;
    if(selectedImage.value!=null){
    imageUrl= await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
      Get.snackbar('Error', 'لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }}


      await  FirebaseFirestore.instance
          .collection('Cahts').doc().set({
        'IsGroup': IsGroup,
        'createdAt':"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
        'idUsers':UsersChat,
        if(IsGroup==true)'imageUrl':imageUrl,
        if(IsGroup==true)'nameChat':nameChat.text,
         // Optional field for tracking
      });
  EasyLoading.dismiss();
    snackBar('تم  انشاء الجروب بنجاح', context);
      Get.back();
      update();
      clearsfeilds();
    } catch (e) {
      EasyLoading.dismiss();
    }
    }else{
  SnackbarNointernet();
}
  }

   Future<String?> uploadImage(File image) async {
    if(connected==true){
    try {
      String fileName = 'Chats/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
    }else{
      SnackbarNointernet();
      return null;
    }
  }

   // Function to pick image
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }
  clearsfeilds(){
   nameChat.clear();
  UsersChat.clear(); 
   selectedImage.value = null;
   IsGroup=false;
  }

List AddUserGroup=[];
void addUserToChat(String chatId,context) async {
  if(connected==true){
  await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  
    // Access Firestore and update the specific chat document
    FirebaseFirestore.instance.collection('Cahts').doc(chatId).update({
      'idUsers': FieldValue.arrayUnion(AddUserGroup),
    }).then((_) {
      print("User UID added to idUsers array");
    }).catchError((error) {
      print("Failed to add UID: $error");
    }).then((value){
        EasyLoading.dismiss();
    // snackBar('تم  انشاء الجروب بنجاح', context);
      Get.back();
      update();
    });  
    }else{
      SnackbarNointernet();
    }
}
update1(){
update();
}


void deletGroup(chatId)async{
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
        FirebaseFirestore.instance.collection('Cahts').doc(chatId).delete().then((value){
          EasyLoading.dismiss();
          Get.back();
          update();
        });
}else{
  SnackbarNointernet();
}
}


void DeleteUserFromChat(String chatId,context,UserRemove) async {
  if(connected==true){
  await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  
    // Access Firestore and update the specific chat document
    FirebaseFirestore.instance.collection('Cahts').doc(chatId).update({
      'idUsers': FieldValue.arrayRemove([UserRemove]),
    }).then((_) {
      print("User UID added to idUsers array");
    }).catchError((error) {
      print("Failed to add UID: $error");
    }).then((value){
        EasyLoading.dismiss();
    // snackBar('تم  انشاء الجروب بنجاح', context);
      Get.back();
      update();
    });  
  }else{
    SnackbarNointernet();
  }
}







editeIconGroups(chatId,imageUrlOld)async{
  if(connected==true){
          await pickImage(ImageSource.gallery);

   if(selectedImage.value!=null){

   await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,);
               String? imageUrl;
    if(selectedImage.value!=null){
    imageUrl= await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
   
      return;
    }}
    // Access Firestore and update the specific chat document
    FirebaseFirestore.instance.collection('Cahts').doc(chatId).update({
      'imageUrl':selectedImage.value!=null?imageUrl:imageUrlOld,
    }).then((_) {
      print("User UID added to idUsers array");
    }).catchError((error) {
      print("Failed to add UID: $error");
    }).then((value){
        EasyLoading.dismiss();
   selectedImage.value = null;

    // snackBar('تم  انشاء الجروب بنجاح', context);
      update();
    });  
}}else{
  SnackbarNointernet();
}
}


final TextEditingController NewNameGroup=TextEditingController();
editeNameGroups(chatId,)async{
if(connected==true){

   await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,);
 
    // Access Firestore and update the specific chat document
    FirebaseFirestore.instance.collection('Cahts').doc(chatId).update({
      'nameChat':NewNameGroup.text,
    }).then((_) {
    }).catchError((error) {
    }).then((value){
        EasyLoading.dismiss();
   NewNameGroup.clear();
Get.back();
    // snackBar('تم  انشاء الجروب بنجاح', context);
      update();
    }); 
}else{
  SnackbarNointernet();
}
}




}