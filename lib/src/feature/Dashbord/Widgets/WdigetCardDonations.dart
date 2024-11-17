import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Dashbord/View/MenuDonations.dart';
import 'package:family_box/src/feature/Dashbord/View/PageEditeDonations.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/WidgetCardActions.dart';
import 'package:family_box/src/feature/Dashbord/controllers/ControllerEdietDonations.dart';
import 'package:family_box/src/feature/Dashbord/controllers/DonationController.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageDetilesProject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class WidgetCardDonations extends StatelessWidget {
  // ignore: non_constant_identifier_names
  ScrollPhysics? physics=ScrollPhysics();
  Object? isEqualTo;
  bool show=true;
  bool IsAll=true;int itemCount=6;
  bool? isCompleted;
  String?dateShow;
   WidgetCardDonations({super.key,this.dateShow,this.isCompleted,required this.IsAll,this.physics,required this.itemCount,required this.show,this.isEqualTo});
final DonationController controller = Get.put(DonationController());
final EditeDonationControllerImp controlleredite = Get.put(EditeDonationControllerImp());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: 
       IsAll==true&&isEqualTo!=null&&dateShow==null?FirebaseFirestore.instance.collection('donations').where('donationType',isEqualTo: isEqualTo).snapshots():
       IsAll==true&&isEqualTo==null&&dateShow==null?FirebaseFirestore.instance.collection('donations').snapshots():
       
       IsAll==true&&isEqualTo!=null&&dateShow!=null?FirebaseFirestore.instance.collection('donations').where('donationType',isEqualTo: isEqualTo).where('donationDate',isLessThan: dateShow).snapshots():
       IsAll==true&&isEqualTo==null&&dateShow!=null?FirebaseFirestore.instance.collection('donations').where('donationDate',isGreaterThanOrEqualTo: dateShow).snapshots():
       
       FirebaseFirestore.instance.collection('donations').limit(itemCount).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display shimmer loading effect
            return ListView.builder(
              itemCount: itemCount, // Show 5 shimmer boxes while loading
              itemBuilder: (context, index) {
                return ShimmerBox();
              },
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('لايوجد مشاريع'),
            );
          }

          final Docs = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: Docs.length,
            physics: physics,
            itemBuilder: (context, index) {
              var data = Docs[index];
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('donations')
                    .doc(data.id)
                    .collection('Payments')
                    .get(),
                builder: (context, paymentsSnapshot) {
                  if (paymentsSnapshot.connectionState == ConnectionState.waiting) {
                    // Display shimmer loading effect while fetching payments
                    return ShimmerBox();
                  }
                  if (!paymentsSnapshot.hasData || paymentsSnapshot.data!.docs.isEmpty) {
                    return buildProjectCard1(
                      edite:show==true? IconButton(
                        onPressed: () {
                          controlleredite.UidDoc = data.id;
                        controlleredite.donationTitleController.text = data['title'];
                        controlleredite.donationCostController.text = data['donationCost'];
                        controlleredite.donationTypeController.text = data['donationType'];
                        controlleredite.donationDescriptionController.text = data['donationDescription'];
                        controlleredite.recipientIdController.text = data['recipientId'];
                        controlleredite.date = data['donationDate'];
                        controlleredite.imageUrlEdite = data['imageUrl'];
                        controlleredite.fetchUserName();

                        Get.to(PageEditeDonations());
                        },
                        icon: Icon(Icons.edit_square, color: AppColors().darkGreen),
                      ):Text(""),
                      delete:show==true? IconButton(
                        onPressed: () {
                          if(paymentsSnapshot.data!.docs.isNotEmpty){
                            print("have");
                           snackBarErorr('المشروع يحتوي علئ مساهمين لا يمكن حذفة ', context);

                          }else{
                            showDialog(context: context, builder: (context)=>AlertDialog(
                              title: Center(child: CircleAvatar(backgroundColor: Colors.red,child: Icon(Icons.question_mark_rounded,color: Colors.white
                              ,size: 30,)),),
                              content: Container(height: 50,width: double.maxFinite,child: Center(child: 
                              Text("هل تريد حذف مشروع التبرع حقا ؟",style: TextStyle(color: AppColors().darkGreen,fontWeight: FontWeight.w600,fontSize: 16),)
                              ,),),
                              actions: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(width: 90,
                   child: MaterialButton(
                    minWidth: 15,
                    color: Colors.red[100],
                    onPressed: (){Get.back();},child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.error_outline_rounded,color: Colors.red,),Text("الغاء",style: TextStyle(fontWeight: FontWeight.bold))],),),
                 ),
                 Container(width: 90,
                   child: MaterialButton(
                    minWidth: 150,
                    color:AppColors().lighBrown,
                    onPressed: (){
                     controlleredite.deleteDocument(data.id, context);
                    },
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Icon(Icons.save,color: Colors.green,),Text("نعم",style: TextStyle(fontWeight: FontWeight.bold),)],),),
                 )
                 ],)
                              ],
                            ));

                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ):Text(""),
                      title: "${data['title']}",
                      imagePath: "${data['imageUrl']}",
                      currentAmount: 0,
                      targetAmount: int.parse(data['donationCost']),
                      barColor: Colors.white,
                      onTap: () {
                        controller.UidDoc = data.id;
                        Get.to(PageDetilesProject());
                      },
                    );
                  }

                  int totalCost = paymentsSnapshot.data!.docs.fold<int>(
                    0,
                    (previousValue, paymentDoc) =>
                        previousValue + int.parse(paymentDoc['cost']),
                  );
                  double progressPercent =
                      (totalCost / (int.parse(data['donationCost']) > 0
                              ? int.parse(data['donationCost'])
                              : 1)) *
                          100;
                  return buildProjectCard1(
                    edite:show==true? IconButton(
                      onPressed: () {
                        controlleredite.UidDoc = data.id;
                        controlleredite.donationTitleController.text = data['title'];
                        controlleredite.donationCostController.text = data['donationCost'];
                        controlleredite.donationTypeController.text = data['donationType'];
                        controlleredite.donationDescriptionController.text = data['donationDescription'];
                        controlleredite.recipientIdController.text = data['recipientId'];
                        controlleredite.date = data['donationDate'];
                        controlleredite.imageUrlEdite = data['imageUrl'];
                        controlleredite.fetchUserName();

                        Get.to(PageEditeDonations());
                      },
                      icon: Icon(Icons.edit_square, color: AppColors().darkGreen),
                    ):Text(""),
                    delete:show==true? IconButton(
                      onPressed: () {
                         if(paymentsSnapshot.data!.docs.isNotEmpty){
                             snackBarErorr('المشروع يحتوي علئ مساهمين لا يمكن حذفة ', context);
                          }else{
                         
                          }
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ):Text(""),
                    value: progressPercent / 100,
                    title: "${data['title']}",
                    imagePath: "${data['imageUrl']}",
                    currentAmount: totalCost,
                    targetAmount: int.parse(data['donationCost']),
                    barColor: _getProgressColor(progressPercent),
                    onTap: () {
                      controller.UidDoc = data.id;
                      Get.to(PageDetilesProject());
                    },
                  );
                },
              );
            },
          );
        },
      );
  }
}

Color _getProgressColor(double percent) {
  if (percent < 50) {
    return AppColors().lighBrown;
  } else if (percent < 80) {
    return Color.fromARGB(255, 123, 165, 236);
  } else if (percent < 90) {
    return Colors.blue;
  } else {
    return AppColors().darkGreen;
  }
}