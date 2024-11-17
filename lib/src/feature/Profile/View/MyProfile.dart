// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/ChatSecreenUser.dart';
import 'package:family_box/src/feature/Chat/contollers/controllerSendChats.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuDonations.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerDerilesUser.dart';
import 'package:family_box/src/feature/Profile/View/EditeMyProfile.dart';
import 'package:family_box/src/feature/Profile/Widgets/WidgetDialogNewOtherInfo.dart';
import 'package:family_box/src/widgets/widgetAlertDialogQu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {


  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUserId)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return  Center(child: ShimmerBox());
              }

              // Check if snapshot has data and it exists
              if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                return  Center(child: Text("User data not available."));
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>?;

              // Further null check for userData
              if (userData == null) {
                return const Center(child: Text("User data not found."));
              }

              return Column(
                children: <Widget>[
                  ProfileHeader(
                   widget: 
                   Text(userData['IsAcsept']==true?'حساب موثق':'حساب غير موثق',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,fontStyle: FontStyle.italic,color: userData['IsAcsept']==true?AppColors().darkGreen:AppColors().gray),),
                    imageUrl: userData['image'] ?? '',
                    name: userData['name'] ?? 'No Name',
                  ),
                  ProfileInfo(onPressed: () {
                    controller.userNameController.text=userData['name'];
                    controller.EmailController.text=userData['email'];
                    controller.PhoneController.text=userData['phone'];
                    controller.PasswordController.text=userData['password'];
                    controller.dateBirthController.text=userData['dateBithe'];
                    // controller.AddressController.text=userData['add'];
                    controller.MardingController.text=userData['maride'];
                    controller.gender=userData['gender'];
                    controller.imageUrlold=userData['image'];
                    // controller.uidDoc=userData.id;'
                    controller.imageUrlIdentity=userData['imageUrlIdentity'];
                    print(controller.imageUrlold);
                    Get.to(EditMyProfile());
                  },
                    gender: userData['gender'],
                    tree: userData['tree']??'لم يتم التعين في الشجرة' ,
                    // iconWidget: userData['gender'] == 'Male'
                    //     ? const CircleAvatar(child: Icon(Icons.male))
                    //     : const CircleAvatar(child: Icon(Icons.female)),
                    name: userData['name'] ?? ' الاسم غير متوفر',
                    email: userData['email'] ?? ' الايمل غير متوفر',
                    phone: userData['phone'] ?? 'رقم الهاتف غير متوفر',
                    dateOfBirth: userData['dateBithe'] ?? 'لايوجد تارخ ميلاد',
                    maritalStatus: userData['maride'] ?? 'الحالة الاجتماعية غير متوفرة',
                    Spcail: userData['spical'] ?? 'الوظيفة غير متوفر',

                  ),
                  SizedBox(height: 5,),
                  InfoOther(UserUid: currentUserId, from: true,)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
final Widget? widget;
   ProfileHeader({Key? key, this.widget,required this.imageUrl, required this.name}) : super(key: key);
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(),
              Row(
                children: [
                    Text(
                "حسابي",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors().lighBrown),
              ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios,),
                  ),
                ],
              ),
                 widget!,
             
            ],
          ),
          Card(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: ()=> Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImagePage(imageUrl: imageUrl),
                    ),
                  ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                           backgroundColor: Colors.grey[200],
                  // child: Icon(
                  //   Icons.person,
                  //   size:  70,
                  //   color: Colors.grey,
                  // ),
                          radius: 70,
                        ),
                      ),
                      // Positioned(
                      //   bottom: 0,right: 0,
                      //   child: CircleAvatar(backgroundColor: Colors.grey.shade300,child: IconButton(onPressed: (){}, icon: Icon(Icons.edit_sharp,size: 30,color: AppColors().darkGreen,))))
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style:  TextStyle(fontSize: 17, color: AppColors().darkGreen,fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder<DocumentSnapshot>(
        // Get the document by its ID in the 'users' collection
        stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('SuioalMedia').doc(currentUserId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('لايوجد حسابات التواصل الاجتماعي'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          controller.whattsappController.text=userData['whattsapp'].toString();
          controller.facebookController.text=userData['facebook'].toString();
          controller.instagramController.text=userData['instagram'].toString();
          controller.xController.text=userData['x'].toString();
          
          return ExpansionTile(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
            title: Text("حسابات التواصل الاجتماعمي",textDirection: TextDirection.rtl,),
            children:[SMedia(whatsapp: userData['whattsapp'],ins:userData['instagram'] ,x: userData['x'],face: userData['facebook'],
              onTapfacebok: (){
                controller.openSuioalMedia(urls: userData['facebook']);
                print("object");
                print(userData['facebook']);
              },
              onTapins: (){
                controller.openSuioalMedia(urls: userData['instagram']);
            
                print(userData['instagram']);
            
              },
              onTapwhatsap: (){
                controller.openSuioalMedia(urls: 'https://wa.me/+${userData['whattsapp']}');
                print(userData['whattsapp']);
                
              },
              onTapx: (){
                controller.openSuioalMedia(urls: userData['x']);
                print(userData['x']);
            
              },
            
              ),]
          );
        },
      ),
    
                
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String name;
  final String dateOfBirth;
  final String phone;
  final String maritalStatus;
  final String email;
  final String gender;
  final String Spcail;
  final String tree;

 void Function()? onPressed;
  // final Widget iconWidget;

   ProfileInfo({
    Key? key,
    this.onPressed,
    required this.Spcail,
    required this.gender,
    required this.name,
    required this.dateOfBirth,
    required this.phone,
    required this.maritalStatus,
    required this.email,
    required this.tree,
    // required this.iconWidget,
  }) : super(key: key);
  final ChatController1 chatController1 = Get.put(ChatController1());
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                TextButton(onPressed: onPressed,
                   child: Text('تعديل بياناتي',style: TextStyle(decoration: TextDecoration.underline,fontSize: 17,fontWeight: FontWeight.w600,color: AppColors().darkGreen),)),
              // iconWidget,
               Text(
                "معلوماتي",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:AppColors().lighBrown),
              ),
            ],
          ),
          Card(
            color: Colors.white,
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
            title: Text(" معلوماتي ",textDirection: TextDirection.rtl,style: AppTextStyles.titleStyle,),
              children: [
                Column(
                  children: [
                    ProfileInfoItem(
                      title: 'الاسم الكامل',
                      value: name,
                      icon: const Icon(Icons.person, color: Colors.green),
                    ),
                    ProfileInfoItem(
                      title: 'تاريخ الميلاد',
                      value: dateOfBirth,
                      icon: const Icon(Icons.date_range_sharp, color: Colors.green),
                    ),
                    ProfileInfoItem(
                      title: 'رقم الجوال',
                      value: phone,
                      icon: const Icon(Icons.phone_iphone_rounded, color: Colors.green),
                    ),
                    ProfileInfoItem(
                      title: 'الحالة الاجتماعية',
                      value: maritalStatus,
                      icon: const Icon(Icons.face_retouching_natural_outlined, color: Colors.green),
                    ),
                    ProfileInfoItem(
                      title: 'البريد الاكتروني',
                      value: email,
                      icon: const Icon(Icons.email, color: Colors.green),
                    ),
                    ProfileInfoItem(
                      title: 'الجنس',
                      value: gender=='Male'?"ذكر":"انثئ",
                      icon: const Icon(Icons.male, color: Colors.green),
                    ),
                     ProfileInfoItem(
                      title: 'الوظيفة',
                      value: '$Spcail',
                      icon: const Icon(Icons.work, color: Colors.green),
                    ),
                     ProfileInfoItem(
                      title: 'الرقم علئ الشجرة العائلية',
                      value: '$tree',
                      icon: const Icon(Icons.local_library_rounded, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;

  const ProfileInfoItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      child: ListTile(
        trailing: CircleAvatar(child: icon),
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.grey),
        ),
        subtitle: Text(
          "     $value",
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}

class SMedia extends StatelessWidget {
  void Function()? onTapx;
  void Function()? onTapwhatsap;
  void Function()? onTapfacebok;
  void Function()? onTapins;
  String? whatsapp;
  String? face;
  String? ins;
  String? x;


   SMedia({Key? key,this.onTapfacebok,this.whatsapp,this.face,this.ins,this.x,this.onTapins,this.onTapwhatsap,this.onTapx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         if(x!=null) GestureDetector(onTap: onTapx,child: _buildSocialMediaIcon('assets/icons/twitter.png')),
          if(ins!=null)GestureDetector(onTap: onTapins,child: _buildSocialMediaIcon('assets/icons/instagram.png')),
          if(face!=null)GestureDetector(onTap: onTapfacebok,child: _buildSocialMediaIcon('assets/icons/facebook.png')),
          if(whatsapp!=null)GestureDetector(onTap: onTapwhatsap,child: _buildSocialMediaIcon('assets/icons/whatsapp.png')),
        ],
      ),
    );
  }

  Widget _buildSocialMediaIcon(String assetPath) {
    return Container(
      width: 50,
      height: 50,
      child: CircleAvatar(
        backgroundImage: AssetImage(assetPath),
      ),
    );
  }
}


class InfoOther extends StatelessWidget {
  String UserUid;bool from;
   InfoOther({super.key,required this.UserUid,required this.from});
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              from==true?
                 TextButton(onPressed: ()=>showDialog(context: context, builder: (context)=>WidgetDialogNewOtherInfo()),
                   child: Text(' اضافة معلومات جديدة',style: TextStyle(decoration: TextDecoration.underline,fontSize: 17,fontWeight: FontWeight.w600,color: AppColors().darkGreen),))
              :SizedBox(),
              SizedBox(),
             
              
               Text(
                "معلومات اضافية",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors().lighBrown),
              ),
            ],
          ),
        Card(color: appColors.background,
          child: ExpansionTile(
           shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
          title: Text("معلومات اضافية",style: AppTextStyles.titleStyle,textDirection: TextDirection.rtl,),
          children: [
            StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(UserUid)
            .collection('InfoOther')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لايوجد معلومات اضافية'));
          }

          var userInfoDocs = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: userInfoDocs.length,
            itemBuilder: (context, index) {
              var data = userInfoDocs[index].data() as Map<String, dynamic>;
          var userInfoDoc = snapshot.data!.docs[index];

              return Card(color: Colors.grey.shade100,
                child: ListTile(
                  leading:from==true? IconButton(onPressed: (){
                    showDialog(context: context, builder: (context)=>widgetAlertDialogQu(
                      onPressed: ()=>controller.DeleteInfo(context, userInfoDoc.id),
                      title:'هل تريد الحذف المعلومة',
                      widget: Icon(Icons.question_mark_sharp,color: Colors.white,size: 40,),
                    ));
                  }, icon: Icon(Icons.delete,color: Colors.red,)):SizedBox(),
                  trailing: Icon(Icons.info_outline,size: 30,color: appColors.primary,),
                  title: Center(child: Text(data['name']??'',style: AppTextStyles.titleStyle,)),
                  subtitle: Center(child: Text(data['body']??'' ,style: AppTextStyles.subtitleStyle,))
                ),
              );
            },
          );
        },
      ),
  
          ],
        ),),
      ],
    ),);
  }
}