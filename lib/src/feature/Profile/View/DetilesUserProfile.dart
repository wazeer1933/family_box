// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/ChatSecreenUser.dart';
import 'package:family_box/src/feature/Chat/contollers/controllerSendChats.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerDerilesUser.dart';
import 'package:family_box/src/feature/Profile/View/MyProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsProfileScreen extends StatefulWidget {
  final String? uidUser;

  const DetailsProfileScreen(this.uidUser, {Key? key}) : super(key: key);

  @override
  _DetailsProfileScreenState createState() => _DetailsProfileScreenState();
}

class _DetailsProfileScreenState extends State<DetailsProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uidUser)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Check if snapshot has data and it exists
              if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                return const Center(child: Text("User data not available."));
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>?;

              // Further null check for userData
              if (userData == null) {
                return const Center(child: Text("User data not found."));
              }

              return Column(
                children: <Widget>[
                  ProfileHeader(
                    frindId: widget.uidUser!,
                    widget: 
                   Text(userData['IsAcsept']==true?'حساب موثق':'حساب غير موثق',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,fontStyle: FontStyle.italic,color: userData['IsAcsept']==true?AppColors().darkGreen:AppColors().gray),),
                  
                    imageUrl: userData['image'] ?? '',
                    name: userData['name'] ?? 'No Name',
                  ),
                  ProfileInfo(
                    imageIdentity: userData['imageUrlIdentity'] ??'',
                    image: userData['image'],
                    frindId: '${widget.uidUser}',
                  gender: userData['gender'] ,
                  tree: userData['tree']??'لم يتم التعين في الشجرة' ,

                    // iconWidget: userData['gender'] == 'Male'
                    //     ? const CircleAvatar(child: Icon(Icons.male))
                    //     : const CircleAvatar(child: Icon(Icons.female)),
                     name: userData['name'] ?? ' الاسم غير متوفر',
                    email: userData['email'] ?? ' الايمل غير متوفر',
                    phone: userData['phone'] ?? 'رقم الهاتف غير متوفر',
                    dateOfBirth: userData['dateBithe'] ?? 'لايوجد تارخ ميلاد',
                    maritalStatus: userData['maride'] ?? 'الحالة الاجتماعية غير متوفرة',
                    spical: userData['spical'] ?? 'الوظيفة غير متوفر',
                  ),
                  InfoOther(UserUid:widget.uidUser.toString(), from: false,)

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
 final Widget widget;
 final String frindId;
   ProfileHeader({Key? key,required this.frindId,required this.widget, required this.imageUrl, required this.name}) : super(key: key);
  final controllerEditeMyProfile controller = Get.put(controllerEditeMyProfile());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget,

              Row(mainAxisAlignment: MainAxisAlignment.end,mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                "الحساب",
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
                ],
              ),
              
            ],
          ),
          Card(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
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
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  ExpansionTile(
                    shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
            title: Text(" حسابات التوصل الاجتماعي ",textDirection: TextDirection.rtl,style: AppTextStyles.subtitleStyle,),
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                              // Get the document by its ID in the 'users' collection
                              stream: FirebaseFirestore.instance.collection('users').doc(frindId).collection('SuioalMedia').doc(frindId).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                
                                if (!snapshot.hasData || !snapshot.data!.exists) {
                                  return Center(child: Text('لايوجد حسابات التواصل الاجتماعي'));
                                }
                      
                                var userData = snapshot.data!.data() as Map<String, dynamic>;
                                
                                return SMedia(whatsapp: userData['whattsapp'],ins:userData['instagram'] ,x: userData['x'],face: userData['facebook'],
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
                      
                                  );
                              },
                            ),
                    ],
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
  // final Widget iconWidget;
  final String frindId;
  final String gender;
  final String image;
  final String spical;
  final String imageIdentity;
  final String tree;
   



   ProfileInfo({
    Key? key,
    required this.tree,
    required this.name,
    required this.spical,
    required this.frindId,
    required this.dateOfBirth,
    required this.phone,
    required this.maritalStatus,
    required this.email,
    required this.gender,
    required this.image,
    required this.imageIdentity,

    // required this.iconWidget,
  }) : super(key: key);
  final ChatController1 chatController1 = Get.put(ChatController1());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 0,horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  chatController1.IsGroup=false;
                  chatController1.frindId=frindId;
                  chatController1.userId=currentUserId;
                  chatController1.checkChatExists();
                  Get.to(ChatScreen(chatId: 'chatId',image: image, userId: frindId,name: name,otherUserId: frindId,));
                },
                icon: const Icon(Icons.mark_unread_chat_alt_rounded, color: Colors.green,size: 30,),
              ),
              /////////////////////////////////////////////////////////
              // ignore: unnecessary_null_comparison
              if(currentUserData[0]['isAdmin']==true&&imageIdentity!='')TextButton(onPressed: (){Get.to(FullScreenImagePage(imageUrl: imageIdentity));}, child: Text('صورة الهوية الشخصية',style: TextStyle(color: AppColors().darkGreen,decoration: TextDecoration.underline),)),
              //////////////////////////////////////////////////////////
              // iconWidget,
               Padding(
                 padding: const EdgeInsets.only(right: 20),
                 child: Text(
                  "معلومات",
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.titleStylePageSize,
                               ),
               ),
            ],
          ),
          Card(
            color: Colors.white,
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
            title: Text(" معلومات ",textDirection: TextDirection.rtl,style: AppTextStyles.titleStyle,),
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
                      value: '$spical',
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
      margin: const EdgeInsets.only(bottom: 0),
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
