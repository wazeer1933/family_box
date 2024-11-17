import 'dart:io';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class controllerAddCations extends GetxController {
  // TextEditingControllers for text fields
  final TextEditingController actionTypeController = TextEditingController();
  final TextEditingController actionDescriptionController = TextEditingController();
   String? date;
  // final TextEditingController actionCostController = TextEditingController();
  final TextEditingController actionTitleController = TextEditingController();

  final TextEditingController address = TextEditingController();
  final TextEditingController uIdUserReqController = TextEditingController();
  // Image variables
  Rx<File?> selectedImage = Rx<File?>(null);
String? latitude;
String? longitude;


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
      String fileName = 'actions/${DateTime.now().millisecondsSinceEpoch}.jpg';
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

  void FormattedDate(DateTime date1) {
    // Format to get month name
    String formattedMonth = DateFormat('MMMM').format(date1);
    // ignore: unused_local_variable
    String pmoram=DateFormat('a').format(date1);
    formattedMonth=='January'?nameMonth='ياناير':formattedMonth=='February'?nameMonth='فبراير':
    formattedMonth=='March'?nameMonth='مارس':formattedMonth=='April'?nameMonth='ابريل':
    formattedMonth=='May'?nameMonth='مايو':formattedMonth=="June"?nameMonth='يونيو':
    formattedMonth=='July'?nameMonth='يليو':formattedMonth=='August'?nameMonth='اغسطس':
    formattedMonth=='September'?nameMonth='سبتمبر':formattedMonth=='October'?nameMonth='اكتوبر':
    formattedMonth=='November'?nameMonth='نوفمبر':nameMonth='ديسمبر';
    date='${date1.year}-${date1.month}-${date1.day}  ${date1.hour}:${date1.minute} ${pmoram=='AM'?'صباحا':'مساء'}';
   Time='${date1.day}  ${date1.hour}:${date1.minute} ${pmoram=='AM'?'صباحا':'مساء'}';
   Year='${date1.year}';
    // nameMonth=formattedMonth;
    print(nameMonth);
  }
  String? Time;
  String?nameMonth;
  String?Year;
  String?EditeImageUrl;
  // Function to add donation data to Firestore
  Future<void> addActions(context) async {
    if(connected==true){
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    if (selectedImage.value == null) {
      EasyLoading.dismiss();
     Get.snackbar('خطاء','',messageText:Center(child: Text('يرجي اختيار صورة ')) ,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    String? imageUrl = await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
      Get.snackbar('Error', 'Image upload failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('actions').add({
        'actionsType': actionTypeController.text,
        'actionsDescription': actionDescriptionController.text,
        'Year': Year,
        'day':Time,
        'nameMonth':nameMonth,
        'actionsUserId': uIdUserReqController.text,
        'imageUrl': imageUrl,
        'title':actionTitleController.text,
        'uidUserCreated':UidUser,
        'latitude':latitude,
        'longitude':longitude,
        'address':address.text
      }).then((value){
           EasyLoading.dismiss();
           Get.back();
           snackBar('تم الاضافة بنجاح', context);
   
      clearFields();
      update();
      });
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












  String? uidUserCreated;
  ////////////////////////////////////////////
    Future<void> EditeActions(context) async {
      if(connected==true){
     await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);

   String? imageUrl;
    if(selectedImage.value!=null){
    imageUrl= await uploadImage(selectedImage.value!);
    if (imageUrl == null) {
      Get.snackbar('Error', 'لم يتم تحميل الصورة يرجي المحاولة مرة اخرئ',
          snackPosition: SnackPosition.BOTTOM);
    
    }}

    try {

      await FirebaseFirestore.instance.collection('actions').doc(UidDoc).update({
        'actionsType': actionTypeController.text,
        'actionsDescription': actionDescriptionController.text,
        'Year': Year,
        'day':Time,
        'nameMonth':nameMonth,
        'actionsUserId': uIdUserReqController.text,
        'imageUrl':selectedImage.value!=null?imageUrl: EditeImageUrl,
        'title':actionTitleController.text,
        'uidUserCreated':uidUserCreated,
        'latitude':latitude,
        'longitude':longitude,
        'address':address.text
      }).then((value){
           EasyLoading.dismiss();
           Get.back();
           snackBar('تم التعديل بنجاح', context);
      // Get.snackbar('', 'تم التعديل بنجاح',titleText: Text("تم"),backgroundColor: AppColors().blueshade600,
      //     snackPosition: SnackPosition.BOTTOM);
      clearFields();
      update();
      });
           print("object");

   
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
  ///////////////////////////////////////////////////
  String? UidDoc;
  String?UidUser="DWDI3ENEJDENDIE";
  bool Sharing = false;
 Future<void> addActionSharingUsers() async {
  if(connected==true){
    try {
       await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
      await  FirebaseFirestore.instance
          .collection('actions')
          .doc('$UidDoc')
          .collection('sharingUsers').doc().set
          ({
        // 'nameUser': nameUser,
        'userId': UidUser,
        // 'urlimage': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'Sharing':false
         // Optional field for tracking
      });
  EasyLoading.dismiss();
      Get.snackbar('', 'تم ارسال الطلب بنجاح',titleText: Text("شكرا لك"),backgroundColor: AppColors().blueshade600,
          snackPosition: SnackPosition.BOTTOM);
          getCount(UidDoc);
      Get.back();
      Get.back();
      update();
    } catch (e) {
      EasyLoading.dismiss();

      Get.snackbar('خطاء', ' خطاء $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }else{
    SnackbarNointernet();
  }
  }

String? sharingUserDoc;
String? sharingUserUid;
 EditeActionSharingUsers(acsebt) async {
  if(connected==true){
    try {
       await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
      await  FirebaseFirestore.instance
          .collection('actions')
          .doc('$UidDoc')
          .collection('sharingUsers').doc(sharingUserDoc).update
          ({
        'userId': sharingUserUid,
        'createdAt': FieldValue.serverTimestamp(),
        'Sharing':acsebt
      }).then((value) {
EasyLoading.dismiss();
      Get.snackbar('', 'تم تعديل الطلب بنجاح',titleText: Text("شكرا لك"),backgroundColor: AppColors().blueshade600,
          snackPosition: SnackPosition.BOTTOM);
          getCount(UidDoc);
      Get.back();
      update();
      });
  
    } catch (e) {
      EasyLoading.dismiss();

      Get.snackbar('خطاء', ' خطاء $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }else{
    SnackbarNointernet();
  }
  }





  // Function to clear input fields
  void clearFields() {
    longitude='';
    latitude='';
    actionDescriptionController.clear();
    actionTitleController.clear();
    // date="";
    actionTypeController.clear();
    uIdUserReqController.clear();
    selectedImage.value = null;
  }
  /////////////////////////////////////////add images//////////////////////////
  

  var selectedImages = <File>[].obs;
  final picker = ImagePicker();

  // Pick multiple images
  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultipleMedia();
    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      selectedImages.value = pickedFiles.map((e) => File(e.path)).toList();
    } else {
      Get.snackbar('Error', 'No images selected');
    }
  }

  // Upload images to Firebase Storage and add their URLs to Firestore
  Future<void> uploadImagesToFirebase() async {
    if(connected==true){
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'No images to upload');
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
            .child('actions/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the download URL in Firestore
        await FirebaseFirestore.instance
            .collection('actions')
            .doc(UidDoc) // Document can be a specific ID if needed
            .collection('images')
            .add({'imageUrl': downloadUrl});
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

  // ignore: unused_field
  Position? currentPosition;

getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
   
           address.text  ="${place.street}";
           latitude="${position.altitude}";
           longitude="${position.longitude}";

      }
      print("===========================$address");
      currentPosition=position;

    update();

    } catch (e) {
      print('Error getting location: $e');
    }
  }




 Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      // Use the Geocoding API here to get the address (requires another package, e.g., geocoding)
      // Example:
       List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
   
         address.text ="${place.street}";
         print(address);
         update();
      }
    } catch (e) {
      print(e);
    }
  }
///////////////////////////////
   int? count=0;
  bool IsFounduser=false;
  bool SharinIsAcsept=false;
  /////////////////////////////////////////////

 checkExists() async {
  print('================UidDoc===========$UidDoc');
  print('================UidUser===========$UidUser');
  CollectionReference checkExist = FirebaseFirestore.instance.collection('actions');
  QuerySnapshot querySnapshot = await checkExist.doc(UidDoc).collection('sharingUsers').where('userId', isEqualTo: UidUser).get();
  if(querySnapshot.docs.isNotEmpty){
    IsFounduser=true;
   print('=================IsFounduser===$IsFounduser');

  }else{
    IsFounduser=false;
   print('=================IsFounduser===$IsFounduser');

  }
  update();
}
///////////////////////////////////////////////
void checkSharingStatus(String uid) async {
  // Reference to your Firestore collection
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('actions');

  // Query the collection where uid equals the specified value and Sharing is true
  QuerySnapshot querySnapshot = await collectionRef.doc(UidDoc).collection('sharingUsers')
      .where('userId', isEqualTo: uid)
      .where('Sharing', isEqualTo: true)
      .get();

  // Check if any documents match the query
  if (querySnapshot.docs.isNotEmpty) {
    SharinIsAcsept=true;
    print('true');
  } else {
    SharinIsAcsept=false;
    print('false');
  }
  update();
}

  /////////////////////////////////////////////
Future<int> countDocuments(UidDoc) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('actions').doc(UidDoc).collection('sharingUsers')
      .get();
    
  int documentCount;
  querySnapshot.size>5?documentCount=querySnapshot.size:documentCount=0;
   // Number of documents in the collection
  return documentCount;
}
   void getCount(UidDoc) async {
    checkSharingStatus(UidUser!);
   checkExists();
   count = await countDocuments(UidDoc);
  print('Number of donations: $count');
  update();
  // Get.back();
}

getLocation()async{
  await getCurrentLocation();
}
@override
  void onInit() async{
    getLocation();
    getCount(UidDoc);
    super.onInit();
  }
  // @override
  // void onClose() {
  //   clearFields();
  //   super.onClose();
  // }

populateFromData(data){
 
}




void deleteDocument( String documentId,context) async {
  if(connected==true){
    await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  try {
    // Get a reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('actions');
    
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






