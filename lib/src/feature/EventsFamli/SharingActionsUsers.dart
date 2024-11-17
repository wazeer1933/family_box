import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/controllers/DonationController.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddActions.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SharingActionsUsers extends StatefulWidget {
  String uiddoc;
   SharingActionsUsers({super.key,required this.uiddoc});

  @override
  State<SharingActionsUsers> createState() => _SharingActionsUsersState();
}
final DonationController controller = Get.put(DonationController());

class _SharingActionsUsersState extends State<SharingActionsUsers> {
  final controllerAddCations controllerAddCation=Get.put(controllerAddCations());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(" المشاركون",style: TextStyle(color:Color(0xFF006400) ),),),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('actions')
            .doc(widget.uiddoc)
            .collection('sharingUsers')
            // Limit to the first 5 documents
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircularProgressIndicator(),
            ); // Loading state
          }
        
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No payments found'); // Handle no data scenario
          }
        
          // List of future builders to get each user's image
          List<Widget> imageWidgets = snapshot.data!.docs.map(
            (Sharing) {
            String uiduser = Sharing['userId']; // Get the uiduser from the payment document
              var dataSharing=Sharing;
            // Fetching user image from the users collection
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uiduser)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Card(child: ListTile()); // Loading state for individual user
                }
        
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return Text('User not found'); // Handle user not found scenario
                }
        
                // Extracting the image URL from the user document
                String? imageUrl = userSnapshot.data!['image'];
        
                if (imageUrl == null || imageUrl.isEmpty) {
                  return Text('No image available'); // Handle no image URL scenario
                }
        
                return GestureDetector(
                  onTap: (){
                    Get.to(DetailsProfileScreen("${controller.UidUser}"));
                  },
                  child: Card(color: Colors.white,
                    child: Container(margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                      subtitle: Row(textDirection: TextDirection.rtl,mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                             Text("حالة الطلب  : ${dataSharing['Sharing']==true?'مقبول':'مرفوض'}",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w900)),



                           dataSharing['Sharing']==false&&currentUserData[0]['isAdmin']==true?Container(
                             child: TextButton(onPressed: (){
                              controllerAddCation.sharingUserDoc=dataSharing.id;
                              controllerAddCation.sharingUserUid=dataSharing['userId'];
                              showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          content: Container(width: double.maxFinite,
                                            height: 70,
                                            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("هل تريد موفقة طلب للانطمام فعلا ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:AppColors().darkGreen),),
                                                Text('${userSnapshot.data!['name']} ${userSnapshot.data!['tree']}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black),),
                                              ],
                                            ),)),
                                        actions: [
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                                            MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),minWidth: 70,height: 40,color: Colors.red,onPressed: (){Get.back();},child: Text("الغاء",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors().white),),),
                                            MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),minWidth: 70,height: 40,color: AppColors().darkGreen,onPressed: (){
                                              Get.back();
                                              controllerAddCation.EditeActionSharingUsers(true);
                                              },child: Text("نعم",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors().white)),)
                                          ],)
                                        ],
                                        );
                                      });
                             },
                              child: Text( "قبول",style: TextStyle(color: Colors.green,fontSize: 17,fontWeight: FontWeight.w900),)),
                           ):
                            
                            
                            
                            
                            
                            
                            
                           currentUserData[0]['isAdmin']==true? TextButton(onPressed: (){
                               controllerAddCation.sharingUserDoc=dataSharing.id;
                            controllerAddCation.sharingUserUid=dataSharing['userId'];
                            showDialog(context: context, builder: (context){
                                      return AlertDialog(
                                        content: Container(width: double.maxFinite,
                                          height: 70,
                                          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("هل تريد الفاء طلب للانطمام فعلا ",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color:AppColors().darkGreen),),
                                              Text('${userSnapshot.data!['name']} ${userSnapshot.data!['tree']}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black),),
                                            ],
                                          ),)),
                                      actions: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                                          MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),minWidth: 70,height: 40,color: Colors.red,onPressed: (){Get.back();},child: Text("الغاء",style: TextStyle(color: AppColors().white),),),
                                          MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),minWidth: 70,height: 40,color: AppColors().darkGreen,onPressed: (){
                                            Get.back();
                                            controllerAddCation.EditeActionSharingUsers(false);
                                            },child: Text("نعم",style: TextStyle(color: AppColors().white)),)
                                        ],)
                                      ],
                                      );
                                    });
                            }, 
                            child: Text("الغاء ",style: TextStyle(color: Colors.red,fontSize: 17,fontWeight: FontWeight.w900))):Text('')
                            // TextButton(onPressed: (){}, child: Text("معلق",style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w700))),
                          ],
                        ),
                        
                        title: Center(child: Text("${userSnapshot.data!['name']} ${userSnapshot.data!['tree']}",style: TextStyle(color: Color(0xFF006400)))),
                        trailing: CircleAvatar(radius: 30,backgroundImage: NetworkImage(imageUrl),),),
                    ),
                  ),
                );
              },
            );
          }).toList();
        
          // Display the images in a row
          return Column(
            children: imageWidgets,
          );
        },
            )
        ),
      ),
    );
  }
}