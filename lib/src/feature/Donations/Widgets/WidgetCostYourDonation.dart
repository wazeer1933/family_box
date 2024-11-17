

import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Dashbord/controllers/DonationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

// ignore: must_be_immutable
class WidgetCostYourDonation extends StatefulWidget {
  double max = 1.0;
  bool hideName = false;


  WidgetCostYourDonation({super.key,required this.max,required this.hideName});
  @override
  _WidgetCostYourDonationState createState() => _WidgetCostYourDonationState();
}

class _WidgetCostYourDonationState extends State<WidgetCostYourDonation> {
  double? _donationAmount=10;
 final DonationController controller = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'اختار قيمة التبرع ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Slider(
              
              value: _donationAmount!,
              min: 10,
              max: widget.max,
              divisions: 100,
              label: _donationAmount!.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _donationAmount = value;
                  print(_donationAmount!.toInt());
                });
              },
            ),
            Text(
              '${_donationAmount!.toInt()} ريال',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               GetBuilder<DonationController>(builder: (con)=> Checkbox(
                  value:con.hideName,
                  onChanged: (value) {
                    setState(() {
                     con.hideName = value!;
                     print(controller.hideName);
                    });
                  },
                ),),
                Text('لا أريد اظهار اسمي كمتبرع (فاعل خير)'),
              ],
            ),
            SizedBox(height: 5),
            Container(width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  Get.to(MyFatoorahPaym(donationAmount:' ${_donationAmount!.toInt()}'));
                  
                },
                style: ElevatedButton.styleFrom(
                
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'التالي',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

    );
  }
}


// ignore: must_be_immutable
class SucessPayment extends StatefulWidget {
String donationAmount;
   SucessPayment({super.key,required this.donationAmount});

  @override
  State<SucessPayment> createState() => _SucessPaymentState();
}

class _SucessPaymentState extends State<SucessPayment> {
 final DonationController controller = Get.put(DonationController());

  Future<void> delayAction() async {
  // Delays for 3 seconds
  await Future.delayed(Duration(seconds: 2));
        //  Navigator.of(context).pop();
  // Action after the delay
  print("Action executed after 3 seconds delay");
}
  @override
  void initState() {
  // delayAction();
     controller.addDonationSharingUsers('',widget.donationAmount,context);

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
  String? donationAmount;
   MyFatoorahPaym({super.key,required this.donationAmount});
 final DonationController controller = Get.put(DonationController());

  @override
  Widget build(BuildContext context) {
    return  MyFatoorah(
        onResult:(response){
            print(response.paymentId);
            print(response.status);
                       controller.IdPaymentMyf=response.paymentId.toString();
            
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
                       successChild: SucessPayment(donationAmount:donationAmount.toString(),),
                            errorChild: ErorrPayment(),
 );
  }
}