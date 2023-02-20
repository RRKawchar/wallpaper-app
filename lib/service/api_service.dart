import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:my_wallpaper/models/category_model.dart';
import 'package:my_wallpaper/models/photos_model.dart';

class ApiService {
  static List<PhotosModel> photoList = [];
  static List<PhotosModel> searchList=[];
  static List<CategoryModel> categoryList=[];
  static Future<List<PhotosModel>> getWallpaper() async {
    await http.get(Uri.parse("http://api.pexels.com/v1/curated"), headers: {
      "Authorization":
          "OeAOSL55vHEcGUTq4GzZXNu8Lm2wGzt3VMITXV2OJtS6rBRMndsgbPOl"
    }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      for (var element in photos) {
        photoList.add(PhotosModel.fromApi2App(element));
      }
      print(photoList[0].imgSrc);
    });

    return photoList;
  }

 static Future<List<PhotosModel>> searchWallpaper(String query) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=30&page=1"),
        headers: {
          "Authorization":
              "OeAOSL55vHEcGUTq4GzZXNu8Lm2wGzt3VMITXV2OJtS6rBRMndsgbPOl"
        }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      searchList.clear();
      for (var element in photos) {
        searchList.add(PhotosModel.fromApi2App(element));
      }
      //print(searchList[0].imgSrc);
    });

    return searchList;
  }

  static List<CategoryModel> getCategoriesList() {
    List cateogryName = [
      "Cars",
      "Nature",
      "Bikes",
      "Street",
      "City",
      "Flowers",
      "Mosque",
      "House",
      "Bird"
      "village"
    ];
    categoryList.clear();
    cateogryName.forEach((catName) async {
      final random =  Random();

      PhotosModel photoModel =
      (await searchWallpaper(catName))[0 + random.nextInt(11 - 0)];
      print("IMG SRC IS HERE");
      print(photoModel.imgSrc);
      categoryList
          .add(CategoryModel(catImgUrl: photoModel.imgSrc, catName: catName));
    });

    return categoryList;
  }
}
