import 'package:flutter/material.dart';

class CategoryBlock extends StatelessWidget {
  String categoryName;
  String categoryImgSrc;
   CategoryBlock({Key? key,required this.categoryName,required this.categoryImgSrc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              height: 50,
              width: 100,
              categoryImgSrc,
            fit: BoxFit.cover,),
          ),
          Container(
            height: 50,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12)
            ),
          ),
           Positioned(
            left: 30,
            top: 15,
            child: Text(categoryName,style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500
            ),),
          )
        ],
      ),
    );
  }
}
