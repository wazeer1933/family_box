import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ContollerLogIn.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Screens/register/register.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  ControllerLogIn controllerLogIn = Get.put(ControllerLogIn());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding = size.width > 600 ? 80 : 40; // Increased padding for larger screens
    double imageSize = size.width > 600 ? 200 : 150; // Adjust image size based on screen width

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: imageSize,
                child: Image.asset(
                  'assets/images/IconApp.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "(: مرحبا بعودتك",
                  style: AppTextStyles.titleStylePageSize.copyWith(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildTextField(
                      readOnly: false,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' الرجاء ادخال البريد الاكتروني';
                        } else if (value.isEmail) {
                          return null;
                        }
                        return 'البريد الاكتروني غير صالح';
                      },
                      controller: controllerLogIn.EmailController,
                      label: "البريد الاكتروني",
                      widget: Icon(Icons.email),
                    ),
                    SizedBox(height: size.height * 0.03),
                    buildTextField(
                      readOnly: false,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' الرجاء ادخال كلمة المرور';
                        } else if (value.length < 6) {
                          return 'كلمة المرور ضعيفة';
                        }
                        return null;
                      },
                      controller: controllerLogIn.PassController,
                      label: "كلمة المرور",
                      widget: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.remove_red_eye),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          controllerLogIn.checkPasswordForget(context);
                        }
                      },
                      child: Text(
                        "نسيت كلمة المرور ؟",
                        style: TextStyle(color: appColors.primary),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () async{
                    // await FirebaseAuth.instance.signOut();
                    print("${controllerLogIn.auth.currentUser?.uid}");
                    controllerLogIn.EmailController.text.replaceAll(' ', '');
                    if (formKey.currentState!.validate()) {
                      // ignore: unnecessary_null_comparison
                      if(controllerLogIn.auth.currentUser?.uid!=null){
                        snackBar('مسجل دخول ولاكن غير مخول يرجي التواصل مع الادارة', context);
                        
                      }else{
                        controllerLogIn.checkPassVerifi(context);
                      }
                      // sharedPreferences.clear();
                      // ignore: unnecessary_null_comparison
                      // print(sharedPreferences.getString('uid'));
                      // print(IsEnable);
                      // // ignore: unnecessary_null_comparison
                      // if (currentUserId == null || currentUserId == 'null') {
                      //   controllerLogIn.checkEmailExists(context);
                      // } else if (IsEnable == false && sharedPreferences.getString('uid') != null) {
                      //   snackBar('مسجل دخول ولاكن غير مخول يرجي التواصل مع الادارة', context);
                      // }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: LinearGradient(
                        colors: [
                          appColors.primary,
                          appColors.lighBrown,
                        ],
                      ),
                    ),
                    child: Text(
                      "دخول",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleStylePageSize.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                  child: Text(
                    "ليس لدي حساب ؟ انشاء حساب",
                    style: AppTextStyles.titleStyle,
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
