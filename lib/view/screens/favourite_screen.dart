import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_wallpaper/view/widgets/build_image.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CollectionReference favoritesRef = FirebaseFirestore.instance.collection('FavoriteImages');
    Query query = favoritesRef;
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<DocumentSnapshot> favoriteImageDocs = snapshot.data!.docs;
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                mainAxisExtent: 220),
            itemCount: favoriteImageDocs.length,
            itemBuilder: (context,index){
              String imageUrl = favoriteImageDocs[index]['imageUrl'];

              return BuildImage(size: MediaQuery.of(context).size,imgUrl: imageUrl);

            }
        );


        //   ListView.builder(
        //   itemCount: favoriteImageDocs.length,
        //   itemBuilder: (context, index) {
        //     // Extract the image URL from the favorite image document.
        //     String imageUrl = favoriteImageDocs[index]['imageUrl'];
        //
        //     // Display the image using a NetworkImage widget.
        //     return Image.network(imageUrl);
        //   },
        // );
      },
    );
  }
}
