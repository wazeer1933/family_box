import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/widgetdropDwon2.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/models/value_item.dart';

class UserController extends GetxController {
  var userList = <ValueItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    print("=======================");
    print(userList);
  }

  void fetchUsers() async {
    try {
      isLoading(true);
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('name',isNotEqualTo: 'اللحيدان').get();

      // Map data to ValueItem list
      var users = querySnapshot.docs.map((doc) {
        String name = doc['name'];
        String uid = doc['uid'];
        String image = doc['image'];
        String tree = doc['tree'];
        // You can include other fields such as 'numberuser' or 'image_url' if needed
        return ValueItem(label: name+tree, value:User(image: image, uid: uid, tree: tree));
        // return ValueItem(label: name, value:uid);

      }).toList();
      userList.assignAll(users);
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
       print("=======================");
    print(userList);
    update();
    }
    update();

  }
  
}




