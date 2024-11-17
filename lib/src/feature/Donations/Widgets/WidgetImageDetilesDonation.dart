import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/controllers/DonationController.dart';
import 'package:family_box/src/feature/Donations/Veiw/ImageLayoutDonation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetImageDetilesDonation extends StatelessWidget {
   WidgetImageDetilesDonation({super.key});
 final DonationController controller = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('donations')
          .doc(controller.UidDoc)
          .collection('images')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('لايوجد صور',style: AppTextStyles.titleStyle.copyWith(color: Colors.grey),);
        }

        final images = snapshot.data!.docs;

        // Get the first two images
        final firstImageUrl = images[0]['url']; // Assuming 'url' is the field
        final secondImageUrl = images.length > 1 ? images[1]['url'] : null;

        return Row(textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Container(
                 decoration: BoxDecoration(
                  color: AppColors().grayshade300,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                 ),
                height: 120,
                child: GestureDetector(
                  onTap: ()=>Get.to(FullScreenImage(imageUrl: firstImageUrl)),
                  child: Image.network(
                    firstImageUrl,
                    width: MediaQuery.sizeOf(context).width*45,
                    
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                 decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],),
                height: 120,
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                  
                       GestureDetector(
                        onTap: ()=>Get.to(FullScreenImage(imageUrl: secondImageUrl)),
                         child: Image.network(
                          secondImageUrl ?? '', // Display the second image if available
                              width: MediaQuery.sizeOf(context).width*45,
                          height: 100,
                          fit: BoxFit.cover,
                                               ),
                       ),
                  
                    if (images.length > 2)
                      Positioned(
                        top: 30,
                        right: 0,
                        left: 0,
                        // bottom: 0,
                        child: CircleAvatar(backgroundColor: Colors.grey.shade300,
                          child: Center(
                            child: TextButton(onPressed: (){
                              Get.to(ImageGallery(donationId: '${controller.UidDoc}',));
                            }, child: Text(
                              '+${images.length - 2}',
                              style: TextStyle(color:AppColors().blue,fontSize: 25,fontWeight: FontWeight.bold),
                            ),),
                          )
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }}