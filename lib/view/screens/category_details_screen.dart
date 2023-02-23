import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/models/photos_model.dart';
import 'package:my_wallpaper/service/api_service.dart';
import 'package:my_wallpaper/view/screens/full_screen.dart';
import 'package:my_wallpaper/view/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDetailsScreen extends StatefulWidget {
  String catName;
  String catImgUrl;

  CategoryDetailsScreen(
      {super.key, required this.catImgUrl, required this.catName});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  late List<PhotosModel> categoryResults;
  bool isLoading = true;

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

  GetCatRelWall() async {
    categoryResults = await ApiService.searchWallpaper(widget.catName);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    GetCatRelWall();
    getAndroidDeviceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        // appBar: AppBar(
        //   centerTitle: true,
        //   elevation: 0.0,
        //   backgroundColor: Colors.white,
        //   title:
        // ),
        body: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Android Large - 1 (2).png"),
              fit: BoxFit.cover)),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(
                        width: 100,
                      ),
                      CustomAppBar(
                        text1: "Wallpaper",
                        text2: "App",
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Image.network(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        widget.catImgUrl),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black38,
                    ),
                    Positioned(
                      left: 145,
                      top: 45,
                      child: Column(
                        children: [
                          const Text("Category",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                          Text(
                            widget.catName,
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 700,
                    child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 400,
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                        itemCount: categoryResults.length,
                        itemBuilder: ((context, index) => GridTile(
                              child: InkWell(
                                onTap: () async{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyFullScreen(
                                                imageUrl: categoryResults[index]
                                                    .url,
                                            id: categoryResults[index].id.toString(),
                                            deviceId: deviceId,
                                              )));
                                  SharedPreferences preferences =await SharedPreferences.getInstance();
                                  preferences.setString('deviceId', deviceId);
                                },
                                child: Hero(
                                  tag: categoryResults[index].url,
                                  child: Container(
                                    height: 800,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.amberAccent,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                          height: 800,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          categoryResults[index].url),
                                    ),
                                  ),
                                ),
                              ),
                            ))),
                  ),
                )
              ],
            ),
    ));
  }
}
