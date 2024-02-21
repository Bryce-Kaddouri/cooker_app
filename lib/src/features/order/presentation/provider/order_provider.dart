import 'dart:collection';

import 'package:cooker_app/src/features/category/model/category_model.dart';
import 'package:cooker_app/src/features/order/business/param/getOrdersParam.dart';
import 'package:cooker_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:cooker_app/src/features/product/data/model/product_model.dart';
import 'package:flutter/material.dart';

import '../../business/param/changeIsDoneCartByIdParam.dart';
import '../../business/param/changeStatusOrderByIdParam.dart';
import '../../business/param/getOrderByIdParam.dart';
import '../../business/usecase/change_is_done_cart_by_id_usecase.dart';
import '../../business/usecase/change_status_order_by_id_usecase.dart';
import '../../business/usecase/order_get_order_by_id_usecase.dart';

class OrderProvider with ChangeNotifier {
  OrderGetOrdersByDateUseCase orderGetOrdersByDateUseCase;
  OrderGetOrderByIdUseCase orderGetOrdersByIdUseCase;
  OrderChangeStatusOrderByIdUseCase changeStatusOrderByIdUseCase;
  OrderChangeIsDoneCartByIdUseCase changeIsDoneCartByIdUseCase;

  OrderProvider({
    required this.orderGetOrdersByDateUseCase,
    required this.orderGetOrdersByIdUseCase,
    required this.changeStatusOrderByIdUseCase,
    required this.changeIsDoneCartByIdUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<ProductModel> _allProductOfSelectedDate = [];
  List<ProductModel> get allProductOfSelectedDate => _allProductOfSelectedDate;
  void setAllProductOfSelectedDate(List<ProductModel> value) {
    _allProductOfSelectedDate = value;
    notifyListeners();
  }

  List<OrderModel> _orderList = [];
  List<OrderModel> get orderList => _orderList;
  void setOrderList(List<OrderModel> value) {
    _orderList = value;
    notifyListeners();
  }

  void resetOrderList() {
    _orderList = [];
    notifyListeners();
  }

  void addOrder(OrderModel value) {
    _orderList.add(value);
    notifyListeners();
  }

  void removeOrder(OrderModel value) {
    _orderList.remove(value);
    notifyListeners();
  }

  void updateOrder(OrderModel value) {
    int index = _orderList.indexWhere((element) => element.id == value.id);
    _orderList[index] = value;
    notifyListeners();
  }

  void addAllOrder(List<OrderModel> value) {
    _orderList.addAll(value);
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

  Future<DateTime?> chooseDate(BuildContext context, DateTime currentDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      currentDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      keyboardType: TextInputType.datetime,


    );
    return picked;
  }

  Future<List<OrderModel>> getOrdersByDate(
      DateTime date, SortType sortType, bool isAscending) async {
    print('------------ call getOrdersByDate ----------------');
    List<OrderModel> orderList = [];
    GetOrdersParam param = GetOrdersParam(
        date: date, sortType: sortType, isAscending: isAscending);
    final result = await orderGetOrdersByDateUseCase.call(param);

    await result.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      orderList = r;
    });

    return orderList;
  }

  Future<OrderModel?> getOrderById(int id, DateTime date) async {
    print('------------ call getOrderById ----------------');
    OrderModel? order;
    final result = await orderGetOrdersByIdUseCase
        .call(GetOrderByIdParam(id: id, date: date));
    await result.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      order = r;
    });
    print('order: $order');
    return order;
  }

  Future<bool> changeOrderStatus(int id, DateTime date, int step) async {
    print('------------ call changeOrderStatus ----------------');
    bool result = false;
    final changeStatusOrderByIdParam = ChangeStatusOrderByIdParam(
      id: id,
      date: date,
      step: step,
    );
    final response =
        await changeStatusOrderByIdUseCase.call(changeStatusOrderByIdParam);
    await response.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      result = r;
    });
    return result;
  }

  Future<bool> changeIsDoneCart(int cartId, int orderId, int productId,
      DateTime date, bool isDone) async {
    print('------------ call changeIsDoneCart ----------------');
    bool result = false;
    final param = ChangeIsDoneCartByIdParam(
      date: date,
      orderId: orderId,
      cartId: cartId,
      productId: productId,
      isDone: isDone,
    );
    final response = await changeIsDoneCartByIdUseCase.call(param);
    await response.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      result = r;
    });
    return result;
  }
}
