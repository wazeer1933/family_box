import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/controllers/DonationController.dart';
import 'package:family_box/src/feature/Donations/Controller/contollerCountLikeCountCoust.dart';
import 'package:family_box/src/feature/Donations/Widgets/WidgetCostYourDonation.dart';
import 'package:family_box/src/feature/Donations/Widgets/WidgetImageDetilesDonation.dart';
import 'package:family_box/src/feature/EventsFamli/View/UsersSharing.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageDetilesProject extends StatelessWidget {
  final DonationController controller = Get.put(DonationController());
  final contollerCountLikeCountCoust countController = Get.put(contollerCountLikeCountCoust());

  PageDetilesProject();

  @override
  Widget build(BuildContext context) {
    countController.fetchTotalPaymentsCost(controller.UidDoc ?? '');
    countController.getCount(controller.UidDoc);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder<contollerCountLikeCountCoust>(builder: (con) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('donations').doc(controller.UidDoc).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return _buildShimmerEffect(); // Show shimmer effect when there's no data
                }
        
                var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                int donationCost = int.tryParse(data['donationCost'] ?? '0') ?? 0;
                int remaining = donationCost - countController.totalPaymentsCost.value;
                double progressPercent = (countController.totalPaymentsCost.value / (donationCost > 0 ? donationCost : 1)) * 100;
        
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(color: AppColors().grayshade300,
                          width: double.infinity,
                          height: 300,
                          child: Image.network(data['imageUrl'] ?? '', fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 20,right: 10,
                          child: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_forward_ios_sharp,color: Colors.black,size: 30,)))
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10,left: 20,right: 15),
                             decoration: BoxDecoration(
                        color: appColors.lighBrown,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      ),
                            height: 80,
                              child: Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(data['title'] ?? '', style: AppTextStyles.titleStylePageSize.copyWith(color: Colors.white)),
                                      Text("تاريخ فتح الهدف  / ${data['donationDate'] ?? '-'}", style: AppTextStyles.subtitleStyle.copyWith(color: Colors.white,fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text('256', style: TextStyle(fontSize: 12)),
                                  //     IconButton(onPressed: () {}, icon: Icon(Icons.favorite, color: Colors.red, size: 30)),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 0),
                            Padding(
                              padding: const EdgeInsets.only(left: 5,right: 5),
                              child: Card(color: appColors.background,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildDonationInfo('المطلوب', data['donationCost'].toString()),
                                          _buildDonationInfo('تم جمعة', countController.totalPaymentsCost.value.toString()),
                                          _buildDonationInfo('المتبقي', remaining.toString(), color: Colors.red),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: progressPercent / 100,
                                              backgroundColor: Colors.grey,
                                              color: _getProgressColor(progressPercent),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text('${progressPercent.toStringAsFixed(1)}%', style: TextStyle(fontSize: 18)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: _buildContributorsSection(context, remaining,data['recipientId']),
                            ),
                            SizedBox(height: 5),
                          
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  con.count! > 0
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(UsersSharing(uiddoc: '${controller.UidDoc}',));
                                          },
                                          child: CircleAvatar(radius: 23,backgroundColor: AppColors().grayshade300,child: Center(child: Text("${int.parse('${con.count! - 5}')}" + "+"),),))
                                      : const Text(""),
                                  DonationImagesWidget(uiddoc: controller.UidDoc.toString(),IsDonation: true,),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 15),
                             child: Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,children: [
                                Text('الوصف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Color(0xFF006400))),
                                Text(data['donationDescription'] ?? '', style: TextStyle(fontSize: 16), textDirection: TextDirection.rtl),
                              SizedBox(height: 5),
                              WidgetImageDetilesDonation(),
                              SizedBox(height: 5),
                              _buildDonationButton(context, remaining),
                             ],),
                           )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }

  // Custom shimmer effect widget
  Widget _buildShimmerEffect() {
    return Column(
      children: List.generate(5, (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: 150.0,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Opacity(
            opacity: 0.5,
            child: Container(
              color: Colors.grey.shade200,
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildDonationInfo(String label, String value, {Color color = Colors.grey}) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.titleStyle),
        Text(value, style: TextStyle(fontSize: 18, color: color)),
      ],
    );
  }

  Color _getProgressColor(double percent) {
    if (percent < 50) {
      return Colors.yellow;
    } else if (percent < 80) {
      return Colors.blueAccent;
    } else if (percent < 90) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  Widget _buildContributorsSection(BuildContext context, int remaining,uidUserResp) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('المساهمون', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Color(0xFF006400))),
      
       if(currentUserData[0]['isAdmin']||currentUserData[0]['uid']==uidUserResp) TextButton(onPressed: (){Get.to(DetailsProfileScreen(uidUserResp));}, child: Text('المتبرع لة', style: TextStyle(fontStyle: FontStyle.italic,decoration: TextDecoration.underline,fontSize: 14, fontWeight: FontWeight.w600,color: Color(0xFF006400))),),

       if(currentUserData[0]['isAdmin']) TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: () => controller.pickImages(context), icon: Icon(Icons.image,size: 30, color:AppColors().lighBrown)),
                     Text("اختار صور من المعرض",style: AppTextStyles.titleStyle,),
                  ],
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: Obx(() {
                    if (controller.selectedImages.isEmpty) {
                      return Center(child: Text('لم يتم اختيار اي صورة'));
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: controller.selectedImages.length,
                        itemBuilder: (context, index) {
                          return Image.file(controller.selectedImages[index], fit: BoxFit.cover);
                        },
                      );
                    }
                  }),
                ),
                actions: [
                  MaterialButton(
                    
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minWidth: double.infinity,
                    color: AppColors().darkGreen,
                    height: 45,
                    onPressed: () => controller.uploadImagesToFirebase(context),
                    child: Text('حفظ', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            );
          },
          child: Text("تحميل صور",style: TextStyle(fontStyle: FontStyle.italic,decoration: TextDecoration.underline,fontSize: 14,fontWeight: FontWeight.w600,color: AppColors().darkGreen),),
          
        ),
      ],
    );
  }

  Widget _buildDonationButton(BuildContext context, int remaining) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minWidth: double.infinity,
            color: remaining > 0 ? AppColors().darkGreen : Colors.grey,
            height: 45,
            onPressed: () {
              if (remaining > 0) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 300,
                    child: WidgetCostYourDonation(max: double.parse(remaining.toString()), hideName: controller.hideName),
                  ),
                );
              }
            },
            child: Text(remaining > 0 ? 'تبرع الآن' : 'مكتمل', style: TextStyle(fontSize: 18, color:Colors.white)),
          ),
        ),
      ],
    );
  }
}










// ignore: must_be_immutable
class DonationImagesWidget extends StatelessWidget {
  final String uiddoc; // The document ID of the donation
bool? IsDonation=true;
  DonationImagesWidget({required this.uiddoc,this.IsDonation});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: IsDonation==true? FirebaseFirestore.instance
          .collection('donations').doc(uiddoc).collection('Payments').where('hideName',isEqualTo: false).limit(5).snapshots():
          FirebaseFirestore.instance
          .collection('actions').doc(uiddoc).collection('sharingUsers').limit(5).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(5.0),
            child: CircularProgressIndicator(),
          ); // Loading state
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('لا يوجد مشاركون')); // Handle no data scenario
        }
        // List of future builders to get each user's image
        List<Widget> imageWidgets = snapshot.data!.docs.map(
          (paymentDoc) {
          String uiduser = paymentDoc['userId']; // Get the uiduser from the payment document

          // Fetching user image from the users collection
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(uiduser)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return  Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: CircleAvatar(backgroundColor: Colors.grey.shade300,radius: 23,),
                ); // Loading state for individual user
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const Text('User not found'); // Handle user not found scenario
              }

              // Extracting the image URL from the user document
              String? imageUrl = userSnapshot.data!['image'];

              if (imageUrl == null || imageUrl.isEmpty) {
                return const Text('No image available'); // Handle no image URL scenario
              }

              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                 onTap: (){
                  Get.to(DetailsProfileScreen('${userSnapshot.data!['uid']}',));
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors().grayshade300,
                    radius: 25,backgroundImage: NetworkImage(imageUrl,scale: 25),)),
              );
            },
          );
        }).toList();

        // Display the images in a row
        return Row(
          children: imageWidgets,
        );
      },
    );
  }
}



                      // CircleAvatar(child: Center(child: Text("$count"+"+"),),),






