class PhotosModel {
  String imgSrc;
  String photoName;
  int id;

  PhotosModel({required this.imgSrc, required this.photoName,required this.id});

  static PhotosModel fromApi2App(Map<String, dynamic> photos) {
    return PhotosModel(
      imgSrc: (photos['src'])['portrait'],
      photoName: photos['photographer'],
      id: photos['id'],
    );
  }
}
