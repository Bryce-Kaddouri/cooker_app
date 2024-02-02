
import '../../../category/model/category_model.dart';

class ProductModelForOrder {
  final int id;
  final String name;

  final String photoUrl;
  final double price;
  final CategoryModel category;

  ProductModelForOrder({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.price,
    required this.category,
  });

  factory ProductModelForOrder.fromJson(Map<String, dynamic> json) =>
      ProductModelForOrder(
        id: json['product_id'],
        name: json['product_name'],
        photoUrl: json['product_photo_url'],
        price: json['product_price'],
        category: CategoryModel.fromJson(json['category_info']),
      );

  Map<String, dynamic> toJson() => {
        'product_id': id,
        'product_name': name,
        'product_photo_url': photoUrl,
        'product_price': price,
        'category_info': category.toJson(),
      };
}
