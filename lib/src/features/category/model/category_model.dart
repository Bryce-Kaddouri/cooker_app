class CategoryModel {
  final int id;
  final String name;
  final String description;
  final String photoUrl;
  final bool isVisible;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.isVisible,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['category_id'],
        name: json['category_name'],
        description: json['category_description'],
        photoUrl: json['category_photo_url'],
        isVisible: json['category_is_visible'],
      );

  factory CategoryModel.fromJsonTable(Map<String, dynamic> json) => CategoryModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    photoUrl: json['photo_url'],
    isVisible: json['is_visible'],
  );


  Map<String, dynamic> toJson() => {
        'category_id': id,
        'category_name': name,
        'category_description': description,
        'category_photo_url': photoUrl,
        'category_is_visible': isVisible,
      };
}
