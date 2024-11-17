import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class contollerCountLikeCountCoust extends GetxController {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables to hold counts
  RxInt totalPaymentsCost = 0.obs;
  RxInt likesCount = 0.obs;

  // Method to fetch the total cost of payments
  Future<void> fetchTotalPaymentsCost(String donationId) async {
    try {
      QuerySnapshot paymentsSnapshot = await _firestore
          .collection('donations')
          .doc(donationId)
          .collection('Payments')
          .get();

      int totalCost = paymentsSnapshot.docs.fold(
        0,
        (previousValue, doc) => previousValue + (int.parse(doc['cost'])),
        
      );

      totalPaymentsCost.value = totalCost;
      update();
    } catch (e) {
      print('Error fetching payments cost: $e');
    }
      update();

  }
///////////////////////////////
Future<int> countDocuments(UidDoc) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('donations').doc(UidDoc).collection('Payments')
      .get();
    
  int documentCount;
  querySnapshot.size>5?documentCount=querySnapshot.size:documentCount=0;
   // Number of documents in the collection
  return documentCount;
}
    int? count=0;
   void getCount(UidDoc) async {
   count = await countDocuments(UidDoc);
  print('Number of donations: $count');
  update();
  // Get.back();
}







  // Method to fetch the count of likes
  Future<void> fetchLikesCount(String donationId) async {
    try {
      QuerySnapshot likesSnapshot = await _firestore
          .collection('donations')
          .doc(donationId)
          .collection('likes')
          .get();

      likesCount.value = likesSnapshot.size;
      update();

    } catch (e) {
      print('Error fetching likes count: $e');
    }
  }

}