import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';

stateApp(state)async{
 await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
        'isActive':state
       });
}
