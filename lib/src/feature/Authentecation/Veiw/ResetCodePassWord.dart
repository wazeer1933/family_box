import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ContollerLogIn.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ResetCodePassWord extends StatelessWidget {
   ResetCodePassWord({super.key});
  ControllerLogIn controllerLogIn = Get.put(ControllerLogIn());

  final List<TextEditingController> textControllers = 
      List.generate(6, (index) => TextEditingController());
       final List<TextEditingController> textControllers2 = 
      List.generate(6, (index) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){Get.back();}, icon: const Icon(Icons.arrow_forward_ios_rounded))
        ],
        title: const Center(
          child: Text(
            'تعين رمز التحقق بخطوتين',
            style: AppTextStyles.titleStyle,),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child:  ListView(
          children: [
           Column(crossAxisAlignment: CrossAxisAlignment.end,
             children: [
              Text('ادخل رمز التحقق بخطوتبن',style: AppTextStyles.subtitleStyle,),
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
                            decoration: InputDecoration(hintText: '*',
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
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
             ],
           ),







                SizedBox(height: 40,),



           Column(crossAxisAlignment: CrossAxisAlignment.end,
             children: [
              Text('إعادة تعين رمز التحقق بخطوتبن',style: AppTextStyles.subtitleStyle,),
               Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            controller: textControllers2[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(fontSize: 24),
                            decoration: InputDecoration(hintText: '*',
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
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
             ],
           ),


   SizedBox(height: 40,),

 Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  onPressed: () {
                    // Collect and print all values from the TextFields
                    String code = textControllers.map((controller) => controller.text).join();
                    String code2 = textControllers2.map((controller) => controller.text).join();

                    
                    print('Entered Code: $code');
                    if(code.length<6){
                      snackBarErorr('يرجي ادخال الرمز ', context);
                    }else if(code!=code2){
                      snackBarErorr('الرمز غير متطابق', context);

                    }
                    else{
                      controllerLogIn.updateUserCode(code, context);
                      // Get.to(ResetCodePassWord());
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
                    'حفظ',
                    style:AppTextStyles.titleStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),





          ],
        ),
      ),
    );
  }
}
