// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
sendMessage(String title,String message,context)async{
  await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true);
var headersList = {
'Accept': '*/*',
'Content-Type': 'application/json',
'Authorization':
      'key=AAAAzsQxnK0:APA91bFQ26dK3zYyQRyFzXW57ozHAf0bXNAE7W23gJvcRSA1iPoINMDPTXdTpm6lNGaIN3OLywuYrkzlIgFnEhkPnJHxvvWDvZkerYQQ_f8W_kKkNPQK-vz2BwG2nlmzelMHLVBRVUDs'
};
// ignore: non_constant_identifier_names
var url ;
url= Uri.parse('https://fcm.googleapis.com/fcm/send');
var body = {
"to":"/topics/allUsersThree",
"notification": {"title": title, "body": message}
};

var req =http.Request('POST', url);

req.headers.addAll(headersList);

req.body=json.encode(body);

var res=await req.send();

final resBody=await res.stream.bytesToString();

if (res.statusCode >= 200 && res.statusCode < 300) {

print(resBody);
EasyLoading.dismiss();
snackBar('تم ارسال الاشعار', context);
} else {

print(res.reasonPhrase);
EasyLoading.dismiss();
snackBar('لم يتم ارسال الاشعار', context);

}}
