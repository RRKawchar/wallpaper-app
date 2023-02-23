import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class MyTestScreen extends StatefulWidget {
  const MyTestScreen({Key? key}) : super(key: key);

  @override
  State<MyTestScreen> createState() => _MyTestScreenState();
}

class _MyTestScreenState extends State<MyTestScreen> {

  var imageUrl="https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Column(
        children: [
         Container(
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           child: ClipRRect(

               child: Image.network(imageUrl,fit: BoxFit.cover,)),
         )


        ],
      ),

      floatingActionButton: ElevatedButton(
        onPressed: (){
          _showWallpaperOptions();
        },
        child:const Text("Set WallPaper"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  void _showWallpaperOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading:const Icon(Icons.home),
                title:const Text('Set as home screen'),
                onTap: ()async {
                  int location = WallpaperManager.HOME_SCREEN;
                  var file=await DefaultCacheManager().getSingleFile(imageUrl);
                  bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:const Icon(Icons.lock),
                title:const Text('Set as lock screen'),
                onTap: () async{
                  int location = WallpaperManager.LOCK_SCREEN;
                  var file=await DefaultCacheManager().getSingleFile(imageUrl);
                  bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:const Icon(Icons.smartphone),
                title:const Text('Set as both'),
                onTap: ()async {
                  int location = WallpaperManager.BOTH_SCREEN;
                  var file=await DefaultCacheManager().getSingleFile(imageUrl);
                  bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
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
