
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/core/functions/PermitionIos.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/connect.dart';
import 'package:family_box/src/feature/Chat/HomeAllChats.dart';
import 'package:family_box/src/feature/Dashbord/View/DashbordHome.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuDonations.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WdigetCardDonations.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddActions.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageDonations.dart';
import 'package:family_box/src/feature/EventsFamli/View/DisplayEvents.dart';
import 'package:family_box/src/feature/EventsFamli/View/MenuEventsFamily.dart';
import 'package:family_box/src/feature/FamilyTree/View/PageFamilyTree.dart';
import 'package:family_box/src/feature/Home/Widgets/StateApp.dart';
import 'package:family_box/src/feature/Home/Widgets/WidgetUserAddLetar.dart';
import 'package:family_box/src/feature/Home/Widgets/countNotficationsNoReaded.dart';
import 'package:family_box/src/feature/Notficaations/View/Notfications.dart';
import 'package:family_box/src/feature/Profile/View/MyProfile.dart';
import 'package:family_box/src/feature/ServiceApp/View/MyService.dart';
import 'package:family_box/src/widgets/widgetAlertDialogQu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

class _HomePageState extends State<HomePage>with WidgetsBindingObserver {
       FirebaseMessaging messaging = FirebaseMessaging.instance;
  final UsersControllersImp conuser=Get.put(UsersControllersImp());

    int selectedIndex = 0;
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
        if (type == 'حدث'||type == 'فعالية') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuEventsFamily(index: 1,)),
          );
        }else if(type=='تبرع'){
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonationsPage()));
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
    return ZoomDrawer(
      // Configure ZoomDrawer properties
      controller: zoomDrawerController,
      menuBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      shadowLayer1Color: AppColors().darkGreen,
      shadowLayer2Color: AppColors().lighBrown,
      borderRadius: 50.0,
      showShadow: true,
      mainScreen: _buildMainScreen(context),
      menuScreen: _menuScreen(context),
      drawerShadowsBackgroundColor: Color.fromARGB(255, 133, 134, 96),
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }
  Scaffold _buildMainScreen(BuildContext context) {
// ignore: unused_local_variable

    return Scaffold(
        backgroundColor: AppColors().white,
    
      appBar: AppBar(
        backgroundColor: AppColors().white,

        elevation: 0,
        title: Center(
          child: Text(
            ' اسرة اللحيدان',
            style: TextStyle(fontStyle: FontStyle.italic,
              color: Color(0xFF006400),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        leading: Row(
          children: [
            IconButton(onPressed: (){
                          zoomDrawerController.open?.call();
            
            }, icon: Icon(Icons.menu,color:Color(0xFF006400),),),

            
          ],
        ),
        
       
        actions:  [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(onPressed: (){
                  Get.to(Notfications());
                }, icon: Icon(
                  Icons.notifications,size: 30,
                  color: appColors.primary,
                ),),
                countNotficationsNoReaded()
              ],
            )
          ),
        ],
      ),
      drawerEnableOpenDragGesture: true,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10,bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Family options
              Container(margin: EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:  [
                      FamilyOption(icon: Icons.mark_unread_chat_alt_outlined, label: 'المحادثات',onTap: (){Get.to(HomeAllChats());},),
                      FamilyOption(icon: Icons.favorite, label: 'التبرعات',onTap: (){Get.to(DonationsPage());},),
                      FamilyOption(icon: Icons.calendar_today, label: 'الأحداث',onTap: (){Get.to(MenuEventsFamily(index: 0,));},),
                      FamilyOption(icon: Icons.people, label: 'شجرة العائلة',onTap: (){Get.to(pageFamilyTree());},),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Recently Added Members
              Container(margin: EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'المضافون مؤخراً لشجرة العائلة',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006400)
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: WidgetUserAddLetar(),
                
              ),
              //////////////////////////////
              const SizedBox(height: 0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text("ساهم ودعم اخيك",style: TextStyle(color: AppColors().darkGreen,fontSize: 17,fontWeight: FontWeight.bold),)),
              // Support Project
                 Container(
                  width: double.infinity,
                  height: 140,
                  child: WidgetCardDonations(IsAll: false, itemCount: 1, show: false, physics: ScrollPhysics(),)),
              const SizedBox(height: 0),
////////////////////////////////////////////////////////////////////////////////////////////////
              // Family News
               Container(margin: EdgeInsets.symmetric(horizontal: 20),
                 child: Text(
                  'أخبار العائلة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006400)
                  ),
                               ),
               ),
               SizedBox(height: 10),

               ////////////////////////////////////////
               Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: FamilyEvent()),
             
            ],
          ),
        ),
      ),

    );
  }
   Container _menuScreen(BuildContext context) {
 AuthController controllerImp=Get.put(AuthController());

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35),
        child: Column(textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                zoomDrawerController.toggle?.call();
              },
              icon:  Icon(
                Icons.close,
                color: AppColors().darkGreen,
              ),
            ),
           GetBuilder<UsersControllersImp>(builder: (con){
            
           return currentUserData.isNotEmpty? CircleAvatar(minRadius: 40,backgroundImage: NetworkImage(currentUserData[0]['image']),):
           CircleAvatar(minRadius: 40,backgroundColor: Colors.grey,);
             
           }),
            SizedBox(height: 10,),

            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: Icon(Icons.home, color: AppColors().darkGreen),
                title: Text('الرئيسية'),
                onTap: () {
                  _navigateToPage(0);
                },
              ),
            ),
                 
                 GetBuilder<UsersControllersImp>(builder: (con){
                  if(currentUserData.isNotEmpty){
                  return currentUserData[0]['isAdmin']==true?
                   Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Icon(Icons.margin_outlined, color: AppColors().darkGreen),
                      title: const Text('لوحة التحكم'),
                      onTap: () {
                       
                        Get.to(DashbordHome());
                      },
                    ),
                  ):SizedBox();
                  }else return Text('');
                 }),
                 
                  SizedBox(width: 1,),
             Material(
              color: Colors.transparent,
              child: ListTile(
                leading: Icon(Icons.design_services_sharp, color: AppColors().darkGreen),
                title: Text('الخدمات'),
                onTap: () {
                  Get.to(MyRequestService());
                },
              ),
            ),

            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: Icon(Icons.account_circle_outlined, color: AppColors().darkGreen),
                title: Text('ملفي الشخصي'),
                onTap: () {
                  // _navigateToPage(1);
                  Get.to(MyProfileScreen());
                 zoomDrawerController.toggle?.call();
                },
              ),
            ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: Icon(Icons.call, color: AppColors().darkGreen),
                title: Text("اتصل بنا"),
                onTap: () {
                   controllerImp.userName.text=currentUserData[0]['name'];
                        controllerImp.Phone.text=currentUserData[0]['phone'].toString().replaceAll(' ', '');
                  Get.to(ContactPage());
                  // controller.openSuioalMedia()
                                    // launchUrlString("mailto:Allahaidanfam@gmail.com");
                                    // launchUrlString("mailto:$LinkConnection");
                },
              ),
            ),
            // Material(
            //   color: Colors.transparent,
            //   child: ListTile(
            //     leading: Icon(Icons.info, color: AppColors().darkGreen),
            //     title: Text("عن التطبيق"),
            //     onTap: () async{
            //       // _navigateToPage(3);
            //       // Get.to(itemsSort());
            //     //  zoomDrawerController.toggle?.call();
            //     await FirebaseMessaging.instance  .subscribeToTopic('topics');
            //     await PushNotificationService.sendNotificationToTopic(['topics',], 'حدث', 'messageBody',currentUserId,'حدث','',context);
            //     },
            //   ),
            // ),
            //   Material(
            //   color: Colors.transparent,
            //   child: ListTile(
            //     leading: Icon(Icons.verified_user_sharp, color: AppColors().darkGreen),
            //     title: Text('سياسة الاستخدام'),
            //     onTap: () {
            //       // _navigateToPage(1);
            //       // Get.to(Myaccount());
            //      zoomDrawerController.toggle?.call();
            //     },
            //   ),
            // ),
            Material(
              color: Colors.transparent,
              child: ListTile(
                leading: Icon(Icons.logout, color: AppColors().darkGreen),
                title: Text("تسجيل الخروج"),
                onTap: () {
                  showDialog(context: context, builder: (context)=>widgetAlertDialogQu(onPressed: ()async{
                     stateApp(false);
                      await sharedPreferences.clear();
                  currentUserId=='';
                  conuser.fetchUser(context, true);
                 Navigator.of(context).pushNamedAndRemoveUntil('loginSgin', (route) => false);
                 zoomDrawerController.toggle?.call();
                  },title: 'هل تريد تسجيل الخروج فعلا', widget: Icon(Icons.question_mark_rounded,color: Colors.white,size:30 ,),));
                 
                },
              ),
            ),
            // Add your other drawer items here
          ],
        ),
      ),
    );
  }



  // Navigate to a specific page
  void _navigateToPage(int index) {
    setState(() {
      selectedIndex = index;
      zoomDrawerController.toggle?.call();
    });
  }









  
}








// ignore: must_be_immutable
class FamilyOption extends StatelessWidget {
  final IconData icon;
  final String label;
  void Function()? onTap;
  FamilyOption({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap:onTap ,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              color: AppColors().lighBrown,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF006400),
              fontSize: 14,fontWeight: FontWeight.bold
            ),textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}


class FamilyEvent extends StatelessWidget {
   FamilyEvent({super.key});

final controllerAddCations controllerAddAction = Get.put(controllerAddCations());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('actions').limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(child: ShimmerBox());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('لايوجد بيانات'));
              }

              final data1 = snapshot.data!.docs;
              return SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                  itemCount: data1.length,
                  itemBuilder: (context, index) {
                    var data = data1[index];
                    return NewsItem(
                      onTap: (){
                          controllerAddAction.UidDoc = data.id;
                            Get.to(() => DisplayEvents(uidDoc: data.id));
                      },
                      body: '${data['actionsType']} : ${data['day']}   ${data['nameMonth']}',
                imageUrl: '${data['imageUrl']??'null'}',
                title:'${data['title']}',);
                  },
                ),
              );
            },
          );
  }
}



// ignore: must_be_immutable
class NewsItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String body;
void Function()? onTap;
   NewsItem({
    Key? key,
   required this.onTap,
    required this.imageUrl,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.all(16),
        padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 5),

        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Row(textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // ignore: unnecessary_null_comparison
                  child:imageUrl=='null'?Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors().grayshade300
                    ),
                    height: 80,width: 80,):
                  Container(
                     width: 80,
                      height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors().grayshade300
                    ),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                ),
              ),
              SizedBox(width: 5),
              Expanded(flex: 6,
                child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text(
                      title,textDirection: TextDirection.rtl,
                      style: AppTextStyles.titleStyle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      body,textDirection: TextDirection.rtl,
                      style:  TextStyle(
                        fontSize: 16,fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}