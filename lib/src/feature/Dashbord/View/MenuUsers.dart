// ignore_for_file: sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/UsersContollers.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetRadiousers.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetTreeUsersFamily.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PageUsers extends StatelessWidget {
  PageUsers({super.key});

  final List<Widget> tabs = [
    Tab(
      child: Text(
        'الشجرة العائلية',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    ),
    
        Tab(
          child: Text(
            'مستخدم',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ),
              // CountUsersNew()

   
    Tab(
      child: Text(
        'مدير',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    ),
  ];

  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
             IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
          ],
          // toolbarHeight: 100,
          title: Center(
            child: Text(
              "ادارة المستخدمين",
              style: TextStyle(color: AppColors().darkGreen),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textAlign: TextAlign.right,
                    controller: searchController,
                    onChanged: (value) {
                      searchQuery.value = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintText: "بحث عن مستخدم",
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppColors().grayshade300)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppColors().darkGreen)
                      ),
                    ),
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  labelColor: AppColors().darkGreen,
                  tabs: tabs,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  WidgetTreeFmailyUsers(),
                  Obx(() => UsersList(isAdmin: false, searchQuery: searchQuery.value)),
                  Obx(() => UsersList(isAdmin: true, searchQuery: searchQuery.value)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersList extends StatelessWidget {
  final bool isAdmin;
  final String searchQuery;

  UsersList({required this.isAdmin, required this.searchQuery, Key? key}) : super(key: key);

  final UsersControllers controllersImp = Get.put(UsersControllers());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isAdmin', isEqualTo: isAdmin)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Center(
              child: Text("لا توجد بيانات"),
            );
          }

          var filteredDocs = snapshot.data.docs.where((doc) {
            var userData = doc.data();
            var fullName = "${userData['name']} ${userData['tree']}".toLowerCase();
            return fullName.contains(searchQuery.toLowerCase());
          }).toList();

          return ListView.builder(
            shrinkWrap: true,
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              var userData = filteredDocs[index].data();
              var userId = filteredDocs[index].id;

              return Card(
                child: ListTile(
                  title: Center(
                    child: Text(
                      "${userData['name']} ${userData['tree']}",
                      style: TextStyle(color: AppColors().lighBrown),
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      Get.to(DetailsProfileScreen(userData['uid']));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('${userData['image']}'),
                      minRadius: 0,
                      maxRadius: 40,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          controllersImp.GroupvalueLogIn = userData['isEnable'];
                          controllersImp.GroupvalueUser = userData['isAdmin'];
                          controllersImp.IsAcsept = userData['IsAcsept'];
                          controllersImp.UidUsers = userId;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return GetBuilder<UsersControllers>(builder: (controller) {
                                return _buildEditDialog(context, controllersImp, userData['name']);
                              });
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit_square,
                          color: AppColors().darkGreen,
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     // Implement delete functionality here
                      //   },
                      //   icon: Icon(
                      //     Icons.delete,
                      //     color: Colors.red,
                      //   ),
                      // ),
                      Text(
                        userData['isEnable']==true ? "مخول" : "غير مخول",
                        style: TextStyle(
                          color: userData['isEnable']==true
                              ? AppColors().darkGreen
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData['phone'] ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: userData['isEnable']==true
                              ? Colors.blue
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// The _buildEditDialog function remains the same

// Other classes and helper widgets remain unchanged



 AlertDialog _buildEditDialog(
      BuildContext context, controller,name ) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10),
      title: Center(
        child: Column(
          children: [
            Text("تعديل حالات المستخدم",style: TextStyle(color: AppColors().darkGreen),),
            Text("$name",style: TextStyle(color: AppColors().gray,fontSize: 15),),

          ],
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "نوع الدخول",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors().darkGreen),
            ),
            Container(color: AppColors().grayshade300,
             child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                   _buildRadioGroup(label:'مستخدم' ,value: false,groupValue:controller.GroupvalueUser,onChanged: controller.RadioCangeUser,),
                                  _buildRadioGroup(label:'مدير' ,value: true,groupValue:controller.GroupvalueUser,onChanged: controller.RadioCangeUser,),

                    
             ],),
           ),
            SizedBox(height: 15),
            Text(
              "حالة الدخول",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors().darkGreen),
            ),
           Container(color: AppColors().grayshade300,
             child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 _buildRadioGroup(label:"غير مخول" ,value: false,groupValue:controller.GroupvalueLogIn,onChanged: controller.RadioCangeLogIn,),
                  _buildRadioGroup(label:"مخول" ,value: true,groupValue:controller.GroupvalueLogIn,onChanged: controller.RadioCangeLogIn,),
            
             ],),
           ),
              SizedBox(height: 15),
            Text(
              "حالة التوثيق",
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors().darkGreen),
            ),
           Container(color: AppColors().grayshade300,
             child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                  _buildRadioGroup(label:"غير موثق" ,value: false,groupValue:controller.IsAcsept,onChanged: controller.RadioCangeIsAcsept,),
                _buildRadioGroup(label:"موثق" ,value: true,groupValue:controller.IsAcsept,onChanged: controller.RadioCangeIsAcsept,),
            
             ],),
           )
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.close,
                color: Colors.red.shade600,
              ),
              label: Text("الغاء"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                controller.ContolUsers(context);
              },
              icon: Icon(
                Icons.save,
                color: AppColors().darkGreen,
              ),
              label: Text("حفظ"),
            ),
          ],
        )
      ],
    );
  }

// ignore: must_be_immutable
class _buildRadioGroup extends StatelessWidget {
   bool? groupValue; String? label; bool? value;dynamic onChanged;
   _buildRadioGroup({super.key,this.groupValue,this.label,this.onChanged,this.value});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersControllers>(
      builder: (controllersImp) {
        return Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetRadioUsers(
              groupValue: groupValue,
              Textlable: label!,
              value: value!,
              onChanged: onChanged,
            ),
          ],
        );
      },
    );
  }
}

class Users2 extends StatelessWidget {
   Users2({super.key});
  final UsersControllers controllersImp = Get.put(UsersControllers());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('isAdmin', isEqualTo: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return Center(
                child: Text("لا توجد بيانات"),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var userData = snapshot.data.docs[index].data();
                var userId = snapshot.data.docs[index].id;

                return Card(
                  child: ListTile(
                    title: Center(
                      child: Text(
                        "${userData['name']} ${userData['tree']}",
                        style: TextStyle(color: AppColors().lighBrown),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: (){
                        Get.to(DetailsProfileScreen(userData['uid']));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('${userData['image']}'),
                        minRadius: 0,
                        maxRadius: 40,
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                             controllersImp.GroupvalueLogIn = userData['isEnable'];
                            controllersImp.GroupvalueUser = userData['isAdmin'];
                            controllersImp.IsAcsept = userData['IsAcsept'];
                            controllersImp.UidUsers = userId;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return GetBuilder<UsersControllers>(builder: (controller){
                                  return _buildEditDialog(context, controllersImp,userData['name']);
                                });
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit_square,
                            color: AppColors().darkGreen,
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     // Implement delete functionality here
                        //   },
                        //   icon: Icon(
                        //     Icons.delete,
                        //     color: Colors.red,
                        //   ),
                        // ),
                        Text(
                          userData['isEnable']==true ? "مخول" : "غير مخول",
                          style: TextStyle(
                            color: userData['isEnable']==true
                                ? AppColors().darkGreen
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userData['phone']??'',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: userData['isEnable']==true
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
