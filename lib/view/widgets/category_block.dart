import 'package:flutter/material.dart';

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({Key? key}) : super(key: key);

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
                "https://images.pexels.com/photos/2676096/pexels-photo-2676096.jpeg?auto=compress&cs=tinysrgb&w=1600",
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
          const Positioned(
            left: 30,
            top: 15,
            child: Text("Cars",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500
            ),),
          )
        ],
      ),
    );
  }
}
