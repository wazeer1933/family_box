import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
// import 'package:family_box/src/feature/Chat/CallVedio.dart';
import 'package:family_box/src/feature/Chat/ChatSecreenUser.dart';
import 'package:family_box/src/feature/Chat/ChatsGroups.dart';
import 'package:family_box/src/feature/Chat/contollers/contollerChat.dart';
import 'package:family_box/src/feature/Chat/contollers/controllerSendChats.dart';
// import 'package:family_box/src/feature/Chat/vedio/CreateCallScreen.dart';
import 'package:family_box/src/feature/Chat/widgets/widgetCountMessages.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuDonations.dart';
import 'package:family_box/src/feature/Dashbord/View/widgetReports.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTextFiledDash.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/widgetdropDwon2.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerGetDatausers.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerUsers.dart';
// import 'package:family_box/src/feature/Vedio/group_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/value_item.dart';

class HomeAllChats extends StatefulWidget {
  const HomeAllChats({super.key});

  @override
  State<HomeAllChats> createState() => _HomeAllChatsState();
}

class _HomeAllChatsState extends State<HomeAllChats> {
  final _keyForm=GlobalKey<FormState>();
  final ChatController controller=Get.put(ChatController());
final UserController userController = Get.put(UserController());
  // final String currentUserId='EDEDEDNEJKBJR48';
  
 final ChatController1 con =Get.put(ChatController1());
  ///DWDI3ENEJDENDIE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:   IconButton(onPressed: (){
          // Get.to(GroupCallVideo());
          
        }, icon: Icon(Icons.video_call_rounded,color: Colors.green,)),
        automaticallyImplyLeading: false,
        title: const Center(child: Text("المحادثات",style: AppTextStyles.titleStylePageSize,)),
      actions: [
        
         IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
      
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
                child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Cahts').where('idUsers',arrayContains: currentUserId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: ShimmerBox());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return  Center(child:Text('لا يوجد محادثات'));
                        }
                         var chatDocs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: chatDocs.length,
                        itemBuilder: (context, index) {
                          var chatData = chatDocs[index];
                 List<dynamic> userUids = chatData['idUsers'];
                              userUids.removeWhere((element) => element==currentUserId);
                 print(userUids);
                          if (chatData['IsGroup'] == true) {
                            return GestureDetector(
                  onTap: (){
                    
                    con.chatId=chatData.id;
                    con.userId=currentUserId;
                    con.IsGroup=chatData['IsGroup'];
                    Get.to(ChatScreenGroups(chatId: chatData.id, userId:currentUserId,name: chatData['nameChat'],image: chatData['imageUrl'],));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        // subtitle: Text('${lm}'),
                        leading: Text('${chatData['createdAt']}'),
                        trailing:Stack(
                          children: [
                            CircleAvatar(radius: 40,backgroundColor: Colors.white,child: Icon(Icons.groups_2),
                              backgroundImage: NetworkImage(chatData['imageUrl']),
                            ),
                              CounUnReadMessGr(chatId: chatData.id,frindId: userUids)


                          ],
                        ),
                        title: Align(alignment: Alignment.centerRight,child: Text(chatData['nameChat'],style: TextStyle(color: AppColors().darkGreen,fontWeight: FontWeight.w600))),
                      ),
                    ),
                  ),
                );
              } else {
                List<dynamic> userIds = chatData['idUsers'];
                String otherUserId = userIds.firstWhere((id) => id!= currentUserId);
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Center(child: Text("...يتم التحميل ",style: TextStyle(color: Colors.blue),)),
                          ),
                        ),
                      );
                    }

                    var userData = userSnapshot.data!;
                    return GestureDetector(
                      onTap: (){
                    print("object============");
                        con.userId='';
                         con.chatId=chatData.id;
                    con.userId=currentUserId;
                    con.frindId=otherUserId;
                    // Get.to(ChatBody(chatId: chatData.id));
                    con.IsGroup=chatData['IsGroup'];
                  con.checkChatExists();

                    Get.to(ChatScreen(chatId: chatData.id,otherUserId: otherUserId,userId: currentUserId,name:userData['name'],image: userData['image'],));
                  },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Text('${chatData['createdAt']}'),
                            trailing:Stack(
                              children: [
                                CircleAvatar(radius: 40,child: Icon(Icons.person),backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(userData['image'],),
                                ),
                                CounUnReadMess(chatId: chatData.id,frindId: otherUserId,)
                              ],
                            ),
                            
                            title: Align(alignment: Alignment.centerRight,child: Text(userData['name'],style: TextStyle(color: AppColors().darkGreen,fontWeight: FontWeight.w600),)),
                          subtitle: ActiveUsers(uid: otherUserId,),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
                      },
                    ),),
      ),













      ///////////////////////////////
      floatingActionButton:GetBuilder<UsersControllersImp>(builder: (con){
        return
   currentUserData.isNotEmpty?      
      currentUserData[0]['isAdmin']==true? FloatingActionButton(backgroundColor: AppColors().darkGreen,onPressed: (){
        controller.clearsfeilds();
        controller.IsGroup=true;
        userController.fetchUsers();
        showDialog(context: context, builder: (context){
         return Container(
           child: AlertDialog(
            actionsPadding: EdgeInsets.only(top: 30,right: 20,left: 20,bottom: 20),
            backgroundColor: AppColors().white,
                 title: Container(
                  
                   child: Center(child:  Text(
                  ' انشاء مجموعة جديدة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:AppColors().darkGreen,
                  ),
                ),),),
                   content: Container(
            
            width: double.maxFinite,height: 300,
            child: Form(
              key: _keyForm,
              child: ListView(
                children: [
                  WidgetTextfiledDash(
                    controller: controller.nameChat,
                    maxLines: 1,
                    label: 'اسم و ايقونة المجموعة',
                    widget: Obx((){
                      return controller.selectedImage.value==null?
                      TextButton(onPressed: (){
                       controller.pickImage(ImageSource.gallery);
                    },
                     child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.add_a_photo_outlined),)):
                     TextButton(onPressed: (){
                       controller.pickImage(ImageSource.gallery);
                    },
                     child: CircleAvatar(backgroundImage: FileImage(controller.selectedImage.value!),child: Icon(Icons.add_a_photo_outlined),));
                    }),
                    Labelvlaue: 'اسم المجموعة',
                     validator: (value) {
                      if (value == null || value.isEmpty || value.length<5) {
                        return "برجي ادخال  اسم لايقل عن 5 حرف ";
                      }
                      return null;
                    },
                  ),SizedBox(height: 10,),
                 ///////////////////////////////////////////////////////////////
                  Obx(() {
                  if (userController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return DropDwonWithImage(
                    selectionType: SelectionType.multi,
                    hitText: 'اختار الاعضاء',
                    LabelValue: 'اختار الاعضاء',
                    hitTextStyle: TextStyle(),
                    options: userController.userList.toList(),
                    onOptionSelected: <User>(List<ValueItem<dynamic>> selectedOptions) {
                      for(var option in selectedOptions){
                          controller.UsersChat = selectedOptions.map((item) => item.value.uid).toList();
                    print("Selected labels: ${controller.UsersChat}");
                        option.label==' ';
                       setState(() {});
                       }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار  الاعضاء';
                      }
                      return null;
                    }, searchEnabled: true,
                  );
                }),
                SizedBox(height: 10,)
                ],
              ),
            ),
                   ),
                   actions: [
             Row(textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Container(
                    
                    child: ElevatedButton(
                      onPressed: () {
                        if(_keyForm.currentState?.validate() ?? false){
                          controller.AddChat(context);
                        }
                      },
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.add_comment,textDirection: TextDirection.rtl,size: 20,),SizedBox(width: 5,),
                          Text('انشاء',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().darkGreen,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
               Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Container(
                    
                    child: ElevatedButton(
                      onPressed: () {Get.back();},
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.error_outline,textDirection: TextDirection.rtl,size: 20,),SizedBox(width: 5,),
                          Text('الغاء',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
             ],)
                   ],
               ),
         );
        });
      },child: Icon(Icons.add_circle_outline_rounded,color: Colors.white,),):SizedBox():SizedBox();
      })
    );
  }
}

