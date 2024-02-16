import 'package:flutter/material.dart';

import '../../../cart/model/cart_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../employee/model/model/user_model.dart';
import '../../../status/model/status_model.dart';

class OrderTableModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final TimeOfDay time;
  final int customerId;
  final double amountPaid;
  final int statusId;
  final String userId;

  OrderTableModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.time,
    required this.customerId,
    required this.amountPaid,
    required this.statusId,
    required this.userId,
  });

  factory OrderTableModel.fromJson(Map<String, dynamic> json) {
    return OrderTableModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      ),
      customerId: json['customer_id'],
      amountPaid: json['amount_paid'],
      statusId: json['status_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'date': date.toIso8601String(),
        'time': '${time.hour}:${time.minute}',
        'customer_id': customerId,
        'amount_paid': amountPaid,
        'status_id': statusId,
        'user_id': userId,
      };
}

class OrderModel {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final TimeOfDay time;

  final CustomerModel customer;
  final StatusModel status;
  final UserModel user;

  final List<CartModel> cart;

  double totalAmount;
  int nbTotalItemsCart;

  OrderModel({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.time,
    required this.customer,
    required this.status,
    required this.user,
    required this.cart,
    this.totalAmount = 0.0,
    required this.nbTotalItemsCart,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<CartModel> cart =
        List<CartModel>.from(json['cart'].map((x) => CartModel.fromJson(x)));

    return OrderModel(
      id: json['order_id'],
      createdAt: DateTime.parse(json['order_created_at']),
      updatedAt: DateTime.parse(json['order_updated_at']),
      date: DateTime.parse(json['order_date']),
      time: TimeOfDay(
        hour: int.parse(json['order_time'].split(':')[0]),
        minute: int.parse(json['order_time'].split(':')[1]),
      ),
      /*json['order_is_paid'],*/
      customer: CustomerModel.fromJson(json['customer']),
      status: StatusModel.fromJson(json['status']

      ),
      user: UserModel.fromJson(json['user']),
      cart: cart,
      totalAmount: json['total_amount'],
      nbTotalItemsCart: json['nb_items_cart'],
    );
  }

  toStringForSearch() {
    return '#$id ${time.hour}:${time.minute} ${customer.fName.toLowerCase()} ${customer.fName.toLowerCase()} ${status.name.toLowerCase()}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'date': date.toIso8601String(),
        'time': '${time.hour}:${time.minute}',
        'customer': customer.toJson(),
         'status': status.toJson(),
        'user': user.toJson(),
        'cart': cart.map((e) => e.toJson()).toList(),
      };
}
