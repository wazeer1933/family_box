// // import 'package:family_box/src/feature/Home/View/HomePage.dart';
// import 'dart:async';

// import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';


// class SegininVeryfation extends StatefulWidget {
//   const SegininVeryfation({
//     Key? key,
//     this.phoneNumber,
//   }) : super(key: key);

//    final String? phoneNumber;

//   @override
//   State<SegininVeryfation> createState() =>_SegininVeryfationState();}
//   @override
//   State<SegininVeryfation> createState() =>
//       _SegininVeryfationState();

// class _SegininVeryfationState extends State<SegininVeryfation> {
//  AuthController controllerImp=Get.put(AuthController());
 
//   TextEditingController textEditingController = TextEditingController();
//   // ..text = "123456";

//   // ignore: close_sinks
//   StreamController<ErrorAnimationType>? errorController;

//   final formKey = GlobalKey<FormState>();
//   String currentText = "";
//   bool hasError = false;

//   @override
//   void initState() {
//     errorController = StreamController<ErrorAnimationType>();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     errorController!.close();

//     super.dispose();
//   }

//   // snackBar Widget
//   snackBar(String? message) {
//     return ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message!),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Constants.primaryColor,
//       body: GestureDetector(
//         onTap: () {},
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: ListView(
//             children: <Widget>[
//               const SizedBox(height: 30),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height / 3,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(30),
//                   child: Image.asset("assets/images/otp.jpg"),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Text(
//                   'تحقق من رقم الجوال',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                   textAlign: TextAlign.center,
//                 ),
//                 // 546878390
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
//                 child: RichText(
//                   text: TextSpan(
//                     text: " 967775401933",
//                     children: const [
//                       TextSpan(
                        
//                         text: "ادخل الرقم المرسل الئ",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ],
//                     style: const TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Form(
//                 key: formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8.0,
//                     horizontal: 30,
//                   ),
//                   child: PinCodeTextField(
//                     appContext: context,
//                     pastedTextStyle: TextStyle(
//                       color: Colors.green.shade600,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     length: 6,
//                     obscureText: false,
//                     obscuringCharacter: '*',
//                     obscuringWidget: const FlutterLogo(
//                       size: 24,
//                     ),
//                     blinkWhenObscuring: false,
//                     animationType: AnimationType.fade,
//                     validator: (v) {
//                       if (v!.length < 3) {
//                         return "قم بملئ الحقل";
//                       } else {
//                         return null;
//                       }
//                     },
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.underline,
//                       // borderRadius: BorderRadius.circular(5),
//                       fieldHeight: 50,
//                       fieldWidth: 40,
//                       activeFillColor: Colors.white,
//                     ),
//                     cursorColor: Colors.black,
//                     animationDuration: const Duration(milliseconds: 300),
//                     enableActiveFill: true,
//                     errorAnimationController: errorController,
//                     controller: textEditingController,
//                     keyboardType: TextInputType.number,
//                     boxShadows: const [
//                       BoxShadow(
//                         offset: Offset(0, 1),
//                         color: Colors.black12,
//                         blurRadius: 10,
//                       )
//                     ],
//                     onCompleted: (v) {
//                       debugPrint("Completed");
//                       // controllerImp.VeryfcationCode(context);
//                     },
//                     // onTap: () {
//                     //   print("Pressed");
//                     // },
//                     onChanged: (value) {
//                       debugPrint(value);
//                       setState(() {
//                         currentText = value;
//                       });
//                     },
//                     beforeTextPaste: (text) {
//                       debugPrint("Allowing to paste $text");
//                       //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                       //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                       return true;
//                     },
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                 child: Text(
//                   hasError ? "من فضلك قم بملئ الحقول " : "",
//                   style: const TextStyle(
//                     color: Colors.red,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(textDirection: TextDirection.rtl,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "لم يصلني اي كود  ",
//                     style: TextStyle(color: Colors.black54, fontSize: 15),
//                   ),
//                   TextButton(
//                     onPressed: () { 
//                     // resend(context);
//                       print("object");

//                     },
//                     child: const Text(
//                       "أعادةالارسال",
//                       style: TextStyle(
//                         color: Color(0xFF91D3B3),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 14,
//               ),
//               Container(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
//                 // ignore: sort_child_properties_last
//                 child: ButtonTheme(
//                   height: 50,
//                   child: TextButton(
//                     onPressed: () {
//                       if(formKey.currentState!.validate()){
//                        controllerImp.verifyOTP(textEditingController.text,context);
//                         // VeryfcationCode(context);
//                       }

//                       // // conditions for validating
//                       // if (controllerImp.currentText.length != 6 || controllerImp.currentText != "123456") {
//                       //   errorController!.add(ErrorAnimationType
//                       //       .shake); // Triggering error shake animation
//                       //   setState(() => controllerImp.hasError = true);
//                       // } else {
//                       //   setState(
//                       //     () {
//                       //       controllerImp.hasError = false;
//                       //       snackBar("كود تحقق خاطئ");
//                       //     },
//                       //   );
//                       // }
//                     },
//                     child: Center(
//                       child: Text(
//                         "تحقق".toUpperCase(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                     color: Colors.blue.shade600,
//                     borderRadius: BorderRadius.circular(5),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.green.shade200,
//                           offset: const Offset(1, -2),
//                           blurRadius: 5),
//                       BoxShadow(
//                           color: Colors.green.shade200,
//                           offset: const Offset(-1, 2),
//                           blurRadius: 5)
//                     ]),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Flexible(
//                     child: TextButton(
//                       child: const Text("مسح"),
//                       onPressed: () {
//                         textEditingController.clear();
//                       },
//                     ),
//                   ),
//                   Flexible(
//                     child: TextButton(
//                       child: const Text("تعديل النص"),
//                       onPressed: () {
//                         setState(() {
//                           textEditingController.text = "123456";
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
