import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/PhotoAlbumsScreen.dart';
import 'package:family_box/src/feature/Chat/HomeAllChats.dart';
import 'package:family_box/src/feature/Dashbord/View/DashbordHome.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WdigetCardDonations.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageDonations.dart';
import 'package:family_box/src/feature/EventsFamli/View/MenuEventsFamily.dart';
import 'package:family_box/src/feature/FamilyTree/View/PageAddMyFamliyInTree.dart';
import 'package:family_box/src/feature/Home/View/HomePage.dart';
import 'package:family_box/src/feature/Home/Widgets/WidgetUserAddLetar.dart';
import 'package:family_box/src/feature/Home/Widgets/countNotficationsNoReaded.dart';
import 'package:family_box/src/feature/Notficaations/View/Notfications.dart';
import 'package:family_box/src/feature/ServiceApp/View/MyService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyHomePage extends StatefulWidget {
  const BodyHomePage({super.key});

  @override
  State<BodyHomePage> createState() => _BodyHomePageState();
}

class _BodyHomePageState extends State<BodyHomePage> {
  Axis _scrollDirection = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery for responsive screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        backgroundColor: appColors.background,
        title: Text('عائلة اللحيدان', style: AppTextStyles.titleStylePageSize),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () => Get.to(Notfications()),
                  icon: Icon(
                    Icons.notifications,
                    size: isTablet ? 40 : 30, // Responsive icon size
                    color: appColors.primary,
                  ),
                ),
                countNotficationsNoReaded()
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: isTablet ? 10 : 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeaderButtons(),
            SizedBox(height: isTablet ? 24 : 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 30 : 15),
              child: Column(
                children: [
                  // _buildMainCards(isTablet: isTablet),
                  // SizedBox(height: isTablet ? 24 : 16),
                  _AddTreeLate(),
                  //////////////////////////////
              const SizedBox(height: 0),
              Align(alignment: Alignment.centerRight,
                // margin: EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Text("ساهم ودعم اخيك",style: TextStyle(color: AppColors().darkGreen,fontSize: 17,fontWeight: FontWeight.bold),))),
              // Support Project
                 Container(
                  width: double.infinity,
                  height: 140,
                  child: WidgetCardDonations(IsAll: false, itemCount: 1, show: false, physics: ScrollPhysics(),)),
              const SizedBox(height: 0),
////////////////////////////////////////////////////////////////////////////////////////////////
                  SizedBox(height: isTablet ? 24 : 0),
                  _buildNewsSection(),
                  SizedBox(height: isTablet ? 24 : 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return SingleChildScrollView(
      scrollDirection: _scrollDirection,
      child: Wrap(alignment: WrapAlignment .center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _scrollDirection = _scrollDirection == Axis.vertical ? Axis.horizontal : Axis.vertical;
              });
              print(_scrollDirection);
            },
            child: _iconButton(
              _scrollDirection == Axis.vertical ? 'افقي' : 'عمودي',
              _scrollDirection == Axis.vertical ? Icons.vertical_distribute : Icons.horizontal_split,
            ),
          ),
          GetBuilder<UsersControllersImp>(builder: (con) {
            if (currentUserData.isNotEmpty) {
              return currentUserData[0]['isAdmin'] == true
                  ? GestureDetector(
                      onTap: () => Get.to(DashbordHome()),
                      child: _iconButton('لوحة التحكم', Icons.dashboard),
                    )
                  : SizedBox();
            } else {
              return SizedBox();
            }
          }),
          GestureDetector(onTap: () => Get.to(PhotoAlbumsScreen()), child: _iconButton('الصور', Icons.image_sharp)),
          GestureDetector(onTap: () => Get.to(HomeAllChats()), child: _iconButton('المحادثات', Icons.chat_outlined)),
          GestureDetector(onTap: () => Get.to(MenuEventsFamily(index: 1,)), child: _iconButton('الاحداث', Icons.pie_chart)),
          GestureDetector(onTap: () => Get.to(MenuEventsFamily(index: 0,)), child: _iconButton('المناسبات', Icons.date_range)),
          GestureDetector(onTap: () => Get.to(DonationsPage()), child: _iconButton('الدعم العائلي', Icons.volunteer_activism)),
          GestureDetector(onTap: () => Get.to(MyRequestService()), child: _iconButton('خدماتي', Icons.security_update_good_rounded)),
          // GestureDetector(onTap: () => Get.to(MyRequestService()), child: _iconButton('رسائل الصندوق', Icons.chat_bubble_outline)),
         
        ],
      ),
    );
  }

  Widget _AddTreeLate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: const Text(
            'المضافون مؤخراً لشجرة العائلة',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF006400)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: WidgetUserAddLetar(),
        ),
      ],
    );
  }

  Widget _iconButton(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Container(
        width: 80,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 30,backgroundColor: Colors.grey.shade100,
              child: Icon(icon, color: appColors.primary, size: 30)),
            SizedBox(height: 4),
            Text(text, style: AppTextStyles.subtitleStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCards({required bool isTablet}) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.to(DonationsPage()),
            child: _mainCard(
              title: 'صدقة وصلة',
              color: appColors.lighBrown,
              icon: Icons.volunteer_activism,
              isTablet: isTablet,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: GestureDetector(onTap: (){
            if(currentUserData.isNotEmpty&&currentUserData[0]['tree']!=''){
            Get.to(PageAddMyFamliyInTree(tree: currentUserData[0]['tree']));}
            else{
              snackBarErorr('يرجي الطلب من الادرة اضافتك الئ الشجرة', context);
            }
          },
            child: _mainCard(
              title: 'إضافة تابعين',
              color: appColors.primary,
              icon: Icons.group_add,
              isTablet: isTablet,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mainCard({required String title, required Color color, required IconData icon, required bool isTablet}) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: isTablet ? 48 : 36, color: Colors.white),
          SizedBox(height: isTablet ? 12 : 8),
          Text(title, style: AppTextStyles.titleStyle.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('أخبار العائلة', style: AppTextStyles.titleStylePageSize),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: FamilyEvent(),
        ),
      ],
    );
  }
}
