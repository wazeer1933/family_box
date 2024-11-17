


 import 'package:email_otp/email_otp.dart';

final EmailOTP emailOTP = EmailOTP();

  Future<void> sendOTP() async {
    emailOTP.setConfig(
      appEmail: "Allahaidanfam@example.com", // Replace with your app's email
      appName: "عائلة اللحيدان",
      userEmail: "wazir77540@gmail.com", // Replace with the recipient's email
        otpLength: 5,                                // Length of the OTP

    );
   
    bool result = await emailOTP.sendOTP();

    if (result) {
      print("OTP sent successfully");
       print("OTP code sent:");
    } else {
      print("Failed to send OTP");
    }
  }

  vreyfi()async{
   bool result=await emailOTP.verifyOTP(otp: '23431');
   if (result) {
      print("OTP  successfully");
    } else {
             print("OTP code erorr:");

    }
  }