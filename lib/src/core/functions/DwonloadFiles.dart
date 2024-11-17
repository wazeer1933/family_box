import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> saveImage(BuildContext context, String imageUrl) async {
  // Request storage permission
  if (await Permission.storage.request().isGranted) {
    // Show progress indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.green),
            const SizedBox(width: 10),
            Expanded(child: Text("...يتم التحميل")),
          ],
        ),
      ),
    );

    try {
      // Open HTTP client to download image
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(imageUrl));
      HttpClientResponse response = await request.close();

      // Check for successful response
      if (response.statusCode == HttpStatus.ok) {
        // Get external storage directory
        Directory? directory = await getExternalStorageDirectory();
        String imagePath = '${directory!.path}/DownloadedImage.jpg';
        
        // Write image to file
        File file = File(imagePath);
        await response.pipe(file.openWrite());

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم التحميل: $imagePath")),
        );
      } else {
        _snackBarError('لم يتم التحميل - خطأ في التحميل', context);
      }
    } catch (e) {
      _snackBarError('لم يتم التحميل - ${e.toString()}', context);
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Storage permission is required to save the image."),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Helper function to show error snackbar
void _snackBarError(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}


















// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<void> saveImage(BuildContext context, String imageUrl) async {
//   // Request storage permission
//   if (await Permission.storage.request().isGranted) {
//     // Show progress indicator
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             CircularProgressIndicator(color: Colors.green),
//             const SizedBox(width: 10),
//             Expanded(child: Text("...يتم التحميل")),
//           ],
//         ),
//       ),
//     );

//     try {
//       // Download image
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         final Uint8List bytes = response.bodyBytes;

//         // Save image to gallery
//         final result = await ImageGallerySaver.saveImage(bytes);
        
//         if (result['isSuccess']) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("تم حفظ الصورة في المعرض")),
//           );
//         } else {
//           _snackBarError('لم يتم التحميل - خطأ في الحفظ', context);
//         }
//       } else {
//         _snackBarError('لم يتم التحميل - خطأ في التحميل', context);
//       }
//     } catch (e) {
//       _snackBarError('لم يتم التحميل - ${e.toString()}', context);
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Storage permission is required to save the image."),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }

// // Helper function to show error snackbar
// void _snackBarError(String message, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(message), backgroundColor: Colors.red),
//   );
// }
