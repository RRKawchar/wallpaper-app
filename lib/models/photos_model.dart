class PhotosModel {
  String imgSrc;
  String photoName;

  PhotosModel({required this.imgSrc, required this.photoName});

  static PhotosModel fromApi2App(Map<String, dynamic> photos) {
    return PhotosModel(
      imgSrc: (photos['src'])['portrait'],
      photoName: photos['photographer'],
    );
  }
}
