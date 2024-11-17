import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerVerfiTowStaps.dart';
import 'package:family_box/src/feature/Profile/verifTowStep/PagePassowrdTowStap.dart';
import 'package:family_box/src/widgets/widgetAlertDialogQu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TwoStepVerificationEnabledScreen extends StatelessWidget {
  final controllerVerfiTowStaps controller = Get.put(controllerVerfiTowStaps());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){Get.back();}, icon: const Icon(Icons.arrow_forward_ios_rounded))
        ],
        title: Center(
          child: Text(
            'التحقق بخطوتين',
            style: AppTextStyles.titleStyle,)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '***',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle, color: Colors.green, size: 24),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'خاصية التحقق بخطوتين مفعّلة. ستحتاج إلى إدخال رقم تعريفك الشخصي عند إعادة تسجيل  في تطبيق عائلة اللحيدان',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
         
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                  showDialog(context: context, builder: (context)=>widgetAlertDialogQu(onPressed: (){
                    controller.savePassowrd(context);
                  },title: 'هل تريد ايقاف خدمة التحقق بخطوتين',widget: Icon(Icons.question_mark_sharp,color: Colors.white,size: 30,),)
                 );
                  },
                  child: Row(
                    children: [
                      Text(
                        'إيقاف',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.close, color: Colors.red),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                   Get.to(PagePassowrdTowStap());
                  },
                  child: Row(
                    children: [
                      Text(
                        'تغيير  رمز التحقق',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '***',
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
