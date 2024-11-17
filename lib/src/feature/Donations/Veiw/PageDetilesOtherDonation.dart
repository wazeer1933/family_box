import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:family_box/src/feature/Donations/Controller/contollerDonationOthers.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_fatoorah/my_fatoorah.dart';


// ignore: must_be_immutable
class DetilesOtherDonation extends StatelessWidget {
  int type;

  DetilesOtherDonation({super.key,required this.type});
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
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative header with text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(height: 300,
                      child: Image.asset( type==1? 'assets/images/s.png':type==2?'assets/images/z.png':'assets/images/w.png'),),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.brown,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   padding: EdgeInsets.all(32.0),
                  //   child: Text(
                  //     'صدقة',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 36,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Align(alignment: Alignment.centerRight,child: Text('صدقة',style: AppTextStyles.titleStylePageSize.copyWith(fontWeight: FontWeight.bold,fontSize: 25,color: appColors.lighBrown),)),
                  const SizedBox(height: 20),
                  const Text(
                    'قال تعالى ( وَمَا تُنفِقُوا مِنْ خَيْرٍ فَلِأَنفُسِكُمْ )\nالبقرة آية 272\n\n'
                    'قال صلى الله عليه وسلم ( سبعة يظلهم الله في ظله يوم لا ظل إلا ظله وذكر منهم رجل تصدق بصدقة فأخفاها حتى لاتعلم شماله ما تنفق يمينه )',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:Colors.black,
                      fontSize: 16,fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                         showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      // height: 200,
                      child: ValueDonation(type: type,),
                    ),
                  );
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.primary, // Background color
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'تبرع الآن',
                          style: TextStyle(
                            color: Colors.white,fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if(currentUserData.isNotEmpty)
                     if(currentUserData[0]['isAdmin']==true)
                    ElevatedButton(
                      onPressed: () {
                        Get.to(DonationImagesWidget(type: type));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.lighBrown, // Background color
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'المشاركين',
                          style: TextStyle(
                            color: Colors.white,fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
























// ignore: must_be_immutable
class ValueDonation extends StatelessWidget {
  final int type;
  final contollerDonationOthers controller = Get.put(contollerDonationOthers());

  ValueDonation({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ListView(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'ادخل  قيمة التبرعك',
                  style: AppTextStyles.titleStylePageSize,
                ),
                SizedBox(height: 5),
                buildTextField(
                  validator: (v) {
                    if (controller.controller.text.isEmpty) {
                      return 'يرجي ادخل  قيمة التبرعك ';
                    } else {
                      return null;
                    }
                  },
                  controller: controller.controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  obscureText: false,
                  readOnly: false,
                  label: 'ادخل  قيمة التبرعك بالريال السعودي',
                  widget: Icon(Icons.money),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.controller.text.isNotEmpty) {
                        Get.to(MyFatoorahPaym(donationAmount:' ${controller.controller.text}',type: type,));
                      }else{
                        Get.back();
                        snackBarErorr('يرجي ادخل  قيمة التبرعك ', context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: Text(
                      'التالي',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




// ignore: must_be_immutable
class SucessPayment extends StatefulWidget {
String donationAmount;int type;
   SucessPayment({super.key,required this.donationAmount,required this.type});

  @override
  State<SucessPayment> createState() => _SucessPaymentState();
}

class _SucessPaymentState extends State<SucessPayment> {
 final contollerDonationOthers controller = Get.put(contollerDonationOthers());

  @override
  void initState() {
  // delayAction();
     controller.addDonationSharingUsers(context,widget.type);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.gpp_good_outlined,size: 200,color: AppColors().darkGreen,),
        Text(" تم خصم قيمة المساهمة بنجاح",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,fontWeight: FontWeight.bold,color: AppColors().darkGreen),),
        // Text("يرجي الرجوع لاتمام عملية المساهمة",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,fontWeight: FontWeight.bold,color: AppColors().darkGreen),),
         SizedBox(height: 100,),
        


      ],
    ),);
  }
}


class ErorrPayment extends StatefulWidget {
  const ErorrPayment({super.key});

  @override
  State<ErorrPayment> createState() => _ErorrPaymentState();
}

class _ErorrPaymentState extends State<ErorrPayment> {
  Future<void> delayAction() async {
  // Delays for 3 seconds
  await Future.delayed(Duration(seconds: 2));

  print("Action executed after 3 seconds delay");
}
  @override
  void initState() {
  // delayAction();
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded,size: 200,color: Colors.red,),
        Text("لم يتم الدفع   ",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,fontWeight: FontWeight.bold,color: Colors.red),),
        Text(" !! يرجي المحاولة  ",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17,fontWeight: FontWeight.bold,color: Colors.red),),
        
         SizedBox(height: 100,),
        


      ],
    ),);
  }
}

// ignore: must_be_immutable
class MyFatoorahPaym extends StatelessWidget {
  String? donationAmount;int type;
   MyFatoorahPaym({super.key,required this.donationAmount,required this.type});
 final contollerDonationOthers controller = Get.put(contollerDonationOthers());

  @override
  Widget build(BuildContext context) {
    return  MyFatoorah(
        onResult:(response){
            print(response.paymentId);
            print(response.status);
                      //  controller.IdPaymentMyf=response.paymentId.toString();
            
        },
        request: MyfatoorahRequest.test(
                         currencyIso: Country.SaudiArabia,
                              successUrl: 'https://firebasestorage.googleapis.com/v0/b/yallah-tamrin.appspot.com/o/Pages%2Fsuccess.html?alt=media&token=24104a41-db53-4d24-81a4-2fdad342c69a',
                              errorUrl: 'https://firebasestorage.googleapis.com/v0/b/yallah-tamrin.appspot.com/o/Pages%2Ferror.html?alt=media&token=dbd47133-bf80-4c92-bdac-6165f755392e',
                              // ignore: unnecessary_brace_in_string_interps
                              invoiceAmount:double.parse('$donationAmount'),
                              language: ApiLanguage.Arabic,
                              token:'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL'
                           
                      ),
                       successChild: SucessPayment(donationAmount:donationAmount.toString(),type: type,),
                            errorChild: ErorrPayment(),
 );
  }
}


































// ignore: must_be_immutable
class DonationImagesWidget extends StatelessWidget {
  int type;
   DonationImagesWidget({super.key,required this.type});



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
           automaticallyImplyLeading: false,
        actions: [
       IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_forward_ios_rounded))
      ],
        title: Center(child: Text("المساهمون",style: AppTextStyles.titleStylePageSize,),),),
      body: StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance
            .collection('donationPayments').where('type',isEqualTo: type).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Card(color: Colors.grey.shade300,child: ListTile(
                    )),
                 ); // Loading state
          }
      
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child:  Text('لا يوجد مساهمون',style: AppTextStyles.titleStyle.copyWith(color:Colors.grey ),)); // Handle no data scenario
          }
          // List of future builders to get each user's image
          List<Widget> imageWidgets = snapshot.data!.docs.map(
            (paymentDoc) {
            String uiduser = paymentDoc['userId']; // Get the uiduser from the payment document
            String date = paymentDoc['createdAt']; // Get the uiduser from the payment document
            String cost = paymentDoc['cost']; // Get the uiduser from the payment document
      
            // Fetching user image from the users collection
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uiduser)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Card(color: Colors.grey.shade300,child: ListTile(
                    )),
                 ); // Loading state for individual user
                }
      
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const Text('User not found'); // Handle user not found scenario
                }
      
                // Extracting the image URL from the user document
                String? imageUrl = userSnapshot.data!['image'];
                String? name = userSnapshot.data!['name'];

      
                if (imageUrl == null || imageUrl.isEmpty) {
                  return const Text('No image available'); // Handle no image URL scenario
                }
                 
                 return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Card(child: ListTile(onTap: (){
                    if(currentUserData.isNotEmpty)
                    if(currentUserData[0]['isAdmin']==true)Get.to(DetailsProfileScreen(uiduser));
                   },
                    // leading: Center(child: Text(date,),),
                    title: Center(child: Text(name!,style: AppTextStyles.titleStyle.copyWith(color: appColors.lighBrown),)),
                    subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(date,style: AppTextStyles.bodyStyle,),
                    if(currentUserData.isNotEmpty)
                       if(currentUserData[0]['isAdmin']==true||uiduser==currentUserId)   Text(cost,style: AppTextStyles.titleStyle,),
                      ],
                    ),
                    trailing: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),)),
                 );
                // return Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: GestureDetector(
                //    onTap: (){
                //     Get.to(DetailsProfileScreen('${userSnapshot.data!['uid']}',));d
                //     },
                //     child: CircleAvatar(
                //       backgroundColor: AppColors().grayshade300,
                //       radius: 25,backgroundImage: NetworkImage(imageUrl,scale: 25),)),
                // );
              },
            );
          }).toList();
      
          // Display the images in a row
          return Column(
            children: imageWidgets,
          );
        },
      ),
    );
  }
}