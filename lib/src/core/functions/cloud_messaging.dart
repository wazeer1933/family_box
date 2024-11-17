import 'dart:convert';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    // Replace this JSON data with the contents of your actual service account JSON file as a Map
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "familybox-23dc1",
      "private_key_id": "a2e540f58192ea9b30dd6154ce9e919c4118238b",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCIHKUILVwg6+Xf\n1Ck1Wwrq+Rbi/hYC01ODdwLbxij4Fa9zY4Q6eIhzkNLtf9w1o16YjE4+igGK+M66\nFp1kGVciOfYQBIE7yTveWXVXSupChEhF+XPf0XLzdBIJcGiCxFNFjzpor9fvh33j\nvm9ELNT0q+bydd04WnlNHEyG3rSgQ1w+qpGNlGuuekFuqHc5vjF4A0QTbjdrgsY9\ne82RPkCBoK1dIBb4u+RaMUSjiGjAyjl6IO8sMIHOXFwFG/OIKxXyAxxSP2Dl34UM\nbRkaSNVDoq3FhN0LtOaqpsHGAU/YVpZzilEIeX+j1N9BpI9g++Vz0Ebti13/fBww\nDqfwcDORAgMBAAECggEAAVf/DRidizmo+E+45Gz0q6Mv5afKgdaiQW8AWTkYmHJm\nXAZEfOtJtZJdcrjLbMAjI/BmqVllcIDKUa39ecqCQLU/x6Kzv+pZq/VIIkd8DpIN\nwJsY2MHRl7OypeM1NO1JQSuL0RLDV/sHdCMiKBMlOxEjY4tkVrUV83vvCXnTYK2l\n4OktnKnpX8hAqoJD14m6JtCFxucltHIo68pS/WqtlY8cGwPlN0IAGWlbgzAXCMuf\nhdQoHFg09uTDvncs9tb2eWRb+w8FmUt/sYnvVsvqyMpJo+7ObOOvRaCrFSwKjv99\n/XEXrVw4u2SNeuXDdqHoIzDgF1zvV0epHMR9nPrAAQKBgQC8MGF/yuoQO10PSYfb\nj87JyGhbwUWItRYStbjknwfyyOnfPIJusW6vnGnt/ZzSo+SZyp/TvBADCnvJgGY7\nj4NfpxP4nRp3+oOHUOfpJwLEUvnDIFRSIFGWoYAkzfFauZFS7Fijz1TIn+xaux1D\nv5N42qmPas9EiFoqzSrH7TRvkQKBgQC5KGCaVHYdDfg4kfbsdXszPi0SfVEyPJxu\ns/rJZRamQiIqRQRw0uNrk6gcRL3/AusJjAVJIz2nFX4xfNQD7zAYR3BgecrVAqpW\nvm/ejEwqxkteGCdM61grgqVXyh2EVopQNzxQD6NLJjgZHsQWDtzXyWsOdtqu8cpY\nF3lJ3eWEAQKBgQCheEGwDMNYuhbXDxhq47FioXopgGPRMM+HrjS+tVV0k79Xs+uW\nXtfCBks90OXGNqnm61zHqA11DoG4G1ucrz7hy9Hu953GZESGznyuKLLPEQMM0aiH\n7wMSY/A3pBz64042AGTt6O+uVMnP78zkXHSEtdnXHKZK/1OedfvHH1hmgQKBgGlx\njyIUe3csX3GH3oDmnpSeEfj3mOftEIESyf0rLmzcOKytxUujLZQz8Ia4tyKkvMkh\nDlmKUi/203jHR849xrvs4xhuA46vB+aCaR7p8u5hIsahJrBtTjbpHdQS7CBTUE1C\nR3yoiyvexg+4L58IM8hHkkoYcY0zcTIdnBru3SgBAoGAWiJLuq2s5OqVBffb6hAF\naKsETKpV6DzO6EvNcyYBNqePd4NFo/UhV+PU6NYgVnwNFIix+S7nPq7u5Jra86eM\n5Ypok+PR65Yz22XxPByrkRGX7JLCq9t0h6owchVP8GBLBTOq/ET24r69wuuElZs9\nh5RODq0z2mYIAcuYAvQl9ck=\n-----END PRIVATE KEY-----\n",
      "client_email": "famli-alhaidan@familybox-23dc1.iam.gserviceaccount.com",
      "client_id": "116235409613250019789",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/famli-alhaidan%40familybox-23dc1.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    final List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      final auth.ServiceAccountCredentials credentials = 
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

      final auth.AuthClient client = await auth.clientViaServiceAccount(credentials, scopes);
      final accessToken = client.credentials.accessToken.data;

      client.close();

      return accessToken;
    } catch (e) {
      print('Failed to obtain access token: $e');
      rethrow;
    }
  }

  static Future<void> sendNotificationToTopic(
    List topics,
    String messageSender,
    String messageBody,
    String IdSender,
    String type,
String? doc,context
  ) async {
    try {
      final String serverAccessTokenKey = await getAccessToken();
      final String endPointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/familybox-23dc1/messages:send';
for(var topic in topics){
      final Map<String, dynamic> message = {
        'message': {
          'topic': topic,
          'notification': {'title': messageSender, 'body': messageBody,},
          'data': {
            'IdSender':IdSender,
            'type': type,
            'doc':doc
          }
        }
      };

      final http.Response response = await http.post(
        Uri.parse(endPointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Notification sent to topic "$topics" successfully');
      } else {
        print('Failed to send notification to topic: ${response.statusCode}, ${response.body}');
      }
    snackBar('تم ارسال الاشعار بنجاح', context);
    Get.back();
        EasyLoading.dismiss();
      
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
