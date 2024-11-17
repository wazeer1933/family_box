import 'dart:io';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Donations/Controller/contollerCountLikeCountCoust.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationController extends GetxController {
  // TextEditingControllers for text fields
  final TextEditingController donationTypeController = TextEditingController();
  final TextEditingController donationDescriptionController = TextEditingController();
   String? date;
  final TextEditingController donationCostController = TextEditingController();
  final TextEditingController donationTitleController = TextEditingController();

  final TextEditingController recipientIdController = TextEditingController();
final contollerCountLikeCountCoust controller= Get.put(contollerCountLikeCountCoust());
  // Image variables
  Rx<File?> selectedImage = Rx<File?>(null);

  // Function to pick image
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // Function to upload the image to Firebase Storage and get the URL
  Future<String?> uploadImage(File image) async {
    if(connected==true){
    try {
      String fileName = 'donations/${DateTime.now().millisecondsSinceEpoch}.jpg';
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
    }}

  // Function to add donation data to Firestore
  Future<void> addDonation(context) async {
    if(connected==true){
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    if (selectedImage.value == null) {
           snackBarErorr('لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ', context);

         
      return;
    }

    String? imageUrl = await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
                 snackBarErorr('لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ', context);

      return;
    }

    try {
      await FirebaseFirestore.instance.collection('donations').add({
        'donationType': donationTypeController.text,
        'donationDescription': donationDescriptionController.text,
        'donationDate': date,
        'donationCost': donationCostController.text,
        'recipientId': recipientIdController.text,
        'imageUrl': imageUrl,
        'title':donationTitleController.text
      });
      Get.back();
      EasyLoading.dismiss();
      Get.snackbar('', 'تم الاضافة بنجاح',titleText: Text("تم"),backgroundColor: AppColors().blueshade600,
          snackPosition: SnackPosition.BOTTOM);
      clearFields();
      update();
    } catch (e) {
      EasyLoading.dismiss();
update();
      Get.snackbar('خطاء', 'يرجي اختيار صورة $e',
          snackPosition: SnackPosition.BOTTOM);
    }
    }else{
      SnackbarNointernet();
    }
    
  }
  ////////////////////////////////////////////
  ///
  ///
  String? UidDoc;
  String?UidUser="DWDI3ENEJDENDIE";
  bool hideName = false;
  String?IdPaymentMyf;
  final contollerCountLikeCountCoust conCount=Get.put(contollerCountLikeCountCoust());
 Future<void> addDonationSharingUsers( typePayment,String cost,context) async {
     if(connected==true){
    try {
       await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
      await  FirebaseFirestore.instance
          .collection('donations')
          .doc('$UidDoc')
          .collection('Payments').doc().set
          ({
        // 'IdPaymentMyf': IdPaymentMyf,
        'userId': UidUser,
        // 'urlimage': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        // 'typePayment':typePayment,
        'cost':cost,
        'hideName':hideName
         // Optional field for tracking
      });
  EasyLoading.dismiss();
                                    snackBar ('تم  لمساهمة بتجاح شكرا لك ', context);
               conCount.getCount(UidDoc);
          controller.fetchTotalPaymentsCost(UidDoc!);
      update();
      Get.back();
      Get.back();
    } catch (e) {
      EasyLoading.dismiss();

      // Get.snackbar('خطاء', ' لم $e',
      //     snackPosition: SnackPosition.BOTTOM);
    }
     }else{
      SnackbarNointernet();
    }
  }

  // Function to clear input fields
  void clearFields() {
    donationTypeController.clear();
    donationDescriptionController.clear();
    // date="";
    donationCostController.clear();
    recipientIdController.clear();
    selectedImage.value = null;
  }
  /////////////////////////////////////////add images//////////////////////////
  

  var selectedImages = <File>[].obs;
  final picker = ImagePicker();

  // Pick multiple images
  Future<void> pickImages(context) async {
    final pickedFiles = await picker.pickMultiImage();
    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      selectedImages.value = pickedFiles.map((e) => File(e.path)).toList();
    } else {
                       snackBarErorr('لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ', context);

    }
  }

  // Upload images to Firebase Storage and add their URLs to Firestore
  Future<void> uploadImagesToFirebase(context) async {
    if(connected==true){
    if (selectedImages.isEmpty) {
                             snackBarErorr('لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ', context);

      return;
    }

    try {
      for (var image in selectedImages) {
        // Upload to Firebase Storage
           await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
        String fileName = image.path.split('/').last;
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('donations/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the download URL in Firestore
        await FirebaseFirestore.instance
            .collection('donations')
            .doc(UidDoc) // Document can be a specific ID if needed
            .collection('images')
            .add({'url': downloadUrl});
      }

      EasyLoading.dismiss();
      Get.snackbar('', 'تم الاضافة بنجاح',titleText: Text("نجاح"),backgroundColor: AppColors().blueshade600,
          snackPosition: SnackPosition.BOTTOM);
      selectedImages.clear();
      Get.back();
      Get.back();

    } catch (e) {
       EasyLoading.dismiss();
      Get.snackbar('خطاء', ' خطاء $e',
          snackPosition: SnackPosition.BOTTOM);
    }
   }else{
      SnackbarNointernet();
    }
  }
}






