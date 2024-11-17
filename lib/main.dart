

import 'package:family_box/firebase_options.dart';
import 'package:family_box/src/Features/HomePages/HomagePage.dart';
import 'package:family_box/src/core/functions/Internet.dart';
import 'package:family_box/src/feature/Authentecation/Screens/login/login.dart';
import 'package:family_box/src/feature/Authentecation/Screens/register/register.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/PageLoginAndSeginIN.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
import 'package:family_box/src/feature/Home/View/HomePage.dart';
import 'package:family_box/src/feature/SplashSecreen.dart';
// import 'package:family_box/src/feature/SplashSecreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:device_preview/device_preview.dart';
  final FirebaseAuth auth = FirebaseAuth.instance;
   String currentUserId='';
  // ='DWDI3ENEJDENDIE';//me
  late final SharedPreferences  sharedPreferences;
  bool IsEnable=false;
 late bool connected=true;

  // final String currentUserId='EDEDEDNEJKBJR48';//me
    List<Map<String, dynamic>> currentUserData=[];
void main(context)async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await FirebaseAppCheck.instance.activate(

  );
  final UsersControllersImp conuser=Get.put(UsersControllersImp());

//  await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).update({
//     'isEnable':true,
//   });
 sharedPreferences = await SharedPreferences.getInstance();
// currentUserId='${sharedPreferences.getString('uid')}';
// ignore: unnecessary_null_comparison
IsEnable=sharedPreferences.getBool('IsEnable') ?? false;
// print('==============IsEnable============${sharedPreferences.getBool('IsEnable')}');
// print('===================uid==========${sharedPreferences.getString('uid')}');
   // ignore: unnecessary_null_comparison
   currentUserId=auth.currentUser?.uid??'';
   // ignore: unnecessary_null_comparison
   if(currentUserId!=null)conuser.fetchUser(context,true);
print("================currentUserId===========${auth.currentUser?.uid}");
print("================currentUserId===========${currentUserId}");

print("===============IsEnableIsEnable============$IsEnable");

  runApp(
  //     DevicePreview(
  //   enabled: true,
  //   builder: (context) => MyApp(), // Wrap your app
  // ),
    MyApp()
    );
  easyLoding();
     bool stateInternet=connected;
   // ignore: unused_local_variable
     final internetStream = InternetChecker.internetConnectionStream();
  internetStream.listen((isConnected) {
    connected=isConnected;
    if(stateInternet!=connected){
      if(isConnected==false){
        SnackbarNointernet();
      stateInternet=isConnected;
      
      }else{
        SnackbarFounfinternet();
      stateInternet=isConnected;
    
      }

      
      stateInternet=isConnected;
    }
    // print('Internet connected: $isConnected');
    // Get.snackbar('title', '$isConnected');
  });
}

class MyApp extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
   // ignore: unnecessary_null_comparison

    return GetMaterialApp(
    
    useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      builder:  (context, widget) {
    // widget = DevicePreview.appBuilder(context, widget);
    return EasyLoading.init()(context, widget);
  },
      debugShowCheckedModeBanner: false,
        routes: {
              'home':(context)=>const HomePage(),
              'homePageApp':(context)=> HomePageApp(),
              'login':(context)=> LoginScreen(),
              'loginSgin':(context)=> PageLoginAndSeginin(),
              'Register':(context)=>RegisterScreen(),
              // 'NoLogin':(context)=>const ONLogIn()
              },
      // ignore: unnecessary_null_comparison
     home:auth.currentUser!=null&&IsEnable==true?splash():PageLoginAndSeginin(),

    // home: splash(),
      theme: ThemeData(
        primaryColor: Color(0xFF006400)
      ),
    );
    
  }
}


easyLoding(){
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue
    ..userInteractions = false
    ..dismissOnTap = true;
}





SnackbarNointernet(){
         if(Get.isSnackbarOpen){Get.back();}
        Get.snackbar('', '',icon: Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,color: Colors.white,),messageText: const Directionality(textDirection: TextDirection.rtl, child: Text("غير متصل بالانترنت",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold))),titleText: const Directionality(textDirection: TextDirection.rtl, child: Text('خطاء',style: TextStyle(color: Colors.white),)),borderRadius: 10,margin: const EdgeInsets.all(10),backgroundColor: Colors.red,snackPosition:SnackPosition.BOTTOM,duration: const Duration(seconds: 3));
}
SnackbarFounfinternet(){
         if(Get.isSnackbarOpen){Get.back();}
        Get.snackbar('', '',icon: Icon(Icons.wifi_rounded,color: Colors.white,),messageText: const Directionality(textDirection: TextDirection.rtl, child: Text(" تم استعادة الاتصال بالانترنت",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)),titleText: const Directionality(textDirection: TextDirection.rtl, child: Text('متصل',style: TextStyle(color:Colors.white),)),borderRadius: 10,margin: const EdgeInsets.all(10),backgroundColor: Colors.green,snackPosition:SnackPosition.BOTTOM,duration: const Duration(seconds: 3));
}

  














