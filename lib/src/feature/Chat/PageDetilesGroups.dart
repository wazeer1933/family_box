import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/contollers/contollerChat.dart';
import 'package:family_box/src/feature/Chat/widgets/EditenameGroups.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/widgetdropDwon2.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerGetDatausers.dart';
import 'package:family_box/src/widgets/widgetAlertDialogQu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/value_item.dart';

class PageDetailsGroups extends StatefulWidget {
  final String uidDoc;

  const PageDetailsGroups({super.key, required this.uidDoc});

  @override
  State<PageDetailsGroups> createState() => _PageDetailsGroupsState();
}

class _PageDetailsGroupsState extends State<PageDetailsGroups> {
  final UserController userController = Get.put(UserController());
final ChatController chatController=Get.put(ChatController());
  Future<void> _removeUserFromChat(String userId) async {
    userController.userList.removeWhere((element) => element.value.uid == userId);
  }

  Future<List<Map<String, dynamic>>> _fetchUsers(List<dynamic> idUsers) async {
    List<Map<String, dynamic>> usersData = [];

    for (String userId in idUsers) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        usersData.add(userDoc.data() as Map<String, dynamic>);
      }
    }
    return usersData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('Cahts').doc(widget.uidDoc).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                    
                if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                  return const Center(child: Text("Chat data not available."));
                }
                
                var chatData = snapshot.data!.data() as Map<String, dynamic>;
                var idUsers = chatData['idUsers'] as List<dynamic>;
                    
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchUsers(idUsers),
                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return  buildShimmerList();
                    }
                    
                    if (!userSnapshot.hasData || userSnapshot.data == null) {
                      return  Center(child: Text("يرجي الاتصال بالانترنت"));
                    }
                    
                    var users = userSnapshot.data!;
                    
                    return Column(
                      children: <Widget>[
                        ProfileHeader(
                          chatId: widget.uidDoc,
                          imageUrl: chatData['imageUrl'] ?? '',
                          name: chatData['nameChat'] ?? 'No Name',
                        ),
                        Padding(
                          padding:  EdgeInsets.only(right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            if(currentUserData[0]['isAdmin'])  IconButton(
                                onPressed: () {
                                  showDialog(context: context, builder: (context) => AddUser(chatId: '${widget.uidDoc}',));
                                },
                                icon: Icon(Icons.add_circle_outline_rounded, color: AppColors().darkGreen),
                              ),
                              //////////////////////////////
                              // TextButton(onPressed: (){
                              //   if(chatData.isNotEmpty){
                              //     snackBarErorr('لايمكن حذف المموعة تحتوي علئ اعضاء', context);
                              //   }
                              // },
                              //  child: Text("حذف المجموعة",style: AppTextStyles.titleStyle.copyWith(fontWeight: FontWeight.w700,color: Colors.red,decoration: TextDecoration.underline ),)),
                              Text(
                                "المشاركون",
                                style: TextStyle(color: AppColors().darkGreen, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            var user = users[index];
                            _removeUserFromChat(user['uid']);
                            return Header(
                              name: user['name'] ?? 'No Name',
                              image: user['image'] ?? '',
                              number: user['phone'] ?? 'No Number',
                              onPressed: ()=>showDialog(context: context, builder: (context)=>widgetAlertDialogQu(title: 'هل تريد ازالة ${user['name']}',
                              widget: Icon(Icons.question_mark_sharp,color: Colors.white,size: 30,),
                              onPressed: (){
                                chatController.DeleteUserFromChat(widget.uidDoc, context, user['uid']);
                              },
                              ))
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

   Widget buildShimmerList() {
    return Column(
      children: [
          AnimatedContainer(
                child: Center(child: CircleAvatar(backgroundColor: Colors.grey.shade300,),),
      duration: Duration(milliseconds: 1500),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    ),  
        ListView.builder(
          shrinkWrap: true,
          itemCount: 5,  // Showing 5 shimmer items as placeholder
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: ShimmerItem(),  // A custom widget for shimmer effect
            );
          },
        ),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String? date;
  final String? chatId;
  

   ProfileHeader({Key? key, this.date,this.chatId, required this.imageUrl, required this.name}) : super(key: key);
  final ChatController controller=Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        child: Card(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                
                if(currentUserData[0]['isAdmin'])  TextButton(onPressed: (){
                    controller.NewNameGroup.text=name;
                    showDialog(context: context, builder: (context)=>EditeNameGroups(chatId: chatId!,name:name));                  },
                   child: Text('تغير اسم المجموعة',style: TextStyle(fontSize: 15,decoration:TextDecoration.underline,fontWeight: FontWeight.w500,color: AppColors().darkGreen ),)),
                    IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
              Stack(
                children: [
                  CircleAvatar(backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(imageUrl),
                    radius: 50,
                  ),
                  Positioned(
                    bottom: 0,right: 0,
                    child: CircleAvatar(backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){
                        //  if(controller.selectedImage.value!=null)
                      controller.editeIconGroups(chatId, imageUrl);
                      }, icon: Icon(Icons.edit)),
                    ))
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  name,
                  style: TextStyle(color: AppColors().darkGreen,fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Header extends StatelessWidget {
  final String? name;
  final String? number;
  final String? image;
void Function()? onPressed;
   Header({Key? key, this.name,this.onPressed, this.image, this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Card(
        child: ListTile(
          trailing: CircleAvatar(radius: 25,
            backgroundImage: NetworkImage(image ?? ''),
          ),
          title: Align(alignment: Alignment.centerRight,child: Text(name ?? 'فارغ')),
          subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             if(currentUserData[0]['isAdmin']) IconButton(onPressed:onPressed, icon: Icon(Icons.remove_circle_outline_rounded,color: Colors.red,)),
              Text(number ?? 'لا يوجد رقم'),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AddUser extends StatelessWidget {
  String chatId;
  AddUser({super.key,required this.chatId});
  final _keyForm = GlobalKey<FormState>();
  final UserController userController = Get.put(UserController());
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        actionsPadding: EdgeInsets.only(top: 30, right: 20, left: 20, bottom: 20),
        backgroundColor: AppColors().white,
        title: Center(
          child: Text(
            'اضافة اعضاء',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors().darkGreen,
            ),
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: 200,
          child: Form(
            key: _keyForm,
            child: ListView(
              children: [
                Obx(() {
                  if (userController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return DropDwonWithImage(hitTextStyle: TextStyle(),
                    selectionType: SelectionType.multi,
                    hitText: 'اختار الاعضاء',
                    LabelValue: 'اختار الاعضاء',
                    options: userController.userList.toList(),
                    onOptionSelected: (List<ValueItem<dynamic>> selectedOptions) {
                      controller.AddUserGroup = selectedOptions.map((item) => item.value.uid).toList();
                      print("Selected labels: ${controller.AddUserGroup}");
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار الاعضاء';
                      }
                      return null;
                    },
                    searchEnabled: true,
                  );
                }),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_keyForm.currentState?.validate() ?? false) {
                      controller.addUserToChat(chatId, context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.add_comment, textDirection: TextDirection.rtl, size: 20),
                      SizedBox(width: 5),
                      Text('انشاء', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.error_outline, textDirection: TextDirection.rtl, size: 20),
                      SizedBox(width: 5),
                      Text('الغاء', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




  class ShimmerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}