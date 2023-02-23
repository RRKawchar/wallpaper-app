import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/view/screens/full_screen.dart';
import 'package:my_wallpaper/view/widgets/build_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String deviceId='';

  Future<void> getAndroidDeviceId() async {
   SharedPreferences preferences=await SharedPreferences.getInstance();
   setState(() {

     deviceId= (preferences.getString('deviceId')?? '');
   });
   print("This is Device id $deviceId");
  }

  @override
  void initState() {
    super.initState();
    getAndroidDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return deviceId.isEmpty?Center(child: CircularProgressIndicator(),):StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('FavoriteImages')
          .doc(deviceId)
          .collection('favourite')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Extract the list of favorite image documents from the snapshot.
        List<DocumentSnapshot> favoriteImageDocs = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              mainAxisExtent: 220),
          itemCount: favoriteImageDocs.length,
          itemBuilder: (context, index) {
            // Extract the image URL from the favorite image document.
            String imageUrl = favoriteImageDocs[index]['imageUrl'];
            String id=favoriteImageDocs[index]['imageId'];

            // Display the image using a NetworkImage widget.
            return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyFullScreen(imageUrl: imageUrl, id: id, deviceId: deviceId)));
                },
                child: BuildImage(size: MediaQuery.of(context).size, imgUrl: imageUrl));
          },
        );
      },
    );
  }
}
