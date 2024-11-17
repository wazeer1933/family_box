import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Chat/ChatSecreenUser.dart';
import 'package:family_box/src/feature/Chat/PageDetilesGroups.dart';
import 'package:family_box/src/feature/Chat/contollers/controllerSendChats.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatScreenGroups extends StatelessWidget {
  final String chatId;
  final String userId;
  final String? name;
  final String? image;

  ChatScreenGroups({required this.chatId, required this.userId, this.name, this.image});
  final ChatController1 con = Get.put(ChatController1());
  List<String>? fileUrls;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:   Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(PageDetailsGroups(uidDoc: chatId));
              },
              child: CircleAvatar(radius: 40, backgroundImage: NetworkImage(image ?? "")),
            ),
          ),
automaticallyImplyLeading: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        
        ],
        title: Center(child: Text(name ?? "", style: TextStyle(color: AppColors().darkGreen))),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Cahts')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    var messageData = message.data() as Map<String, dynamic>;

                    bool isMe = messageData['senderId'] == userId;
                    bool isRead = messageData['isRead'];

                    if (!isRead && !isMe) {
                      con.markMessageAsRead(message.id);
                    }

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(messageData['senderId'])
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return SizedBox.shrink();
                        }
                        
                        var senderData = userSnapshot.data!.data() as Map<String, dynamic>;
                        String senderName = senderData['name'] ?? 'Unknown';
                        String senderImage = senderData['image'] ?? 'Unknown';
                        String senderUid = senderData['uid'];

                        return MessageTile(
                          senderImage: senderImage,
                          senderName: senderName,
                          senderId: senderUid,
                          message: messageData['message'],
                          isMe: isMe,
                          isRead: isRead,
                          attachments: messageData['attachments'] ?? [],
                          timestamp: messageData['timestamp']??Timestamp.now(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          GetBuilder<ChatController1>(builder: (con) => _buildMessageInput()),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          if (fileUrls != null && fileUrls!.isNotEmpty)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors().grayshade300,
              ),
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: fileUrls!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.network(fileUrls![index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ),
          SizedBox(height: 2),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: () async {
                  List<String>? uploadedFiles = await con.pickAndUploadFiles();
                  if (uploadedFiles != null && uploadedFiles.isNotEmpty) {
                    fileUrls = uploadedFiles;
                    con.update();
                  }
                },
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.end,
                  controller: con.messageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors().grayshade300,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    hintText: '... اكتب رسالة',
                    hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors().darkGreen),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().darkGreen)),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  String message = con.messageController.text.trim();
                  if (fileUrls != null && fileUrls!.isNotEmpty) {
                    con.sendMessage(message, fileUrls!);
                  } else if (message.isNotEmpty) {
                    con.sendMessage(message, []);
                  }
                  fileUrls = null;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String senderName;
  final String message;
  final String senderImage;
  final String senderId;
  final bool isMe;
  final bool isRead;
  final List<dynamic> attachments;
  final Timestamp timestamp;

  MessageTile({
    required this.senderImage,
    required this.senderName,
    required this.message,
    required this.isMe,
    required this.isRead,
    required this.attachments,
    required this.senderId,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  senderName,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, fontStyle: FontStyle.italic, color: AppColors().darkGreen),
                ),
              ),
            if (attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: buildAttachments(context),
              ),
            Row(
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe)
                  GestureDetector(
                    onTap: () => Get.to(DetailsProfileScreen(senderId)),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(senderImage),
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person),
                    ),
                  ),
                BubbleSpecialThree(
                  text: message,
                  textStyle: TextStyle(fontStyle: FontStyle.italic, color: AppColors().white, fontWeight: FontWeight.w700),
                  color: isMe ? AppColors().darkGreen : Colors.grey[400]!,
                  tail: true,
                  isSender: isMe,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMe)
                  Icon(isRead ? Icons.done_all : Icons.done, size: 16, color: isRead ? Colors.blue : Colors.grey),
                SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    _formatTime(timestamp.toDate()),
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttachments(BuildContext context) {
    if (attachments.length > 1) {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: attachments.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImagePage(imageUrl: attachments[index]),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors().grayshade300,
                  ),
                  child: Image.network(attachments[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenImagePage(imageUrl: attachments[0]),
            ),
          ),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors().grayshade300,
            ),
            width: MediaQuery.of(context).size.width * 0.70,
            child: Image.network(attachments[0], fit: BoxFit.cover),
          ),
        ),
      );
    }
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute}";
  }
}

// class FullScreenImagePage extends StatelessWidget {
//   final String imageUrl;

//   FullScreenImagePage({required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 1.0,
//           maxScale: 4.0,
//           child: Image.network(imageUrl),
//         ),
//       ),
//     );
//   }
// }
