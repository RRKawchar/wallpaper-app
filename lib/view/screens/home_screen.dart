import 'package:flutter/material.dart';
import 'package:my_wallpaper/models/category_model.dart';
import 'package:my_wallpaper/models/photos_model.dart';
import 'package:my_wallpaper/service/api_service.dart';
import 'package:my_wallpaper/view/screens/full_screen.dart';
import 'package:my_wallpaper/view/widgets/build_image.dart';
import 'package:my_wallpaper/view/widgets/custom_app_bar.dart';
import 'package:my_wallpaper/view/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PhotosModel>? photosList;
  List<CategoryModel>? categoryList;
  bool isLoading = true;

  GetCatDetails() async {
    categoryList = await ApiService.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(categoryList);
    setState(() {
      categoryList = categoryList;
    });
  }

  getWallpaper() async {
    photosList = await ApiService.getWallpaper();
    setState(() {
      isLoading = false;
    });
  }


  @override
  void initState() {
    getWallpaper();
    //GetCatDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   elevation: 0.0,
      //   backgroundColor: Colors.black26,
      //   automaticallyImplyLeading: false,
      //
      //   title: CustomAppBar(
      //     text1: "Wallpaper",
      //     text2: "App",
      //   ),
      // ),
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
            // FutureBuilder(
            //     future: ApiOperation.getWallpaper(),
            //     builder: (context,snapshot){
            //   if(snapshot.connectionState==ConnectionState.waiting){
            //     return const Center(child: CircularProgressIndicator(),);
            //   }else{
            //     return Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       margin: const EdgeInsets.symmetric(vertical: 20),
            //       child: SizedBox(
            //         height: 50,
            //         width: MediaQuery.of(context).size.width,
            //         child: ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             itemCount: categoryList!.length,
            //             itemBuilder: (context, index) {
            //               return  CategoryBlock(
            //                 categoryImgSrc: categoryList![index].catImgUrl,
            //                 categoryName: categoryList![index].catName,
            //               );
            //             }),
            //       ),
            //     );
            //   }
            // }),

            Expanded(
              child: SingleChildScrollView(
                child: photosList == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FutureBuilder(
                        future: ApiService.getWallpaper(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 5.0,
                                        mainAxisExtent: 220),
                                itemCount: photosList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // build each item in the grid here
                                  return Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyFullScreen(
                                                imageUrl: photosList![index]
                                                    .imgSrc
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: BuildImage(size: MediaQuery.of(context).size,imgUrl: photosList![index].imgSrc.toString(),)
                                        
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
                                          photosList![index]
                                              .photoName
                                              .toString(),
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
                        }),
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
