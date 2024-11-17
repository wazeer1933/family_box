import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Profile/verifTowStep/VerificationCodeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TwoStepVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_forward_ios_rounded))
        ],
        title: Center(
          child: Text(
            'التحقق بخطوتين',
            style: AppTextStyles.titleStyle,),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: appColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '***',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'للمزيد من الحماية، يجب تفعيل خاصية التحقق بخطوتين التي تتطلب إدخال رقم تعريف شخصي عند تسجيل  دخولك  .',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            // GestureDetector(
            //   onTap: () {
            //     // Action for "معرفة المزيد"
            //   },
            //   child: Text(
            //     'معرفة المزيد',
            //     style: TextStyle(
            //       fontSize: 16,
            //       color: Colors.blue,
            //       decoration: TextDecoration.underline,
            //     ),
            //   ),
            // ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Action for enabling two-step verification
                Get.to(VerificationCodeScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'تشغيل',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
