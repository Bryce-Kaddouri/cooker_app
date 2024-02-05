import 'dart:collection';

import 'package:cooker_app/src/features/category/model/category_model.dart';
import 'package:cooker_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:cooker_app/src/features/product/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderProvider with ChangeNotifier {
  OrderGetOrdersByDateUseCase orderGetOrdersByDateUseCase;

  OrderProvider({
    required this.orderGetOrdersByDateUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  List<ProductModel> _allProductOfSelectedDate = [];
  List<ProductModel> get allProductOfSelectedDate => _allProductOfSelectedDate;
  void setAllProductOfSelectedDate(List<ProductModel> value) {
    _allProductOfSelectedDate = value;
    notifyListeners();
  }

  List<ProductModel> getAllProductOfSelectedDate(List<OrderModel> orderList) {
    final dataSet = HashSet<ProductModel>(
      // or LinkedHashSet
      equals: (a, b) => a.id == b.id,
      hashCode: (a) => a.id.hashCode,
    )..addAll(orderList.expand((e) => e.cart.map((e) => e.product)));

    List<ProductModel> lstProducts = dataSet.toList();

    return lstProducts;
  }

  List<CategoryModel> getAllCategoryOfSelectedDate(List<OrderModel> orderList) {
    final dataSet = HashSet<CategoryModel>(
      // or LinkedHashSet
      equals: (a, b) => a.id == b.id,
      hashCode: (a) => a.id.hashCode,
    )..addAll(orderList.expand((e) => e.cart.map((e) => e.product.category!)));

    List<CategoryModel> lstCategory = dataSet.toList();

    return lstCategory;
  }

  Future<DateTime?> chooseDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) _selectedDate = picked;
    notifyListeners();
  }

  Future<List<OrderModel>> getOrdersByDate(DateTime date) async {
    List<OrderModel> orderList = [];
    final result = await orderGetOrdersByDateUseCase.call(date);

    await result.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      print(r);
      orderList = r;
    });

    print('order list from provider');
    print(orderList.length);

    return orderList;
  }
}
