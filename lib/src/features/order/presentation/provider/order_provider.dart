import 'package:cooker_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:flutter/material.dart';

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
