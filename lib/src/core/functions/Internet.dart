import 'dart:io';

class InternetChecker {
  static const _checkInterval = Duration(seconds: 0);

  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet connection is available
      } else {
        return false; // No internet connection
      }
    } on SocketException catch (_) {
      return false; // No internet connection
    }
  }

  static Stream<bool> internetConnectionStream() async* {
    while (true) {
      yield await checkInternetConnection();
      await Future.delayed(_checkInterval);
    }
  }
}