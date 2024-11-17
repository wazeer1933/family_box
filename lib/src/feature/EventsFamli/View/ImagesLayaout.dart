import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/core/functions/functionCheckLink.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ImageLayout extends StatefulWidget {
  String? udiDoc;

  ImageLayout({super.key, this.udiDoc});
  @override
  _ImageLayoutState createState() => _ImageLayoutState();
}

bool found = true;

class _ImageLayoutState extends State<ImageLayout> {
  CollectionReference<Map<String, dynamic>> qure = FirebaseFirestore.instance.collection('actions');

  void qureyd() {
    qure.doc(widget.udiDoc).collection('images').get().then((value) {
      setState(() {
        found = value.docs.isNotEmpty;
      });
      print("======================================$found");
    });
  }

  @override
  void initState() {
    qureyd();
    print('===========================${widget.udiDoc}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
        ],
        title: Center(child: Text('المزيد من الصور والفيديوهات',style: AppTextStyles.titleStyle,)),
      ),
      body: found
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('actions')
                  .doc(widget.udiDoc)
                  .collection('images')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No images available'));
                }

                final images = snapshot.data!.docs;

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 3 : 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final imageUrl = images[index]['imageUrl'];
                    String? videoUrl;
                    if (!isImageUrl(images[index]['imageUrl'])) {
                      videoUrl = images[index]['imageUrl'];
                    }
                    final videoController = VideoPlayerController.network(videoUrl!);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImage(imageUrl: imageUrl),
                          ),
                        );
                      },
                      child: isImageUrl(imageUrl)
                          ? Hero(
                              tag: imageUrl,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Hero(
                              tag: videoUrl,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: FutureBuilder(
                                  future: videoController.initialize(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      videoController.setLooping(true);
                                      videoController.pause();
                                      return AspectRatio(
                                        aspectRatio: videoController.value.aspectRatio,
                                        child: Stack(
                                          children: [
                                            VideoPlayer(videoController),
                                            Positioned(
                                              
                                              child: Center(child: Icon(Icons.play_arrow, size: 30, color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ),
                            ),
                    );
                  },
                );
              },
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('actions').doc(widget.udiDoc).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data!.data() as Map<String, dynamic>;

                return Center(
                  child: Container(
                    width: double.infinity,
                    height: isTablet ? 500 : 300,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImage(imageUrl: data['imageUrl']),
                          ),
                        );
                      },
                      child: Hero(
                        tag: data['imageUrl'],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(data['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  String? video;
  bool? isImage;
  late VideoPlayerController videoController;

  @override
  void initState() {
    isImage = isImageUrl(widget.imageUrl);
    if (!isImage!) {
      video = widget.imageUrl;
      videoController = VideoPlayerController.network(video!);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!isImage!) videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: widget.imageUrl,
            child: isImage!
                ? Image.network(widget.imageUrl)
                : FutureBuilder(
                    future: videoController.initialize(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        videoController.setLooping(true);
                        videoController.play();
                        return AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: GestureDetector(
                            onTap: () {
                              if (videoController.value.isPlaying) {
                                videoController.pause();
                              } else {
                                videoController.play();
                              }
                            },
                            child: VideoPlayer(videoController),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
