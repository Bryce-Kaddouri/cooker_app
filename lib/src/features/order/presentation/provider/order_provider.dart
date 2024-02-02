import 'package:flutter/material.dart';
import 'package:cooker_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';

import '../../../cart/model/cart_model.dart';
import '../../../product/data/model/product_model.dart';

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

  int _orderQty = 1;
  int get orderQty => _orderQty;

  void setOrderQty(int value) {
    _orderQty = value;
    notifyListeners();
  }

  void decrementOrderQty() {
    if (_orderQty > 1) {
      _orderQty--;
      notifyListeners();
    }
  }

  void incrementOrderQty() {
    _orderQty++;
    notifyListeners();
  }

  ProductModel? _selectedProduct;
  ProductModel? get selectedProduct => _selectedProduct;

  void setSelectedProduct(ProductModel? value) {
    _selectedProduct = value;
    notifyListeners();
  }

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  void setCartList(List<CartModel> value) {
    _cartList = value;
    notifyListeners();
  }

  void addCartList(CartModel value) {
    _cartList.add(value);
    notifyListeners();
  }

  void removeCartList(CartModel value) {
    _cartList.remove(value);
    notifyListeners();
  }

  void clearCartList() {
    _cartList.clear();
    notifyListeners();
  }

  void updateQuantityCartList(int index, int quantity) {
    _cartList[index].quantity = quantity;
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    for (var element in _cartList) {
      total += element.quantity * element.product.price;
    }
    return total;
  }


}
