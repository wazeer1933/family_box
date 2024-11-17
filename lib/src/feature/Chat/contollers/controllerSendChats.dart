import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChatController1 extends GetxController {
  String? chatId;
  String? userId;
  String?frindId;
  final TextEditingController messageController = TextEditingController();
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

  // Save files to device
  Future<void> saveFileToDevice(String url, String fileName,context) async {
    try {
      var response = await HttpClient().getUrl(Uri.parse(url));
      var fileBytes = await response.close();
      var directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/$fileName');
      await fileBytes.pipe(file.openWrite());
            snackBar('تم التحميل ', context);

    } catch (e) {
                  snackBarErorr('لم يتم التحميل ', context);

    }
  }

  // Send a message with optional attachments
  void sendMessage(String message, List<String> attachments) {
      messageController.clear();
   if(IsGroup==true){
     FirebaseFirestore.instance.collection('Cahts').doc(chatId).collection('messages').add({
      'message': message,
      'senderId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'attachments': attachments,
      'isRead': false,
    }).then((value) {
      files = [];
      update();
    });
   }else if(IsGroup==false&&chatExistsChat==true){
     FirebaseFirestore.instance.collection('Cahts').doc(chatId).collection('messages').add({
      'message': message,
      'senderId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'attachments': attachments,
      'isRead': false,
    }).then((value) {
      files = [];
      update();
    });
   }else{
    
    try {
          FirebaseFirestore.instance
          .collection('Cahts').doc(RandomUidChat).set({
        'IsGroup': false,
        'createdAt':"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
        'idUsers':[userId,frindId],
      }).then((value){
          FirebaseFirestore.instance.collection('Cahts').doc(RandomUidChat).collection('messages').add({
      'message': message,
      'senderId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'attachments': attachments,
      'isRead': false,
    }).then((value) {
      chatId=RandomUidChat;
      files = [];
      update();
      update();
      chatExistsChat=true;
    });
      });

    } catch (e) {
      EasyLoading.dismiss();
    }
  
   }
   
  }
  String? RandomUidChat;
////////////////////////////////////////////////

String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}
  // Mark message as read
  void markMessageAsRead(String messageId) {
    FirebaseFirestore.instance
        .collection('Cahts')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }
 








  // ignore: non_constant_identifier_names
  bool?IsGroup=false;
  bool chatExistsChat=false;
  ///////////////////////////
void checkChatExists() async {
  if (IsGroup == false) {
    await EasyLoading.show(dismissOnTap: false,status: 'انتظر', maskType: EasyLoadingMaskType.black);
    
    print('userId === $userId');
    print('frindId === $frindId');
    
    // Fetch all chats where userId is part of idUsers
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Cahts')
        .where('IsGroup', isEqualTo: false)
        .where('idUsers', arrayContains: userId)
        .get();
    
    // Check if any chat has both userId and frindId in the 'idUsers' array
    bool chatExists = querySnapshot.docs.any((doc) {
      List<dynamic> users = doc['idUsers'];
      bool exists = users.contains(frindId);
      
      if (exists) {
        chatId=doc.id;
        print('Matching chat found: doc.id = ${chatId}');
        update();
      }else{

      }
      
      return exists;
    });

    // Take appropriate action based on whether a chat exists or not
    if (chatExists) {
      EasyLoading.dismiss();
      chatExistsChat = true;
      print('True, chat exists between both users. chatExistsChat = $chatExistsChat');
    } else {
      EasyLoading.dismiss();
      RandomUidChat = generateRandomString(40);
      chatId = RandomUidChat;
      chatExistsChat = false;
      print('False, no chat exists between both users. chatExistsChat = $chatExistsChat');
    }
  } else {
    IsGroup = true;
    print('IsGroup: $IsGroup');
  }
}

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

String? lastMessage;
 Future<String> getLastMessage(String chatId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Cahts')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
         lastMessage=snapshot.docs.first['message'];
        // print('${snapshot.docs.first['message']}');
        return '${snapshot.docs.first['message']}';
      }
      return '';
    } catch (e) {
      print('Error fetching last message: $e');
      return '';
    }
  }

}