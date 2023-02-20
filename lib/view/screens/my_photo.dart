// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
//
// class ImageApi {
//   static Future<Uint8List> getImageFromApi() async {
//     final response = await http.get(Uri.parse('https://source.unsplash.com/random'));
//     if (response.statusCode == 200) {
//       return response.bodyBytes;
//     } else {
//       throw Exception('Failed to load image from API.');
//     }
//   }
// }
//
// class ImageDisplay extends StatefulWidget {
//   final Uint8List imageBytes;
//
//   const ImageDisplay({Key? key, required this.imageBytes}) : super(key: key);
//
//   @override
//   _ImageDisplayState createState() => _ImageDisplayState();
// }
//
// class _ImageDisplayState extends State<ImageDisplay> {
//   Future<void> _setWallpaper() async {
//     if (widget.imageBytes == null) {
//       return;
//     }
//
//     final status = await Permission.storage.request();
//     if (status != PermissionStatus.granted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Permission to access storage denied.'),
//         ),
//       );
//       return;
//     }
//
//     final tempDir = await getTemporaryDirectory();
//     final tempPath = '${tempDir.path}/wallpaper.jpg';
//     final file = await File(tempPath).writeAsBytes(widget.imageBytes);
//
//     final result = await WallpaperManager.setWallpaperFromFile(file.path, WallpaperManager.HOME_SCREEN);
//     if (result) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Wallpaper set successfully!'),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to set wallpaper.'),
//         ),
//       );
//     }
//   }
//
//   Future<void> _saveImageToGallery() async {
//     if (widget.imageBytes == null) {
//       return;
//     }
//
//     final status = await Permission.storage.request();
//     if (status != PermissionStatus.granted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Permission to access storage denied.'),
//         ),
//       );
//       return;
//     }
//
//     final result = await ImageGallerySaver.saveImage(widget.imageBytes);
//     if (result != null && result['isSuccess']) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Image saved to gallery successfully!'),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save image to gallery.'),
//         ),
//       );
//     }
//   }
//
//   Future<void> _shareImage() async {
//     if (widget.imageBytes == null) {
//       return;
//     }
//
//     final tempDir = await getTemporaryDirectory();
//     final tempPath = '${tempDir.path}/image.jpg';
//     final file = await File(tempPath).writeAsBytes(widget.imageBytes);
//
//     await Share.shareFiles([file.path]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Display'),
//       ),
//       body: Center(
//         child: widget.imageBytes != null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.memory(widget.imageBytes),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _setWallpaper,
//               child: Text('Set as Wallpaper'),
//             ),
//             ElevatedButton(
//               onPressed: _saveImageToGallery,
//               child: Text('Save to Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: _shareImage,
//               child: Text('Share'),
//             ),
//           ],
//         )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
