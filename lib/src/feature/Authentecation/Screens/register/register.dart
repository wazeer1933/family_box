import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Authentecation/Screens/login/login.dart';
import 'package:family_box/src/feature/Authentecation/Veiw/pagePrivacy.dart';
import 'package:family_box/src/feature/Authentecation/Widgets/buildTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController controllerImp = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();
  // ignore: unused_field
  static AuthController instance = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding = size.width > 600 ? 60 : 30;
    double fontSize = size.width > 600 ? 24 : 18;
    double buttonWidth = size.width * (size.width > 600 ? 0.4 : 0.5);
    double fieldSpacing = size.height * 0.010;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [ IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 150,
                child: Image.asset(
                  'assets/images/IconApp.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: padding),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "تسجيل عضوية",
                    textAlign: TextAlign.end,
                    style: AppTextStyles.titleStylePageSize.copyWith(fontSize: fontSize),
                  ),
                ),
              ),
              SizedBox(height: fieldSpacing),
              Container(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        readOnly: false,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' الرجاء ادخال اسمك';
                          } else if (value.length < 6) {
                            return 'لايقل  اسمك علئ 6 ارحرف';
                          }
                          return null;
                        },
                        controller: controllerImp.userNameController,
                        label: "الاسم الكامل",
                        widget: Icon(Icons.person),
                      ),
                      SizedBox(height: fieldSpacing),
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
                        controller: controllerImp.EmailController,
                        label: "البريد الاكتروني",
                        widget: Icon(Icons.email),
                      ),
                      SizedBox(height: fieldSpacing),
                      buildTextField(
                        readOnly: false,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' الرجاء ادخال رقم الهاتف';
                          } else if (value.isPhoneNumber && value.trim().length == 12) {
                            return null;
                          }
                          return ' رقم الهاتف غير صالح';
                        },
                        controller: controllerImp.PhoneController,
                        label: "رقم الهاتف",
                        widget: Icon(Icons.phone),
                      ),
                      SizedBox(height: fieldSpacing),
                      buildTextField(
                        readOnly: false,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' الرجاء ادخال كلمةالمرور ';
                          } else if (value.length < 6) {
                            return 'كلمة المرور ضعيفة';
                          }
                          return null;
                        },
                        controller: controllerImp.PasswordController,
                        label: "كلمة المرور ",
                        widget: Icon(Icons.remove_red_eye),
                      ),
                      SizedBox(height: fieldSpacing),
                      buildTextField(
                        readOnly: false,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ' الرجاء اعادة تعين كلمةالمرور ';
                          } else if (value != controllerImp.PasswordController.text) {
                            return ' كلمة المرورليست مطابقة ';
                          }
                          return null;
                        },
                        controller: controllerImp.RePasswordController,
                        label: "اعادة تعين كلمة المرور",
                        widget: Icon(Icons.remove_red_eye),
                      ),
                      SizedBox(height: fieldSpacing),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors().darkGreenForms,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GetBuilder<AuthController>(builder: (con) {
                          return Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  value: 'Fimal',
                                  groupValue: controllerImp.gender,
                                  onChanged: controllerImp.onChanged,
                                  title: Text("انثئ", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  value: 'Male',
                                  groupValue: controllerImp.gender,
                                  onChanged: controllerImp.onChanged,
                                  title: Text("ذكر", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
                                ),
                              ),
                              Center(
                                child: Text("الجنس", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
                      SizedBox(height: fieldSpacing),

                      Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(' بالظغط علئ تسجيل يعني قبولك سياسة وشروط التطبيق',style: AppTextStyles.subtitleStyle.copyWith(fontWeight: FontWeight.w500,color: appColors.primary),textDirection: TextDirection.rtl,),
                          TextButton(onPressed: (){Get.to(pagePrivacy());}, child: Text('سياسة وشروط التطبيق',style: AppTextStyles.titleStyle.copyWith(decoration: TextDecoration.underline,color: appColors.lighBrown),)),
                        ],
                      ),

              // SizedBox(height: fieldSpacing),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: ElevatedButton(
                  onPressed: () {
                  controllerImp.EmailController.text.replaceAll(' ', '');
                  controllerImp.PhoneController.text.replaceAll(' ', '');
                    if (formKey.currentState!.validate()) {
                      // controllerImp.signInEmail(context);
                      controllerImp.signInWithEmailAndPassword(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: LinearGradient(
                        colors: [
                          AppColors().darkGreen,
                          AppColors().lighBrown,
                        ],
                      ),
                    ),
                    child: Text(
                      "تسجيل",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: AppColors().orange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    " امتلك حساب ؟ تسجيل دخول",
                    style: TextStyle(decoration: TextDecoration.underline,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors().darkGreen,
                    ),
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
