import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/models/photos_model.dart';
import 'package:my_wallpaper/service/api_service.dart';
import 'package:my_wallpaper/view/screens/full_screen.dart';
import 'package:my_wallpaper/view/widgets/build_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BikesScreen extends StatefulWidget {
  @override
  _BikesScreenState createState() => _BikesScreenState();
}

class _BikesScreenState extends State<BikesScreen> {
   Future<List<PhotosModel>>? _photoList;

  late String deviceId;

  Future<void> getAndroidDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = "${androidInfo.device}" + "${androidInfo.id}";
      print('Android Device ID: $deviceId');
    } catch (e) {
      print('Failed to get Android device ID: $e');
      deviceId = '';
    }
  }

  @override
  void initState() {
    _photoList = ApiService.bikesPhoto();
    getAndroidDeviceId();
    //GetCatDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _photoList==null?Center(child: CircularProgressIndicator(),):FutureBuilder<List<PhotosModel>>(
        future: ApiService.bikesPhoto(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: Text(""),);
          }else{
            final photoList=snapshot.data;
            // var rndItem = snapshot.data!.shuffle();
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics:const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      mainAxisExtent: 220),
                  itemCount: photoList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // build each item in the grid here
                    return Stack(
                      children: [
                        InkWell(
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyFullScreen(
                                    imageUrl: photoList[index]
                                        .url
                                        .toString(),
                                    id: photoList[index]
                                        .id
                                        .toString(),
                                    deviceId: deviceId,
                                  ),
                                ),
                              );
                              SharedPreferences preferences =await SharedPreferences.getInstance();
                              preferences.setString('deviceId', deviceId);
                            },
                            child: BuildImage(
                              size: MediaQuery.of(context).size,
                              imgUrl: photoList[index].url.toString(),
                            )
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            photoList[index].photographer.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            );

          }

        });
  }
}