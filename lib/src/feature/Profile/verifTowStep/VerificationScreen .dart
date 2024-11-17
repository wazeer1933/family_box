import 'package:family_box/src/core/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions:[ IconButton(
          icon: Icon(Icons.arrow_forward_ios_outlined,size: 30, color: Colors.black),
          onPressed: () {
          Get.back();
          },
        ),],
        title: Center(
          child: Text(
            'التحقق بخطوتين',
            style: AppTextStyles.titleStyle,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                size: 80,
                color: appColors.primary,
              ),
              SizedBox(height: 16),
              Text(
                'إضافة بريد إلكتروني في حال نسيت رقم تعريفك الشخصي',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'عملية التحقق بخطوتين غير مفعّلة. لتفعيلها أضف عنوان بريد إلكتروني   للتأكد من أنك تتمتع بإمكانية الوصول في حال نسيت رقم تعريفك الشخصي.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 32),


              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to add emai
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'إضافة بريد إلكتروني',
                  style: AppTextStyles.titleStyle.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 12),
              // TextButton(
              //   onPressed: () {
              //     // Add functionality to skip
              //   },
              //   child: Text(
              //     'تخطي',
              //     style: TextStyle(fontSize: 16, color: Colors.grey),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
