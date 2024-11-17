import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
import 'package:family_box/src/feature/Home/Widgets/StateApp.dart';
import 'package:family_box/src/feature/Home/Widgets/countNotficationsNoReaded.dart';
import 'package:family_box/src/feature/Notficaations/View/Notfications.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerDerilesUser.dart';
import 'package:family_box/src/feature/Profile/View/ChatMangeHelpUser.dart';
import 'package:family_box/src/feature/Profile/View/MyProfile.dart';
import 'package:family_box/src/feature/Profile/verifTowStep/TwoStepVerificationEnabledScreen%20.dart';
import 'package:family_box/src/feature/Profile/verifTowStep/TwoStepVerificationScreen.dart';
import 'package:family_box/src/widgets/widgetAlertDialogQu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FristProfileScreen extends StatelessWidget {
  final UsersControllersImp conuser=Get.put(UsersControllersImp());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:    Padding(
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
        actions: [
          
        ],
        centerTitle: true,
        title: Text(
          'الملف الشخصي',
          style: AppTextStyles.titleStylePageSize
         
          
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          bool isTablet = screenWidth > 600; // Adjust layout for screens wider than 600px (tablet)

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetBuilder<UsersControllersImp>(builder: (con){
            
           return currentUserData.isNotEmpty? CircleAvatar(
            radius: isTablet ? 100 : 60,
                  backgroundColor: Colors.grey[200],
                  // child: Icon(
                  //   Icons.person,
                  //   size: isTablet ? 150 : 70,
                  //   color: Colors.grey,
                  // ),
            backgroundImage: NetworkImage(currentUserData[0]['image']),):
           CircleAvatar(
           radius: isTablet ? 100 : 60,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: isTablet ? 150 : 70,
                    color: Colors.grey,
                  ),
           );
             
           }),
               
                SizedBox(height: isTablet ? 20 : 10),
                 GetBuilder<UsersControllersImp>(builder: (con){
                  if(currentUserData.isNotEmpty){
                  return
                  Text(
                 currentUserData.isNotEmpty ?currentUserData[0]['name']:'',
                  style: AppTextStyles.titleStylePageSize.copyWith(fontSize: 16)
                );
                  }else return Text('');
                 }),
                
               Align(alignment: Alignment.bottomRight,
                 child: Column(
                  children: [
                   SizedBox(height: isTablet ? 40 : 30),
                  OptionButton(
                    icon: Icons.info_outline,
                    label: 'معلوماتي',
                    isTablet: isTablet,onPressed: ()=>Get.to(MyProfileScreen()),
                  ),
                  Stack(
                    children: [
                      OptionButton(
                        icon: Icons.chat,
                        label: 'مراسلة إدارة الصندوق' ,
                        isTablet: isTablet,onPressed:(){
                           if(currentUserData.isNotEmpty){
                            print("${currentUserData[0]['phone']}");
                                Get.to(ChatMangeHelpUser(chatId: currentUserData.isNotEmpty ?currentUserId:'', userId: currentUserId));
                          }else{
                            snackBar('يرجي الانتظار يتم تحميل بياناتك', context);
                          }}),
                          // CounUnReadMessConnUser(chatId: currentUserData[0]['phone'],frindId: currentUserId,)
                    ],
                  ),
                  
                     OptionButton(
                    icon: Icons.checklist_rounded,
                    label: 'التحقق بخطوتين',
                    isTablet: isTablet,onPressed:(){
                      if(currentUserData.isNotEmpty){
                      String PassVerifiTowStaps=currentUserData[0]['PassVerifiTowStaps']??'';
                     PassVerifiTowStaps!=''?Get.to(TwoStepVerificationEnabledScreen()): Get.to(TwoStepVerificationScreen());
                      }else{
                       snackBar('يرجي الانتظار يتم تحميل بياناتك', context);

                      }
                    }
                      ),
                  
                  OptionButton(
                    icon: Icons.logout,
                    label: 'تسجيل الخروج',
                    isTablet: isTablet,onPressed: (){
                      showDialog(context: context, builder: (context)=>widgetAlertDialogQu(onPressed: ()async{
                     stateApp(false);
                     await FirebaseAuth.instance.signOut();
                      await sharedPreferences.clear();
                  currentUserId=='';
                  // ignore: unnecessary_null_comparison
                  currentUserId==null;
                  IsEnable=false;
                  conuser.fetchUser(context, true);
                 Navigator.of(context).pushNamedAndRemoveUntil('loginSgin', (route) => false);
                  },title: 'هل تريد تسجيل الخروج فعلا', widget: Icon(Icons.question_mark_rounded,color: Colors.white,size:30 ,),));
                 
                    },
                  ),
                 ],),
               )
              ],
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isTablet;
  void Function() onPressed;

  OptionButton({required this.icon, required this.onPressed,required this.label, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: MaterialButton(
        color: Colors.white,height: 60,
        onPressed: onPressed,
      
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: AppTextStyles.titleStyle,
            ),
            SizedBox(width: 30,),
            Icon(icon, color: appColors.primary, size: isTablet ? 30 : 24),
          ],
        ),
      ),
    );
  }
}

