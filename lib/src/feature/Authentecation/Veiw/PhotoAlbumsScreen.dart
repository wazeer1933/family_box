import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/EventsFamli/View/ImagesLayaout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoAlbumsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
           IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: () {Get.back();},
          ),
        ],
        title: Text(
          'ألبومات صور العائلة ',
          style: AppTextStyles.titleStylePageSize,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine grid layout based on screen width
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 4; // Larger screens, e.g., iPads in landscape
          } else if (constraints.maxWidth > 800) {
            crossAxisCount = 3; // Medium screens, e.g., iPads in portrait
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('actions').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('لا يتوفر صور للعائلة'));
              }

              final images = snapshot.data!.docs;

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Dynamic column count
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final dataid = images[index];
                  final data = images[index].data() as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () {
                      if (data['imageUrl'] != null) {
                        Get.to(ImageLayout(udiDoc: dataid.id));
                      }
                    },
                    child: AlbumCard(
                      title: data['title'] ?? 'No Title',
                      image: data['imageUrl'] ?? '',
                      photoCount: '',
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final String title;
  final String image;
  final String photoCount;

  const AlbumCard({
    required this.title,
    required this.image,
    required this.photoCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          image.isNotEmpty
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey.shade200,
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.black38,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    photoCount,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
