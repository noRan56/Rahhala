class PostModel {
  final String imageUrl;
  final String placeName;
  final String description;
  final String cityName;
  final String username;
  final String imagePath;
  final String createdAt;

  PostModel({
    required this.imageUrl,
    required this.placeName,
    required this.description,
    required this.cityName,
    required this.username,
    required this.imagePath,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      imageUrl: map['image_url'],
      placeName: map['place_name'],
      description: map['description'],
      cityName: map['city_name'],
      username: map['username'],
      imagePath: map['image'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image_url': imageUrl,
      'place_name': placeName,
      'description': description,
      'city_name': cityName,
      'username': username,
      'image': imagePath,
      'created_at': createdAt,
    };
  }
}
