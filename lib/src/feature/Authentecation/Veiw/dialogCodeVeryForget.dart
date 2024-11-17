import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ContollerLogIn.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class dialogCodeVerifiForget extends StatefulWidget {
  const dialogCodeVerifiForget({super.key});

  @override
  State<dialogCodeVerifiForget> createState() => _dialogCodeVerifiForgetState();
}

class _dialogCodeVerifiForgetState extends State<dialogCodeVerifiForget> {
   ControllerLogIn controllerLogIn = Get.put(ControllerLogIn());
 final List<TextEditingController> textControllers = 
      List.generate(6, (index) => TextEditingController());
   
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('ادخل الكود المرسل الئ بريدك'),),
      content: Container(height: 200,width: double.maxFinite,child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text(
                  'أدخل الكود المكون من ٦ أرقام الذي أرسلناه إلى',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(controllerLogIn.EmailController.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                 Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextField(
                              controller:textControllers[index],
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
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
        
                    TextButton(onPressed: (){
                       controllerLogIn.sendOTP(context);
                    }, child: Text("إعادة ارسال الكود",style: AppTextStyles.subtitleStyle.copyWith(color: appColors.primary,decoration: TextDecoration.underline),))
        ],),
      ),),
      actions: [
           Center(
         child: MaterialButton(
          color: appColors.primary,
          onPressed: (){
            String code = textControllers.map((controller) => controller.text).join();
                    if(code.length<6){
                                              snackBarErorr('يرجي ادخال كود التحقق ', context);

         
                    }else{
                                         controllerLogIn.vreyfiForgetVerifi(context, code);

                    }
         },child: Text("الـتـالـي",style: AppTextStyles.titleStyle.copyWith(color: Colors.white)),),
       ),
        // Center(child: TextButton(onPressed: (){
        //             String code =controllerLogIn. textControllers.map((controller) => controller.text).join();
        //           if(code.length<6){
        //               snackBarErorr('يرجي ادخال كود التحقق ', context);

        //           }else{
        //             controllerLogIn.vreyfiForgetVerifi(context, code);
        //           }
        // }, child: Text('تـحـقـق',style: AppTextStyles.titleStyle,)),)
      ],
    );
  }
}
