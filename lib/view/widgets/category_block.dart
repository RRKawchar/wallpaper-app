import 'package:flutter/material.dart';
import 'package:my_wallpaper/view/screens/category_details_screen.dart';

class CategoryBlock extends StatelessWidget {
  String categoryName;
  String categoryImgSrc;
  CategoryBlock(
      {Key? key, required this.categoryName, required this.categoryImgSrc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryDetailsScreen(
                    catImgUrl: categoryImgSrc, catName: categoryName)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                height: 80,
                width: MediaQuery.of(context).size.width,
                categoryImgSrc,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.37,
              top: 25,
              child: Center(
                child: Text(
                  categoryName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
