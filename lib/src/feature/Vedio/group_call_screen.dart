// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class VideoCallScreen extends StatefulWidget {
//   @override
//   _VideoCallScreenState createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   final _localRenderer = RTCVideoRenderer();
//   bool isUserFound = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeRenderer();
//     _startLocalStream();
//   }

//   Future<void> _initializeRenderer() async {
//     await _localRenderer.initialize();
//   }

//   Future<void> _startLocalStream() async {
//     final stream = await navigator.mediaDevices.getUserMedia({
//       'audio': true,
//       'video': true,
//     });
//     _localRenderer.srcObject = stream;
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Call')),
//       body: Stack(
//         children: [
//           RTCVideoView(_localRenderer),
//           if (!isUserFound)
//             Center(child: Text('No Users Found', style: TextStyle(fontSize: 18))),
//           // Add widget to display remote users here.
//         ],
//       ),
//     );
//   }
// }
