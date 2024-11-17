import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/widgets/ChatSecreenConnect.dart';
import 'package:family_box/src/feature/Chat/widgets/widgetCountMessages.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuDonations.dart';
import 'package:family_box/src/feature/Dashbord/View/widgetReports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMangeConnet extends StatefulWidget {
  const ChatMangeConnet({super.key});

  @override
  State<ChatMangeConnet> createState() => _ChatMangeConnetState();
}

class _ChatMangeConnetState extends State<ChatMangeConnet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
        title: Center(child: Text('محادثات التواصل'),),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
                child: StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection('ChatConnet').orderBy('createdAt',descending: true).snapshots(),
                    //  currentUserData[0]['isAdmin']==true? FirebaseFirestore.instance
                    //       .collection('ChatConnet').orderBy('createdAt',descending: true)
                    //       .snapshots():FirebaseFirestore.instance
                    //       .collection('ChatConnet').where('uidUser',arrayContains: currentUserId).orderBy('createdAt',descending: true)
                    //       .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: ShimmerBox());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return  Center(child:Text('لا يوجد محادثات',style: AppTextStyles.titleStyle.copyWith(color: Colors.grey),));
                        }
                         var chatDocs = snapshot.data!.docs;

                         return ListView.builder(
                          shrinkWrap: true,
                           itemCount: chatDocs.length,
                           itemBuilder: (BuildContext context, int index) {
                            final  data=chatDocs[index];
                //             List<dynamic> userIds = data['idUsers'];
                // String otherUserId = userIds.firstWhere((id) => id!= currentUserId);
                             return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(data['uidUser']).get(),
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
                        Get.to(ChatSecreenConnect(name: userData['name'],image: userData['image'],chatId: data.id, userId: userData['uid']));
                  },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                          
                            trailing:Stack(
                              children: [
                                CircleAvatar(radius: 40,child: Icon(Icons.person),backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(userData['image'],),
                                ),
                                CounUnReadMessConn(chatId: data.id,frindId: data['uidUser'],)
                              ],
                            ),
                            
                            title: Align(alignment: Alignment.centerRight,child: Text(userData['name'],style: AppTextStyles.titleStyle.copyWith(fontWeight: FontWeight.w600,fontSize: 15),)),
                          subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('${data['createdAt']}',style: AppTextStyles.subtitleStyle,),
                              ActiveUsers(uid: userData['uid'],),
                            ],
                          ),
                          ),
                        ),
                      ),
                    );
                  },
                );
                           },
                         );
               
              
                      },
                    ),),
    ),
    floatingActionButton: FloatingActionButton(backgroundColor: appColors.primary,child: Icon(Icons.add_circle_outline_outlined,color: Colors.white,),
    onPressed: (){
      showDialog(context: context, builder: (context)=>MySearchDialog());
    }),
    );
  }
}






















class MySearchDialog extends StatefulWidget {
  @override
  _MySearchDialogState createState() => _MySearchDialogState();
}

class _MySearchDialogState extends State<MySearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("رسالة جديدة", style: AppTextStyles.titleStyle)),
      content: Container(
        height: 400,
        width: double.maxFinite,
        child: Column(
          children: [
            // Search TextField
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                filled: true,fillColor: Colors.grey.shade200,
                labelText: 'ابحث بواسطة الاسم أو الرقم علئ الشجرة',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderSide: BorderSide(color: appColors.primary),borderRadius: BorderRadius.circular(8.0)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: appColors.primary),borderRadius: BorderRadius.circular(8.0)),
               

                contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 15)
              ),
            ),
            SizedBox(height: 10),
            // StreamBuilder to display filtered users
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users').where('isEnable',isEqualTo: true)
                    .where('isAdmin', isEqualTo: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found'));
                  }

                  // Filter users by name or tree
                  var filteredDocs = snapshot.data!.docs.where((document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    String name = data['name'] ?? '';
                    String tree = data['tree'] ?? '';
                    String phone = data['phone'] ?? '';
                    return name.contains(_searchQuery) || tree.contains(_searchQuery)|| phone.contains(_searchQuery);
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(child: Text('No matching users found'));
                  }

                  return ListView(
                    children: filteredDocs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String name = data['name'];
                      String uid = data['uid'];
                      String phone = data['phone']??'';
                      String imageUrl = data['image'] ?? '';
                      String tree = data['tree'] ?? 'غير متوفر';

                      return Card(
                        child: ListTile(onTap: (){
                          print(uid);
                        Get.to(ChatSecreenConnect(name: name,image: imageUrl,chatId:uid, userId: uid));
                        },
                          trailing: GestureDetector(
                            onTap: () => Get.to(FullScreenImagePage(imageUrl: imageUrl)),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                              child: imageUrl.isEmpty ? Icon(Icons.person, size: 50) : null,
                            ),
                          ),
                          title: Align(alignment: Alignment.centerRight,child: Text(name, style: AppTextStyles.titleStyle.copyWith(fontSize: 13))),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tree, style: AppTextStyles.titleStyle.copyWith(color: appColors.lighBrown,fontSize: 13)),
                              Text(phone, style: AppTextStyles.titleStyle.copyWith(color: appColors.darkText,fontSize: 13)),

                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
