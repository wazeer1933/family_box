import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Profile/Controller/controllerVerfiTowStaps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationCodeScreen extends StatelessWidget {
  final controllerVerfiTowStaps controller = Get.put(controllerVerfiTowStaps());
  
  // Create a list of TextEditingControllers for each input field
  final List<TextEditingController> textControllers = 
      List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions:[ IconButton(
          icon: Icon(Icons.arrow_forward_ios_outlined, color: Colors.black),
          onPressed: () {
           Get.back();
          },
        ),],
        title: Center(
          child: Text(
            'التحقق من بريدك الإلكتروني',
            style: AppTextStyles.titleStyle,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'أدخل الكود المكون من ٦ أرقام الذي أرسلناه إلى',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(currentUserData[0]['email'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // TextButton(
              //   onPressed: () {
              //     // Add functionality to change email
              //   },
              //   child: Text(
              //     'البريد الإلكتروني غير صحيح؟',
              //     style: TextStyle(fontSize: 16, color:appColors.lighBrown),
              //   ),
              // ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: textControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: appColors.primary, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }else if(value.length == 1 && index < 5&&index==index){

                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  controller.sendOTP(context);
                },
                child: Text(
                  'أرسل كوداً التحقق',
                  style: TextStyle(fontSize: 16, color:appColors.primary),
                ),
              ),
              // Spacer(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  onPressed: () {
                    // Collect and print all values from the TextFields
                    String code = textControllers.map((controller) => controller.text).join();
                    controller.code.text=code;
                    print('Entered Code: $code');
                    if(code.length<6){
                      snackBarErorr('يرجي ادخال كود التحقق', context);
                    }else{
                      controller.vreyfi(context);
                      // Get.to(PagePassowrdTowStap());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'تحقق',
                    style:AppTextStyles.titleStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
