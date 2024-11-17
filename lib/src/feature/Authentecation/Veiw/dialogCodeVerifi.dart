import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ContollerLogIn.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/dialogCodeVeryForget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable



class dialogCodeVerifi extends StatefulWidget {
  const dialogCodeVerifi({super.key});

  @override
  State<dialogCodeVerifi> createState() => _dialogCodeVerifiState();
}

class _dialogCodeVerifiState extends State<dialogCodeVerifi> {
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
      title: Center(child: Text('ادخل رمز التحقق بخطوتين'),),
      content: Container(height: 150,width: double.maxFinite,child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

                  TextButton(onPressed: (){
                    showDialog(context: context, builder: (context)=>dialogCodeVerifiForget());
                     controllerLogIn.sendOTP(context);
                  }, child: Text("نسيت رمز التحقق",style: AppTextStyles.subtitleStyle.copyWith(color: appColors.primary,decoration: TextDecoration.underline),))
      ],),),
      actions: [
       Center(
         child: MaterialButton(
          color: appColors.primary,
          onPressed: (){
            String code =textControllers.map((controller) => controller.text).join();
                    if(code.length<6){
                        snackBarErorr('يرجي ادخال الرمز ', context);
                            
                    }else{
                      controllerLogIn.checkPassVerifiCode(context, code);
                    }
         },child: Text("الـتـالـي",style: AppTextStyles.titleStyle.copyWith(color: Colors.white)),),
       ),

       
      ],
    );
  }
}