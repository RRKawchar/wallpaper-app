import 'package:flutter/material.dart';
import 'package:my_wallpaper/controller/api_operation.dart';
import 'package:my_wallpaper/models/category_model.dart';
import 'package:my_wallpaper/models/photos_model.dart';
import 'package:my_wallpaper/view/screens/full_screen.dart';
import 'package:my_wallpaper/view/widgets/category_block.dart';
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
    categoryList = await ApiOperation.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(categoryList);
    setState(() {
      categoryList = categoryList;
    });
  }
  getWallpaper() async {
    photosList = await ApiOperation.getWallpaper();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getWallpaper();
    GetCatDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: CustomAppBar(
          text1: "Wallpaper",
          text2: "App",
        ),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchBar()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList!.length,
                  itemBuilder: (context, index) {
                    return  CategoryBlock(
                      categoryImgSrc: categoryList![index].catImgUrl,
                      categoryName: categoryList![index].catName,
                    );
                  }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: ApiOperation.getWallpaper(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent: 220),
                          itemCount: photosList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            // build each item in the grid here
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyFullScreen(
                                            imageUrl: photosList![index]
                                                .imgSrc
                                                .toString())));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    photosList![index].imgSrc.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
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
    );
  }
}
