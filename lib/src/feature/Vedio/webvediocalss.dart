// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<void> createRoom(String roomId) async {
//   final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
//   await roomRef.set({
//     'users': [],
//     'offer': null,
//     'answer': null,
//     'iceCandidates': [],
//   });
// }

// Stream<List<String>> getActiveUsers(String roomId) {
//   final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
//   return roomRef.snapshots().map((snapshot) {
//     final data = snapshot.data();
//     return data?['users']?.cast<String>() ?? [];
//   });
// }
