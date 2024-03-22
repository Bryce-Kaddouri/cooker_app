import '../../product/data/model/product_model.dart';

class CartModel {
  final int? id;
  int quantity;
  bool isDone;
  final ProductModel product;
  final DateTime orderDate;
  final int orderId;

  CartModel({
    this.id,
    required this.quantity,
    required this.isDone,
    required this.product,
    required this.orderDate,
    required this.orderId,
  });

  factory CartModel.fromJson(Map<String, dynamic> json, {required int orderId, required DateTime orderDate}) => CartModel(
        id: json['cart_id'],
        quantity: json['quantity'],
        isDone: json['is_done'],
        product: ProductModel.fromJson(json['product_info']),
        orderDate: orderDate,
        orderId: orderId,
      );

  Map<String, dynamic> toJson() => {
        'cart_id': id,
        'quantity': quantity,
        'is_done': isDone,
        'product_info': product.toJson(),
      };
}
