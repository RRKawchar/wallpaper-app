import 'package:flutter/material.dart';
import 'package:my_wallpaper/view/screens/search_screen.dart';

class SearchBar extends StatelessWidget {
  SearchBar({Key? key}) : super(key: key);
 final TextEditingController _searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFFF1EFEFFF)),
      child: Row(
        children:  [
            Expanded(
            child: TextField(
              controller: _searchController,
              decoration:const InputDecoration(
                hintText: "Search Wallpapers",
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
           InkWell(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(query: _searchController.text)));
            },
            child: const Icon(Icons.search),
          )
        ],
      ),
    );
  }
}
