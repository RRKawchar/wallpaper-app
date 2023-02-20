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

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart'as http;

class MyFullScreen extends StatefulWidget {
  String imageUrl;
  MyFullScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _MyFullScreenState createState() => _MyFullScreenState();
}

class _MyFullScreenState extends State<MyFullScreen> {


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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: _downloadImage,
          child: const Text('Download Image'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Hero(
          tag: widget.imageUrl,
          child: Container(
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
        )
        );
  }
}
