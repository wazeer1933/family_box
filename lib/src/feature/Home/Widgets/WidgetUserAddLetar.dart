import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetUserAddLetar extends StatelessWidget {
  const WidgetUserAddLetar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('tree', isNotEqualTo: null)
          .orderBy('updateDate', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Shimmer effect during loading
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // For RTL support
            itemCount: 5, // Placeholder item count
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors().lighBrown,child: Icon(Icons.person),
                  // child: Container(
                  //   width: 70,
                  //   height: 70,
                  //   color: Colors.grey.shade300,
                  // ),
                ),
              );
            },
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('لايوجد بيانات'));
        }

        final data1 = snapshot.data!.docs;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: true, // For RTL support
          itemCount: data1.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print("${DateTime.now()}");
                print(data1[index]['uid']);
                Get.to(DetailsProfileScreen(data1[index]['uid']));
                // Implement navigation to DetailsProfileScreen if needed
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(backgroundColor: AppColors().grayshade300,
                  radius: 35,
                  backgroundImage: NetworkImage(
                    data1[index]['image'] ?? 'https://via.placeholder.com/150',
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
