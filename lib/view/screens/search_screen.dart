import 'package:flutter/material.dart';
import 'package:my_wallpaper/models/photos_model.dart';
import 'package:my_wallpaper/service/api_service.dart';
import 'package:my_wallpaper/view/main_screen/main_screen.dart';
import 'package:my_wallpaper/view/widgets/custom_app_bar.dart';
import 'package:my_wallpaper/view/widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  String query;
  SearchScreen({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PhotosModel>? searchList;
  // getSearchWallpaper() async {
  //   searchList = await ApiOperation.searchWallpaper(widget.query);
  //   setState(() {});
  // }

  Future<void> getSearchWallpaper() async {
    try {
      List<PhotosModel>? result =
          await ApiService.searchWallpaper(widget.query);
      setState(() {
        searchList = result;
      });
    } catch (error) {
      print('Error while fetching search wallpaper data: $error');
      // You can set the default value to an empty list, or null, depending on your use case
      setState(() {
        searchList = [];
      });
    }
  }

  @override
  void initState() {
    getSearchWallpaper();
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
        leading: IconButton(
          onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainScreen()));
          },
          icon:const Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar()),
            searchList == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
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
                        itemCount: searchList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // build each item in the grid here
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                searchList![index].imgSrc.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
