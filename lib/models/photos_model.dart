class PhotosModel {
  final int id;
  final String photographer;
  final String url;

  PhotosModel({required this.id,required this.photographer,required this.url});

  factory PhotosModel.fromJson(Map<String,dynamic> json){
    return PhotosModel(
        id: json['id'],
        photographer: json['photographer'],
        url: json['src']['portrait'],
    );
  }
}
