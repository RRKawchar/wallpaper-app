import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/models/category_model.dart';
import 'package:my_wallpaper/models/photos_model.dart';
import 'package:my_wallpaper/service/api_service.dart';
import 'package:my_wallpaper/view/screens/home/all_photos_screen.dart';
import 'package:my_wallpaper/view/screens/home/bikes_screen.dart';
import 'package:my_wallpaper/view/screens/home/cars_screens.dart';
import 'package:my_wallpaper/view/screens/home/house_screens.dart';
import 'package:my_wallpaper/view/screens/home/natural_screen.dart';
import 'package:my_wallpaper/view/widgets/custom_app_bar.dart';

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
              child:  RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                key: _refreshIndicatorKey,
                onRefresh: () {
                  setState(() {});
                  return ApiService.fetchCuratedPhotos();
                },
                child:SingleChildScrollView(
                  child: Column(
                    children: [
                      AllPhotosScreen(),
                      NaturalScreen(),
                      CarsScreen(),
                      BikesScreen(),
                      HousesScreens()
                      // Api1(),
                      // Api2(),
                    ],
                  ),
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
