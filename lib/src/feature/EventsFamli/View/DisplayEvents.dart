import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/feature/Dashbord/controllers/controllerAddActions.dart';
import 'package:family_box/src/feature/Donations/Veiw/PageDetilesProject.dart';
import 'package:family_box/src/feature/EventsFamli/SharingActionsUsers.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/EventsFamli/View/ImagesLayaout.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class DisplayEvents extends StatefulWidget {
  final String? uidDoc;
  
  const DisplayEvents({super.key, this.uidDoc});

  @override
  State<DisplayEvents> createState() => _DisplayEventsState();
}

final controllerAddCations controllerAddAction = Get.put(controllerAddCations());

class _DisplayEventsState extends State<DisplayEvents> {
  GoogleMapController? mapController;
  Marker? _eventMarker;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  //  late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    controllerAddAction.getCount(widget.uidDoc);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('actions')
              .doc(widget.uidDoc)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No data found"));
            }
        
            var data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data == null) {
              return const Center(child: Text("Invalid data"));
            }
        
            double latitude = double.tryParse(data['latitude']?.toString() ?? '0') ?? 0;
            double longitude = double.tryParse(data['longitude']?.toString() ?? '0') ?? 0;
            String title = data['title'] ?? 'Unknown';
        
            _eventMarker = Marker(
              markerId: const MarkerId('event_marker'),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: title),
            );
        
            return Stack(
              children: [
                    // Positioned(right: 10,child: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors().darkGreen,size: 30,))),

                Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                        latitude!=0?  GoogleMap(
                            onMapCreated: onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(latitude, longitude),
                              zoom: 20,
                            ),
                            markers: _eventMarker != null ? {_eventMarker!} : {},
                          ):GestureDetector(onTap: ()=>Get.to(FullScreenImage(imageUrl: data['imageUrl'])),
                          child: Image.network('${data['imageUrl']}',fit: BoxFit.cover,)),
                          Positioned(top: 20,right: 10,
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon:  Icon(Icons.arrow_forward_ios_outlined,color: AppColors().darkGreen,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: _buildEventDetails(context, data),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context, Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors().lighBrown,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildEventHeader(data),
          Expanded(
            child: _buildEventContent(context, data),
          ),
        ],
      ),
    );
  }

  Widget _buildEventHeader(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    '${data['nameMonth']} ${data['Year']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${data['day']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                '${data['address']}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventContent(BuildContext context, Map<String, dynamic> data) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildEventTitleSection(data),
            const SizedBox(height: 20),
            _buildParticipantsSection(data),
            const SizedBox(height: 10),
             Text(
              'وصف النشاط',
              style: TextStyle(
                fontSize: 16,
                color: AppColors().darkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${data['actionsDescription']}',
              style: TextStyle(fontSize: 17, color: Colors.black),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            _buildContributorsSection(context),
            const SizedBox(height: 10),
           data['actionsType']=='فعالية'? _buildJoinButton():Container(height: 50,width: double.infinity,child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().darkGreen,
        ),
            onPressed: (){
              Get.to(ImageLayout(udiDoc: widget.uidDoc));
            }, child: Text("معرض صور الحدث",style: TextStyle(fontWeight: FontWeight.bold,color: AppColors().white),))),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTitleSection(Map<String, dynamic> data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${data['title']}',
              style: TextStyle(
                fontSize: 17,
                color: AppColors().darkGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.to(ImageLayout(udiDoc: widget.uidDoc));
              },
              child: Row(
                children: [
                  Text(
                    '...المزيد من الصور',
                    style: TextStyle(
                      fontSize: 16,decoration: TextDecoration.underline,
                      color: AppColors().blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 80,
          width: 90,
          child: GestureDetector(onTap: ()=>Get.to(FullScreenImage(imageUrl: data['imageUrl'])),
            child: Image.network(
              "${data['imageUrl']}",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection(data) {
    return GetBuilder<controllerAddCations>(builder: (controller) {
      return data['actionsType']=='فعالية'? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          controller.count! > 0
              ? GestureDetector(
                  onTap: () {
                    Get.to(SharingActionsUsers(uiddoc: '${widget.uidDoc}'));
                  },
                  child: CircleAvatar(radius: 30,backgroundColor: AppColors().grayshade300,
                    child: Center(
                      child: Text("${controller.count! - 5}+"),
                    ),
                  ),
                )
              :  SizedBox(),
          DonationImagesWidget(uiddoc: widget.uidDoc.toString()),
        ],
      ):SizedBox(height: 10,);
    });
  }

  Widget _buildContributorsSection(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      if(currentUserData[0]['isAdmin']==true)  TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _buildImagePickerDialog(),
            );
          },
          child: const Text(
            "تحميل صور",
            style: TextStyle(
              fontSize: 17,decoration: TextDecoration.underline,
              fontWeight: FontWeight.w700,
              color: Color(0xFF006400),
            ),
          ),
        ),
      ],
    );
  }




AlertDialog _buildImagePickerDialog() {
  return AlertDialog(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => controllerAddAction.pickImages(),
          icon: Icon(Icons.image, size: 30, color: AppColors().darkGreen),
        ),
        Text(
          "اختار صور وفيديوهات من المعرض",
          style: AppTextStyles.titleStyle,
        ),
      ],
    ),
    content: SizedBox(
      width: double.maxFinite,
      height: 300,
      child: Obx(() {
        if (controllerAddAction.selectedImages.isEmpty) {
          return const Center(child: Text('لم يتم اختيار اي صورة أو فيديو'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: controllerAddAction.selectedImages.length,
            itemBuilder: (context, index) {
              final file = controllerAddAction.selectedImages[index];
              final isVideo = file.path.endsWith('.mp4'); // Adjust for your video file types

              if (isVideo) {
                final videoController = VideoPlayerController.file(file);

                // Initialize the video controller before using it in the widget
                return FutureBuilder(
                  future: videoController.initialize(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      videoController.setLooping(true);
                      videoController.pause();
                      return AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: GestureDetector(
                        onTap: () {
                          if (videoController.value.isPlaying) {
                            videoController.pause();  // Pause the video if it's currently playing
                          } else {
                            videoController.play();   // Play the video if it's currently paused
                          }
                        },
                        child: VideoPlayer(videoController),
                      ),
                    );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              } else {
                return Image.file(
                  file,
                  fit: BoxFit.cover,
                );
              }
            },
          );
        }
      }),
    ),
    actions: [
      Expanded(
        child: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          minWidth: double.infinity,
          color: AppColors().darkGreen,
          height: 45,
          onPressed: () {
            Get.back();
            controllerAddAction.uploadImagesToFirebase();
          },
          child: const Text(
            'حفظ',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}








  Widget _buildJoinButton() {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().darkGreen,
        ),
        onPressed: () {
          if (!controllerAddAction.IsFounduser) {
            showDialog(
              context: context,
              builder: (context) => _buildJoinConfirmationDialog(),
            );
          }
        },
        child: GetBuilder<controllerAddCations>(
          builder: (controller) => Text(
            controller.IsFounduser == false
                ? 'بدء الرغبة لذهاب'
                : controller.SharinIsAcsept == false && controller.IsFounduser == true
                    ? 'الطلب تحت الانتظار'
                    : controller.SharinIsAcsept == true && controller.IsFounduser == true
                        ? 'تم الموافقة للانظمام'
                        : 'الم يتم الموافقة للانظمام',
            style: TextStyle(fontSize: 16, color: AppColors().white),
          ),
        ),
      ),
    );
  }

  AlertDialog _buildJoinConfirmationDialog() {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        height: 70,
        child: Center(
          child: Text(
            "هل لديك الرغبة للانطمام فعلا ",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors().darkGreen,
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: 70,
              height: 40,
              color: Colors.red,
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "الغاء",
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: 70,
              height: 40,
              color: AppColors().darkGreen,
              onPressed: () {
                controllerAddAction.addActionSharingUsers();
              },
              child: const Text(
                "نعم",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
