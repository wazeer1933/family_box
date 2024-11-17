import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:get/get.dart';

class TabControllerhomage extends GetxController {
  var selectedIndex = 3.obs;
 AuthController controllerImp=Get.put(AuthController());

  void changeTabIndex(int index) {
    if(index==1){
        controllerImp.userName.text=currentUserData[0]['name'];
                        controllerImp.Phone.text=currentUserData[0]['phone'].toString().replaceAll(' ', '');
                  
    }
    selectedIndex.value = index;

  }
}
