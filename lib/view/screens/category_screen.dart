import 'package:flutter/material.dart';
import 'package:my_wallpaper/models/category_model.dart';
import 'package:my_wallpaper/service/api_service.dart';
import 'package:my_wallpaper/view/widgets/category_block.dart';
import 'package:my_wallpaper/view/widgets/custom_app_bar.dart';
import 'package:my_wallpaper/view/widgets/search_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<CategoryModel>? categoryList;
  bool isLoading = true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

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
   GetCatDetails();
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
      //   title: CustomAppBar(
      //     text1: "Wallpaper",
      //     text2: "App",
      //   ),
      // ),
      body: Container(
        padding:const EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/Android Large - 1 (2).png"),fit: BoxFit.cover)
        ),
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
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                key: _refreshIndicatorKey,
                onRefresh: () {
                  setState(() {});
                  return ApiService.fetchCuratedPhotos();
                },
                child: FutureBuilder(
                    future: ApiService.fetchCuratedPhotos(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }else{
                        var rndItem = snapshot.data!.shuffle();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          // margin: const EdgeInsets.symmetric(vertical: 20),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: categoryList!.length,
                                itemBuilder: (context, index) {
                                  return  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: CategoryBlock(
                                      categoryImgSrc: categoryList![index].catImgUrl,
                                      categoryName: categoryList![index].catName,
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      )

      // SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Stack(
      //         children: [
      //           Image.network(
      //               height: 150,
      //               width: MediaQuery.of(context).size.width,
      //               fit: BoxFit.cover,
      //               "https://images.unsplash.com/photo-1589802829985-817e51171b92?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Nnx8fGVufDB8fHx8&w=1000&q=80"),
      //           Container(
      //             height: 150,
      //             width: MediaQuery.of(context).size.width,
      //             color: Colors.black38,
      //           ),
      //           Positioned(
      //           left: 125,
      //             top: 40,
      //             child: Column(
      //               children: const [
      //                 Text("Category",
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.w300,
      //                   fontSize: 15,
      //                   color: Colors.white
      //                 ),
      //                 ),
      //                 Text("Maintains",style: TextStyle(
      //                   fontSize: 30,fontWeight: FontWeight.w600,
      //                   color: Colors.white
      //                 ),)
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //
      //        const SizedBox(height: 10,),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: SizedBox(
      //           height: MediaQuery.of(context).size.height,
      //           child: GridView.builder(
      //             physics: const BouncingScrollPhysics(),
      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 3,
      //                 crossAxisSpacing: 10.0,
      //                 mainAxisSpacing: 10.0,
      //                 mainAxisExtent: 220),
      //             itemCount: 20,
      //             itemBuilder: (BuildContext context, int index) {
      //               // build each item in the grid here
      //               return Container(
      //                 decoration: BoxDecoration(
      //                     color: Colors.amberAccent,
      //                     borderRadius: BorderRadius.circular(20)),
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(20),
      //                   child: Image.network(
      //                     "https://images.pexels.com/photos/3786092/pexels-photo-3786092.jpeg?auto=compress&cs=tinysrgb&w=1600",
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
