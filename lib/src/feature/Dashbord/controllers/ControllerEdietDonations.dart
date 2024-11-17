import 'dart:io';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:multi_dropdown/models/value_item.dart';
 abstract class EditeDonationController extends GetxController{
 }
class EditeDonationControllerImp extends  EditeDonationController{

  
  // TextEditingControllers for text fields
    late TextEditingController donationTypeController;
  late  TextEditingController donationDescriptionController;
   String? date;
String? imageUrlEdite;

  late  TextEditingController donationCostController;
  late  TextEditingController donationTitleController;

  late  TextEditingController recipientIdController;
// final contollerCountLikeCountCoust controller= Get.put(contollerCountLikeCountCoust());
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
    }
  }

  // Function to add donation data to Firestore
  
  ////////////////////////////////////////////
   // Function to add donation data to Firestore
  Future<void> EditeDonation(context) async {
print("object");
if(connected==true){
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);

    String? imageUrl;
    if(selectedImage.value!=null){
    imageUrl= await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
      
      snackBarErorr('لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ', context);

      return;
    }}
    try {
      await FirebaseFirestore.instance.collection('donations').doc(UidDoc).update({
        'donationType': donationTypeController.text,
        'donationDescription': donationDescriptionController.text,
        'donationDate': date,
        'donationCost': donationCostController.text,
        'recipientId': recipientIdController.text,
        'imageUrl':selectedImage.value==null? imageUrlEdite:imageUrl,
        'title':donationTitleController.text
      });
      Get.back();
      EasyLoading.dismiss();
      snackBar('تم التعديل بنجاح', context);

      clearFields();
      update();
    } catch (e) {
      EasyLoading.dismiss();
update();

   
    }

    }else{
      SnackbarNointernet();
    }
  }
  ////////////////////////////////////////////
  ///
  String? UidDoc;
  // String?UidUser="DWDI3ENEJDENDIE";
  bool hideName = false;


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
            snackBarErorr('لم يتم اختيار صوة', context);

    }
  }


  // Upload images to Firebase Storage and add their URLs to Firestore
  Future<void> uploadImagesToFirebase(context) async {
    if(connected==true){
    if (selectedImages.isEmpty) {
      snackBarErorr('لم يتم اختيار صوة', context);
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
      snackBar('تم الاضافة بنجاح', context);
     
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

  @override
  void onInit() {
    donationCostController=TextEditingController();
    donationDescriptionController=TextEditingController();
    donationTitleController=TextEditingController();
    donationTypeController=TextEditingController();
    recipientIdController=TextEditingController();
    super.onInit();
  }

 String? userName;
  Future<void> fetchUserName() async {
    if(connected==true){
    try {
      // Get the user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Replace 'users' with your collection name
          .doc('${recipientIdController.text}')
          .get();

      if (userDoc.exists) {

          userName = userDoc['name'];
          print(userName) ;// Assuming the field name is 'name
   update();
      } 
    } catch (e) {
     
    }
    }else{
      SnackbarNointernet();
    }
  }




void deleteDocument( String documentId,context) async {
  if ((connected==true)) {
    

    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  try {
    // Get a reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('donations');
    
    // Delete the document with the specific ID
    await collectionRef.doc(documentId).delete().then((value){
        Get.back();
        update();
      EasyLoading.dismiss();
      snackBar('تم الحذف بنجاح', context);
    });
    
  } catch (e) {
      EasyLoading.dismiss();

    print("Error deleting document: $e");
  }
}else{
      SnackbarNointernet();
    }
}
}






