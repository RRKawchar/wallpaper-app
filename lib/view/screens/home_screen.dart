import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/models/category_model.dart';
import 'package:my_wallpaper/models/photos_model.dart';
import 'package:my_wallpaper/service/api_service.dart';
import 'package:my_wallpaper/view/screens/full_screen.dart';
import 'package:my_wallpaper/view/widgets/build_image.dart';
import 'package:my_wallpaper/view/widgets/custom_app_bar.dart';
import 'package:my_wallpaper/view/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PhotosModel>> _photoList;
  List<CategoryModel>? categoryList;
  bool isLoading = true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
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

  GetCatDetails() async {
    categoryList = await ApiService.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(categoryList);
    setState(() {
      categoryList = categoryList;
    });
  }

  @override
  void initState() {
    _photoList = ApiService.fetchCuratedPhotos();
    getAndroidDeviceId();
    //GetCatDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Android Large - 1 (2).png"),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAppBar(
                    text1: "Wallpaper",
                    text2: "App",
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar()),

            Expanded(
              child: SingleChildScrollView(
                child: RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    key: _refreshIndicatorKey,
                    onRefresh: () {
                      setState(() {});
                      return ApiService.fetchCuratedPhotos();
                    },
                  child: FutureBuilder<List<PhotosModel>>(
                      future: ApiService.fetchCuratedPhotos(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator(),);
                        }else{
                          final photoList=snapshot.data;
                          var rndItem = snapshot.data!.shuffle();
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height/1.3,
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
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

                                        // Container(
                                        //   height: MediaQuery.of(context)
                                        //       .size
                                        //       .height,
                                        //   decoration: BoxDecoration(
                                        //       color: Colors.amberAccent,
                                        //       borderRadius:
                                        //           BorderRadius.circular(20)),
                                        //   child: ClipRRect(
                                        //     borderRadius:
                                        //         BorderRadius.circular(20),
                                        //     child: Image.network(
                                        //       photosList![index]
                                        //           .imgSrc
                                        //           .toString(),
                                        //       fit: BoxFit.cover,
                                        //     ),
                                        //   ),
                                        // ),
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

                      }),
                ),
              ),
            ),

            // Container(
            //   height: 500,
            //   width: 100,
            //   child: GridView.builder(
            //     itemCount: 10,
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 3,
            //         crossAxisSpacing: 10.0,
            //         mainAxisSpacing: 10.0
            //       ), itemBuilder: (context,index){
            //         return Container(
            //           height: 500,
            //           width: 100,
            //           color: Colors.amberAccent,
            //         );
            //   }),
            // )
          ],
        ),
      ),
    );
  }
}
