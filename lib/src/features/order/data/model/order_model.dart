import 'dart:convert';

import 'package:flutter/material.dart';


import '../../../cart/model/cart_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../employee/model/model/user_model.dart';
import '../../../status/model/status_model.dart';

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

  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
   /* List<dynamic> cart =
        json['cart']['cart_items'];
    print(cart);
    String cartString = cart.toString();
    var test = jsonEncode(cart);
    print(test);
    var test2 = jsonDecode(test);*/
   /* print('*' * 50);
    print(test2);*/

    /*List<Map<String, dynamic>> jsonCart =
        json['cart']['cart_items'].cast<Map<String, dynamic>>();

*/



    return OrderModel(
      id: json['order_id'],
      createdAt: DateTime.parse(json['order_created_at']),
      updatedAt: DateTime.parse(json['order_updated_at']),
      date: DateTime.parse(json['order_date']),
      time: TimeOfDay(
        hour: 11,
        minute: 30,
      ),
      /*json['order_is_paid'],*/
     customer: CustomerModel.fromJson(json['customer']),
      status: StatusModel.fromJson(json['status']),
      user: UserModel.fromJson(json['user']),

      cart: List<CartModel>.from(json['cart'].map((x) => CartModel.fromJson(x))),

    );
  }



  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'date': date.toIso8601String(),
        'time': '${time.hour}:${time.minute}',
        'customer': customer.toJson(),
    /* 'status': status.toJson(),
        'user': user.toJson(),
        'cart': cart.map((e) => e.toJson()).toList(),*/
      };
}
