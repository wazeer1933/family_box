import 'package:family_box/src/Features/HomePages/contollers/contollerhomagepage.dart';
import 'package:family_box/src/Features/HomePages/widgets/BodyHomePage.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/core/functions/PermitionIos.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/connect.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuUsers.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageDonations.dart';
import 'package:family_box/src/feature/EventsFamli/View/MenuEventsFamily.dart';
import 'package:family_box/src/feature/FamilyTree/View/PageFamilyTree.dart';
import 'package:family_box/src/feature/Home/Widgets/StateApp.dart';
import 'package:family_box/src/feature/Profile/View/FirstProfileSecreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePageApp extends StatefulWidget {
  const HomePageApp({super.key});

  @override
  State<HomePageApp> createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePageApp>with WidgetsBindingObserver {

  final TabControllerhomage tabController = Get.put(TabControllerhomage());

  final List<Widget> pages = [
    // MyProfileScreen(),
    FristProfileScreen(),
    ContactPage(),//
    pageFamilyTree(),
    BodyHomePage(),

  ];
       FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
    void initState() {
      
      stateApp(true);
      super.initState();
       PermmetionIos();
    // Request permission (only necessary on iOS)
    messaging.requestPermission();
      // Listen to messages while app is in the foreground
       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('${message.notification?.title}');

      if (message.notification != null) {
        String? title = message.notification!.title;
        final type = message.data['type'];
        print('${title}');
        // print('${type['type']}');

        // Check if the title is 'hh' and navigate to PageHome
        if (type == 'حدث') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuEventsFamily(index: 0,)),
          );
        }else if(type=='تبرع'){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonationsPage()));
        }else if(type=='حساب'){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageUsers()));
        }
        else if(type=='مناسبة'){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuEventsFamily(index: 1,)));
        }
      }
      
    });
     WidgetsBinding.instance.addObserver(this);
    }
  


  @override
  void dispose() {
  // ignore: unused_local_variable
    WidgetsBinding.instance.removeObserver(this);
    stateApp(false);
    super.dispose();
  }

/////////////////////////////////////////////////////////////
 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('App State: Open');
        stateApp(true);
        break;
      case AppLifecycleState.paused:
        print('App State: Background');
        stateApp(false);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        print('App State: Closed');
        stateApp(false);

        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }
/////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
     
      body: Obx(() => pages[tabController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: appColors.white
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
              child: BottomNavigationBar(
                
                backgroundColor: appColors.white,
                type: BottomNavigationBarType.fixed,
                currentIndex: tabController.selectedIndex.value,
                onTap: tabController.changeTabIndex,
                selectedLabelStyle:  AppTextStyles.titleStyle.copyWith(color: appColors.lighBrown),
                unselectedLabelStyle: AppTextStyles.titleStyle.copyWith(color: Colors.grey),
                selectedItemColor: appColors.primary, // Set selected label and icon color to red
                unselectedItemColor: appColors.lighBrown, // Set unselected label and icon color to grey
                items: const [
                  BottomNavigationBarItem(
                    
                    icon: Icon(Icons.account_circle_outlined),
                    label: "ملفي",
                  ),
                  BottomNavigationBarItem(
                    
                    icon: Icon(Icons.call_outlined),
                    label: "اتصل بناء",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.family_restroom),
                    label: "الشجرة العائلية",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: " الرئيسية",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
