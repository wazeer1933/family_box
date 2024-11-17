// import 'dart:async';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// const String appId = '5e8019a1f142469cbd91f35288d53a58'; // Replace with your Agora App ID
// const String token = '007eJxTYOjf/3Gn4wWhN8IxEZozNDyOm5cnCx6TnCerdiujsqiZ/6ACg2mqhYGhZaJhmqGJkYmZZXJSiqVhmrGpkYVFiqlxoqlF2yKD9IZARgZBuxgWRgYIBPEFGNwSczNzKhUcc3IyEjNTEvMYGAAo0iDK'; // Replace with your generated token
// const String channelName = 'Family Allhaidan'; // Channel name for the video call

// class GroupCallVideo extends StatefulWidget {
//   const GroupCallVideo({Key? key}) : super(key: key);

//   @override
//   State<GroupCallVideo> createState() => _GroupCallVideoState();
// }

// class _GroupCallVideoState extends State<GroupCallVideo> {
//   late RtcEngine _engine;
//   final List<int> _remoteUids = [];
//   bool _localUserJoined = false;
//   bool _isMuted = false;
//   bool _isCameraFront = true;

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   Future<void> initAgora() async {
//     // Request permissions
//     await [Permission.microphone, Permission.camera].request();

//     // Initialize the Agora engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));

//     // Register event handlers
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("Local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("Remote user $remoteUid joined");
//           setState(() {
//             _remoteUids.add(remoteUid);
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//           debugPrint("Remote user $remoteUid left channel");
//           setState(() {
//             _remoteUids.remove(remoteUid);
//           });
//         },
//       ),
//     );

//     await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await _engine.enableVideo();
//     await _engine.startPreview();

//     await _engine.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(),
//     );
//   }

//   @override
//   void dispose() {
//     _dispose();
//     super.dispose();
//   }

//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }

//   // Toggle microphone mute
//   void _toggleMute() {
//     setState(() {
//       _isMuted = !_isMuted;
//     });
//     _engine.muteLocalAudioStream(_isMuted);
//   }

//   // Toggle camera between front and back
//   void _toggleCamera() {
//     setState(() {
//       _isCameraFront = !_isCameraFront;
//     });
//     _engine.switchCamera();
//   }

//   // Create UI with local and remote video views
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           FloatingActionButton(
//             onPressed: _toggleMute,
//             child: Icon(_isMuted ? Icons.mic_off : Icons.mic),
//           ),
//           FloatingActionButton(
//             onPressed: () {
//               _engine.leaveChannel();
//               Get.back();
//             },
//             backgroundColor: Colors.red,
//             child: const Icon(Icons.call_end),
//           ),
//           FloatingActionButton(
//             onPressed: _toggleCamera,
//             child: const Icon(Icons.switch_camera),
//           ),
//         ],
//       ),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Center(child: Text('مكالمة فيديو')),
//       ),
//       body: Stack(
//         children: [
//           // Display remote users' video
//           _remoteVideo(),
//           // Display local user's video
//           Positioned(
//             bottom: 100,
//             left: MediaQuery.of(context).size.width/3,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: _localUserJoined
//                     ? AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: _engine,
//                           canvas: const VideoCanvas(uid: 0),
//                         ),
//                       )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Display all remote users' video
//   Widget _remoteVideo() {
//     if (_remoteUids.isNotEmpty) {
//       return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Adjust the number of columns based on your UI
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//         ),
//         itemCount: _remoteUids.length,
//         itemBuilder: (context, index) {
//           return AgoraVideoView(
//             controller: VideoViewController.remote(
//               rtcEngine: _engine,
//               canvas: VideoCanvas(uid: _remoteUids[index]),
//               connection: const RtcConnection(channelId: channelName),
//             ),
//           );
//         },
//       );
//     } else {
//       return const Center(
//         child: Text(
//           'يتم انتظار انضمام الاخرين',
//           textAlign: TextAlign.center,
//         ),
//       );
//     }
//   }
// }
