import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/core/functions/sendEmail.dart';
import 'package:family_box/src/feature/Chat/ChatMangeConnet.dart';
import 'package:family_box/src/feature/Chat/HomeAllChats.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuActions.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuDonations.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuUsers.dart';
import 'package:family_box/src/feature/Dashbord/View/PageSettingsApp.dart';
import 'package:family_box/src/feature/Dashbord/View/RequsetUsers.dart';
import 'package:family_box/src/feature/Dashbord/View/widgetReports.dart';
import 'package:family_box/src/feature/Donations/Veiw/MenuNotfications.dart';
// import 'package:family_box/src/feature/Dashbord/View/PagePaymentsUsers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DashbordHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:  Center(child: Text('لوحة التحكم',style: TextStyle(color: AppColors().darkGreen),)),
          actions: [
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(padding: const EdgeInsets.all(15),
            child: Column(
              children: [
               
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors().darkGreen,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child:  Column(
                          children: [
                        
                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                      Icon(Icons.family_restroom,color: Colors.white,),
                                    Text(
                                      'العائلة',
                                      style: TextStyle(fontSize: 15,color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ],
                                ),
                            SizedBox(height: 8.0),
                            DocumentCountWidget(),
                              
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color:AppColors().lighBrown,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child:  Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.access_time,color: Colors.white,),
                                Text(
                                  // 'عدد المستخدمين الفعالين',
                                  'الفعالين',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            CountIsActive()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),




                 Row(
                  children: [
                   CardDadhbord(title: 'الاحداث والمناسبات',icon: Icon(Icons.attractions_outlined,size: 70,color:AppColors().lighBrown,),onTap: (){Get.to(MenuActions());},),
                    SizedBox(width: 16.0),
                  CardDadhbord(title: 'طلابات المستخدمين',icon: Stack(
                    children: [
                      Icon(Icons.recent_actors_rounded,size: 70,color:AppColors().lighBrown,),
                      CountUsersReq()
                    ],
                  ),onTap: (){Get.to(RequsetUsers());},),
                  ],
                ),

                  Row(
                  children: [
                   CardDadhbord(title: 'التبرعات',icon: Icon(Icons.payment_sharp,size: 70,color:AppColors().lighBrown,),onTap: (){Get.to(MenuDonations());},),

                    SizedBox(width: 16.0),
                  CardDadhbord(title: 'المستخدمين',icon:
                   Stack(
                     children: [
                       Icon(Icons.groups_2_outlined,size: 70,color:AppColors().lighBrown),
                       CountUsersNew()
                     ],
                   ),onTap: (){Get.to(PageUsers());},),
                  ],
                ),

                  Row(
                  children: [
                   CardDadhbord(title: 'الاشعارات',icon: Icon(Icons.notifications_active_outlined,size: 70,color:AppColors().lighBrown),onTap: (){Get.to(MenuNotfications());},),

                    SizedBox(width: 16.0),
                
                  CardDadhbord(title: 'الدردشات',icon: Icon(Icons.mark_chat_unread_outlined,size: 70,color:AppColors().lighBrown),onTap: (){Get.to(HomeAllChats());},),
                  ],
                ),
                  Row(
                    children: [
                      CardDadhbord(title: ' إدارة التواصل',icon:
                       Icon(Icons.mark_unread_chat_alt_sharp,size: 70,color:AppColors().lighBrown,),onTap: (){Get.to(ChatMangeConnet());},),
                    SizedBox(width: 16.0),
                    
                     CardDadhbord(title: 'إعدادات التطبيق',icon:
                       Icon(Icons.settings,size: 70,color:AppColors().lighBrown,),onTap: (){
                        Get.to(PageSettingsApp());
                            // sendOTP();
                            vreyfi();
                        },),
                    ],
                  ),
                
              ],
            ),
          ),
        ),
   
    );
  }
}






// ignore: must_be_immutable
class CardDadhbord extends StatelessWidget {
   CardDadhbord({super.key,this.title,this.icon,this.onTap});
String? title;
Widget? icon;
void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
                      child: GestureDetector(onTap: onTap,
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue[30],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child:  Column(mainAxisSize: MainAxisSize.max,
                              children: [
                                  icon!,
                                //  IconButton(onPressed: (){}, icon: icon!),
                              
                                 Text(
                                  title!,
                                  style: TextStyle(color: AppColors().darkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
  }
}