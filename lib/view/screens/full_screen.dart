// import 'package:flutter/material.dart';
//
//
// class MyFullScreen extends StatelessWidget {
//   String imageUrl;
//    MyFullScreen({Key? key,required this.imageUrl}) : super(key: key);
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: ElevatedButton(
//         onPressed: (){
//           // setWallpaperFromFile(imageUrl, context);
//         },
//         child:const Text("Set Wallpaper"),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(
//               imageUrl
//             ),
//             fit: BoxFit.cover
//           )
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyFullScreen extends StatefulWidget {
  String imageUrl;
  String id;
  MyFullScreen({Key? key, required this.imageUrl,required this.id}) : super(key: key);

  @override
  _MyFullScreenState createState() => _MyFullScreenState();
}

class _MyFullScreenState extends State<MyFullScreen> {
  var deviceId = '';
  Future<String> getAndroidDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin =  DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId ="${androidInfo.device}"+"${androidInfo.id}";
      print('Android Device ID: $deviceId');
    } catch (e) {
      print('Failed to get Android device ID: $e');
    }
    return deviceId;
  }

///emu64xaTRA4.220822.001.C4
///emu64xaTRA4.220822.001.C4

  // Future<void> _setWallpaper() async {
  //   if (widget.imageBytes == null) {
  //     return;
  //   }
  //
  //   final status = await Permission.storage.request();
  //   if (status != PermissionStatus.granted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Permission to access storage denied.'),
  //       ),
  //     );
  //     return;
  //   }
  //
  //   final tempDir = await getTemporaryDirectory();
  //   final tempPath = '${tempDir.path}/wallpaper.jpg';
  //   final file = await File(tempPath).writeAsBytes(widget.imageBytes.toList());
  //
  //   final result = await WallpaperManager.setWallpaperFromFile(file.path, WallpaperManager.HOME_SCREEN);
  //   if (result) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Wallpaper set successfully!'),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to set wallpaper.'),
  //       ),
  //     );
  //   }
  // }
  // Future<void> _saveImageToGallery() async {
  //   if (widget.imageBytes == null) {
  //     return;
  //   }
  //
  //   final status = await Permission.storage.request();
  //   if (status != PermissionStatus.granted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Permission to access storage denied.'),
  //       ),
  //     );
  //     return;
  //   }
  //
  //   final result = await ImageGallerySaver.saveImage(widget.imageBytes);
  //   if (result != null && result['isSuccess']) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Image saved to gallery successfully!'),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to save image to gallery.'),
  //       ),
  //     );
  //   }
  // }
  //
  // Future<void> _shareImage() async {
  //   if (widget.imageBytes == null) {
  //     return;
  //   }
  //
  //   final tempDir = await getTemporaryDirectory();
  //   final tempPath = '${tempDir.path}/image.jpg';
  //   final file = await File(tempPath).writeAsBytes(widget.imageBytes);
  //
  //   await Share.shareFiles([file.path]);
  // }

  Future<void> _downloadImage() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Downloading Started...")));
    http.Response response = await http.get(Uri.parse(widget.imageUrl));
    File file = File('${(await getTemporaryDirectory()).path}/image.png');
    await file.writeAsBytes(response.bodyBytes);

    // Update message to show successful download
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Downloaded Sucessfully"),
      action: SnackBarAction(label: "Open", onPressed: _openImage),
    ));
  }

  Future<void> _openImage() async {
    Directory tempDir = await getTemporaryDirectory();

    await OpenFile.open('${tempDir.path}/image.png');
  }

   void saveFavoriteImage(String imageUrl, String userId) {
     // Get a reference to the "FavoriteImages" collection in Firestore.
     CollectionReference favoritesRef = FirebaseFirestore.instance.collection('FavoriteImages');

     // Create a new document in the collection.
     DocumentReference newFavoriteRef = favoritesRef.doc();

     // Set the fields for the new document.
     newFavoriteRef.set({
       'imageUrl': imageUrl,
       'userId': userId,
     });
   }

  // void addDocumentWithCustomID(String imageUrl, String userId) {
  //   FirebaseFirestore.instance.collection('myCollection')
  //       .doc(deviceId)
  //       .set({
  //     'imageUrl': imageUrl,
  //     'userId': userId,
  //   })
  //       .then((value) => print("Document added with ID: myDocumentId"))
  //       .catchError((error) => print("Failed to add document: $error"));
  // }


  @override
  Widget build(BuildContext context) {
    getAndroidDeviceId();
    CollectionReference favoritesRef = FirebaseFirestore.instance.collection('FavoriteImages');
    Query query = favoritesRef;

    print("This is image id : ${widget.id}");
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: _downloadImage,
          child: const Text('Download Image'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Hero(
          tag: widget.imageUrl,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('FavoriteImages').where('userId',isEqualTo: widget.id).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> favoriteImageDocs = snapshot.data!.docs;
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    right: 10,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: (){
                            saveFavoriteImage(widget.imageUrl, widget.id);
                          },
                            icon:favoriteImageDocs.length==0?const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 30,
                            ):const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )),
                        const SizedBox(height: 5),
                        const Text(
                          "12",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Icon(
                          Icons.arrow_circle_up_sharp,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          ),
        ));
  }
}
