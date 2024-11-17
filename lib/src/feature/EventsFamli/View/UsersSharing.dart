import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Dashbord/controllers/DonationController.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/Colors.dart';

class UsersSharing extends StatefulWidget {
  final String uiddoc;

  const UsersSharing({Key? key, required this.uiddoc}) : super(key: key);

  @override
  State<UsersSharing> createState() => _UsersSharingState();
}

class _UsersSharingState extends State<UsersSharing> {
  final DonationController controller = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
           IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
        ],
        title: const Center(
          child: Text(
            "المساهمون",
            style: TextStyle(color: Color(0xFF006400)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('donations')
                .doc(widget.uiddoc)
                .collection('Payments')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Card(color: Colors.grey.shade300,child: ListTile(
                    )),
                 );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No payments found'));
              }

              // List of widgets for each user's data
              List<Widget> paymentWidgets = snapshot.data!.docs.map((paymentDoc) {
                String uidUser = paymentDoc['userId'];
                String cost=paymentDoc['cost'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(uidUser).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Card(color: Colors.grey.shade300,child: ListTile(
                    )),
                 );
                    }

                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return const Text('User not found');
                    }

                    String? imageUrl = userSnapshot.data!['image'];
                    String userName = userSnapshot.data!['name'] ?? 'Unknown';
                    // String treeData = userSnapshot.data!['tree'] ?? '';
                    bool nameHead=paymentDoc['hideName'];
                    
                    return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Card(child: ListTile(onTap: (){
                    if(currentUserData.isNotEmpty)
                    if(currentUserData[0]['isAdmin']==true)Get.to(DetailsProfileScreen(uidUser));
                   },
                    // leading: Center(child: Text(date,),),
                    title: Center(child:
                     Text(nameHead==true?'متبرع لايحب الفصح عن اسمة':userName,style: AppTextStyles.titleStyle.copyWith(color: appColors.lighBrown),)),
                    subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Text(date,style: AppTextStyles.bodyStyle,),
                    if(currentUserData.isNotEmpty)
                       if(currentUserData[0]['isAdmin']==true||uidUser==currentUserId)   Text(cost,style: AppTextStyles.titleStyle,),
                      ],
                    ),
                    trailing:nameHead==false? CircleAvatar(backgroundImage: NetworkImage(imageUrl!),):CircleAvatar(backgroundColor: appColors.lighBrown,))),
                 );
                    // return GestureDetector(
                    //   onTap: () {
                    //     if(nameHead==false||currentUserData[0]['isAdmin']==true)
                    //     Get.to(DetailsProfileScreen(uidUser));
                    //   },
                    //   child: Card(
                    //     margin: const EdgeInsets.symmetric(vertical: 3),
                        
                    //     child: ListTile(
                    //       subtitle: SizedBox(),
                    //       leading: Text(
                    //        nameHead==false?  treeData:"",
                    //         style: const TextStyle(color: Color(0xFF006400)),
                    //       ),
                    //       title: Center(
                    //         child: Text(
                    //          nameHead==false? userName:'متبرع لايحب الفصح عن اسمة',
                    //           style: const TextStyle(color: Color(0xFF006400)),
                    //         ),
                    //       ),
                    //       trailing: imageUrl != null && imageUrl.isNotEmpty&&nameHead==false
                    //           ? CircleAvatar(
                    //               radius: 25,
                    //               backgroundImage: NetworkImage(imageUrl),
                    //             )
                    //           : const SizedBox(height: 25,),
                    //     ),
                    //   ),
                    // );
                  },
                );
              }).toList();

              return Column(
                children: paymentWidgets,
              );
            },
          ),
        ),
      ),
    );
  }
}
