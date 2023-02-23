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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFullScreen extends StatefulWidget {
  String imageUrl;
  String id;
  String deviceId;
  MyFullScreen({Key? key, required this.imageUrl, required this.id,required this.deviceId})
      : super(key: key);

  @override
  _MyFullScreenState createState() => _MyFullScreenState();
}

class _MyFullScreenState extends State<MyFullScreen> {

  // Future<void> _downloadImage() async {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text("Downloading Started...")));
  //   http.Response response = await http.get(Uri.parse(widget.imageUrl));
  //   File file = File('${(await getTemporaryDirectory()).path}/image.png');
  //   await file.writeAsBytes(response.bodyBytes);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: const Text("Downloaded Sucessfully"),
  //     action: SnackBarAction(label: "Open", onPressed: _openImage),
  //   ));
  // }
  //
  // Future<void> _openImage() async {
  //   Directory tempDir = await getTemporaryDirectory();
  //
  //   await OpenFile.open('${tempDir.path}/image.png');
  // }
  Future addToFavourite(String imageUrl, String imageId) async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    preferences.setString('deviceId', widget.deviceId);
    print("Device id store in locally ${preferences.getString('deviceId')}");
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("FavoriteImages");
    return _collectionRef.doc(widget.deviceId).collection("favourite").doc().set({
      'imageUrl': imageUrl,
      'imageId': imageId,
    }).then((value) => print("Added to favourite"));
  }
  // void saveFavoriteImage(String imageUrl, String imageId) {
  //   FirebaseFirestore.instance
  //       .collection('FavoriteImages')
  //       .doc(deviceId)
  //       .set({
  //         'imageUrl': imageUrl,
  //         'imageId': imageId,
  //       })
  //       .then((value) => print("Document added with ID: myDocumentId"))
  //       .catchError((error) => print("Failed to add document: $error"));
  // }

  // void saveFavoriteImage(String imageUrl, String userId) {
  //   CollectionReference favoritesRef =
  //       FirebaseFirestore.instance.collection('FavoriteImages');
  //   DocumentReference newFavoriteRef = favoritesRef.doc();
  //   newFavoriteRef.set({
  //     'imageUrl': imageUrl,
  //     'userId': userId,
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    CollectionReference favoritesRef =
        FirebaseFirestore.instance.collection('FavoriteImages');
    Query query = favoritesRef;

    print("This is image id : ${widget.id}");
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            _showWallpaperOptions(widget.imageUrl);
          },
          child: const Text('set wallpaper'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Hero(
            tag: widget.imageUrl,
            child: Stack(
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
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('FavoriteImages')
                              .doc(widget.deviceId)
                              .collection('favourite')
                              .where('imageId', isEqualTo: widget.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.data==null){
                              return const Center(child: CircularProgressIndicator(),);
                            }
                            return IconButton(
                                onPressed: () =>
                                snapshot.data!.docs.length==0? addToFavourite(widget.imageUrl, widget.id): ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text("Already added..."))),
                                icon: snapshot.data!.docs.length==0?const Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                  size: 30,
                                ):const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30,
                                )
                                // snapshot.data!.docs.length == 0
                                //     ? const Icon(
                                //   Icons.favorite_border,
                                //   color: Colors.red,
                                //   size: 30,
                                // )
                                //     :
                                );
                          }),
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
            )

            // StreamBuilder(
            //     stream: FirebaseFirestore.instance
            //         .collection('FavoriteImages')
            //         .doc(deviceId)
            //         .collection('favourite')
            //         .where('imageId', isEqualTo: widget.id)
            //         .snapshots(),
            //       builder: (context, snapshot) {
            //         if(snapshot.data==null){
            //           return const Text("");
            //         }
            //     return Stack(
            //       children: [
            //         Container(
            //           height: MediaQuery.of(context).size.height,
            //           width: MediaQuery.of(context).size.width,
            //           decoration: BoxDecoration(
            //             image: DecorationImage(
            //               image: NetworkImage(
            //                 widget.imageUrl,
            //               ),
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //         Positioned(
            //           bottom: 40,
            //           right: 10,
            //           child: Column(
            //             children: [
            //               IconButton(
            //                   onPressed: ()=>snapshot.data!.docs.length == 0? addToFavourite(widget.imageUrl, widget.id):"Already added...",
            //                   icon: snapshot.data!.docs.length == 0
            //                       ? const Icon(
            //                     Icons.favorite_border,
            //                     color: Colors.red,
            //                     size: 30,
            //                   )
            //                       : const Icon(
            //                     Icons.favorite,
            //                     color: Colors.red,
            //                     size: 30,
            //                   )),
            //               const SizedBox(height: 5),
            //               const Text(
            //                 "12",
            //                 style: TextStyle(fontSize: 20, color: Colors.white),
            //               ),
            //               const SizedBox(
            //                 height: 20,
            //               ),
            //               const Icon(
            //                 Icons.arrow_circle_up_sharp,
            //                 color: Colors.white,
            //                 size: 30,
            //               )
            //             ],
            //           ),
            //         )
            //       ],
            //     );
            //   }
            // ),
            // StreamBuilder<QuerySnapshot>(
            //     stream: FirebaseFirestore.instance
            //         .collection('FavoriteImages')
            //         .where('imageId', isEqualTo: widget.id)
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //
            //       List<DocumentSnapshot> favoriteImageDocs = snapshot.data!.docs;
            //       return Stack(
            //         children: [
            //           Container(
            //             height: MediaQuery.of(context).size.height,
            //             width: MediaQuery.of(context).size.width,
            //             decoration: BoxDecoration(
            //               image: DecorationImage(
            //                 image: NetworkImage(
            //                   widget.imageUrl,
            //                 ),
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           ),
            //           Positioned(
            //             bottom: 40,
            //             right: 10,
            //             child: Column(
            //               children: [
            //                 IconButton(
            //                     onPressed: () {
            //                       addToFavourite(widget.imageUrl, widget.id);
            //                     },
            //                     icon: favoriteImageDocs.length == 0
            //                         ? const Icon(
            //                             Icons.favorite_border,
            //                             color: Colors.red,
            //                             size: 30,
            //                           )
            //                         : const Icon(
            //                             Icons.favorite,
            //                             color: Colors.red,
            //                             size: 30,
            //                           )),
            //                 const SizedBox(height: 5),
            //                 const Text(
            //                   "12",
            //                   style: TextStyle(fontSize: 20, color: Colors.white),
            //                 ),
            //                 const SizedBox(
            //                   height: 20,
            //                 ),
            //                 const Icon(
            //                   Icons.arrow_circle_up_sharp,
            //                   color: Colors.white,
            //                   size: 30,
            //                 )
            //               ],
            //             ),
            //           )
            //         ],
            //       );
            //     }),
            ));
  }

  void _showWallpaperOptions(String imageUrl) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Set as home screen'),
                onTap: () async {
                  int location = WallpaperManager.HOME_SCREEN;
                  var file =
                      await DefaultCacheManager().getSingleFile(imageUrl);
                  bool result = await WallpaperManager.setWallpaperFromFile(
                      file.path, location);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Set as lock screen'),
                onTap: () async {
                  int location = WallpaperManager.LOCK_SCREEN;
                  var file =
                      await DefaultCacheManager().getSingleFile(imageUrl);
                  bool result = await WallpaperManager.setWallpaperFromFile(
                      file.path, location);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.smartphone),
                title: const Text('Set as both'),
                onTap: () async {
                  int location = WallpaperManager.BOTH_SCREEN;
                  var file =
                      await DefaultCacheManager().getSingleFile(imageUrl);
                  bool result = await WallpaperManager.setWallpaperFromFile(
                      file.path, location);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
