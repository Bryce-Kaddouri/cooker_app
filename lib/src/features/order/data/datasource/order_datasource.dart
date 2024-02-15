import 'dart:async';

import 'package:cooker_app/src/features/category/model/category_model.dart';
import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:cooker_app/src/features/product/data/model/product_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../employee/model/model/user_model.dart';
import '../../../status/model/status_model.dart';
import '../model/order_model.dart';

enum Event { increment, decrement }

class CounterController {
  int counter = 0;
  // this will handle the change the change in value of counter
  final StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get counterSink => _counterController.sink;
  Stream<int> get counterStream => _counterController.stream;

  // we can directly use the counter sink from widget itself but to reduce the logic
  // from the UI files we are making use of one more controller that will listen to
  // button click events by user.

  final StreamController<Event> _eventController = StreamController<Event>();
  StreamSink<Event> get eventSink => _eventController.sink;
  Stream<Event> get eventStream => _eventController.stream;

  // NOTE: here we will use listener to listen the _eventController
  StreamSubscription? listener;
  CounterController() {
    listener = eventStream.listen((Event event) {
      switch (event) {
        case Event.increment:
          counter += 1;

          break;
        case Event.decrement:
          counter -= 1;
          break;
        default:
      }
      counterSink.add(counter);
    });
  }
  // dispose the listner to eliminate memory leak
  dispose() {
    listener?.cancel();
    _counterController.close();
    _eventController.close();
  }
}

class OrderDataSource {
  final _client = Supabase.instance.client;

  String getSortTypeString(SortType sortType) {
    switch (sortType) {
      case SortType.time:
        return 'order_time';
      case SortType.orderId:
        return 'order_id';
      case SortType.total:
        return 'total_amount';
      case SortType.customer:
        return 'customer_full_name';
      case SortType.items:
        return 'nb_items_cart';

      default:
        return 'order_time';
    }
  }

  /*StreamSubscription<List<OrderModel>> getOrdersStream(
      DateTime date, SortType sortType, bool isAscending) {
    var response = _client
        .from('all_orders_view')
        .stream(primaryKey: [
          'order_id',
          'order_date',
        ])
        .eq('order_date', date.toIso8601String())
        .order(getSortTypeString(sortType), ascending: isAscending);

    return response.listen((event) {
      print('response from getOrders');
      print(event);
    });
  }*/

  final streamController = StreamController<List<Map<String, dynamic>>>();

  StreamSubscription<List<Map<String, dynamic>>>? getOrdersStream(
      DateTime date, SortType sortType, bool isAscending) {
    var response = _client
        .from('all_orders_view')
        .stream(primaryKey: [
          'order_id',
          'order_date',
        ])
        .eq('order_date', date.toIso8601String())
        .order(getSortTypeString(sortType), ascending: isAscending);

    return response.listen((event) {
      print('response from getOrders from stream');
      print(event);
      streamController.sink.add(event);
    });
  }

  void dispose() {
    streamController.close();
  }

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      DateTime date, SortType sortType, bool isAscending) async {
    try {
      var response = await _client
          .from('all_orders_view')
          .select()
          .eq('order_date', date.toIso8601String())
          .order(getSortTypeString(sortType), ascending: isAscending);

      print('response from getOrders');
      print(response);
      for (var res in response) {
        print(res['customer_full_name']);
      }

      if (response.isNotEmpty) {
        List<OrderModel> orderList =
            response.map((e) => OrderModel.fromJson(e)).toList();
        print('order list');
        print(orderList);
        return Right(orderList);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting orders'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: error.message));
    } catch (e) {
      print(e);
      return Left(DatabaseFailure(errorMessage: 'Error getting orders'));
    }
  }

  Future<ProductModel?> getProductById(int id) async {
    try {
      Map<String, dynamic> response = await _client
          .from('products')
          .select('''
    *,
    categories:category_id ( * )
    ''')
          .eq('id', id)

          .single()

        ;
      print('response from getProductById');
      print(response);
      int productId = response['id'];
      String productName = response['name'];
      String productImageUrl = response['photo_url'];
      double productPrice = response['price'];
      CategoryModel productCategory = CategoryModel.fromJsonTable(response['categories']);
      ProductModel productModel = ProductModel(id: productId, name: productName, imageUrl: productImageUrl, price: productPrice, category: productCategory);

      return productModel;

    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> getUserById(String uid) async {
    try {
      List<Map<String, dynamic>> response = await _client
          .from('employees_view')
          .select()
          .eq('id', uid)
          .limit(1)
          .order('id', ascending: true);
      if (response.isNotEmpty) {
        UserModel userModel = UserModel.fromJson(response[0]);
        return userModel;
      } else {
        return UserModel(uid: '', fName: '', lName: '');
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return UserModel(uid: '', fName: '', lName: '');
    } catch (e) {
      return UserModel(uid: '', fName: '', lName: '');
    }
  }

  Future<CustomerModel> getCustomerById(int id) async {
    try {
      List<Map<String, dynamic>> response = await _client
          .from('customers')
          .select()
          .eq('id', id)
          .limit(1)
          .order('id', ascending: true);
      if (response.isNotEmpty) {
        CustomerModel customerModel =
            CustomerModel.fromJsonFromTable(response[0]);
        return customerModel;
      } else {
        return CustomerModel(
            id: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            fName: '',
            lName: '',
            phoneNumber: '');
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return CustomerModel(
          id: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          fName: '',
          lName: '',
          phoneNumber: '');
    } catch (e) {
      return CustomerModel(
          id: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          fName: '',
          lName: '',
          phoneNumber: '');
    }
  }

  Future<StatusModel> getStatusById(int id) async {
    try {
      List<Map<String, dynamic>> response = await _client
          .from('status')
          .select()
          .eq('id', id)
          .limit(1)
          .order('id', ascending: true);
      if (response.isNotEmpty) {
        StatusModel statusModel = StatusModel.fromJson(response[0]);
        return statusModel;
      } else {
        return StatusModel(id: 0, name: '', step: 1, color: Colors.red);
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return StatusModel(id: 0, name: '', step: 1, color: Colors.red);
    } catch (e) {
      return StatusModel(id: 0, name: '', step: 1, color: Colors.red);
    }
  }

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(
      int customerId) async {
    print('getOrdersBySupplierId');
    try {
      List<Map<String, dynamic>> response = await _client
          .from('all_orders_view')
          .select()
          .eq('customer ->> customer_id', customerId)
          .order('order_time', ascending: true);
/*
          response = response.where((element) => element['customer']['customer_id'] == supplierId).toList();
*/
      List<OrderModel> orderList =
          response.map((e) => OrderModel.fromJson(e)).toList();

      return Right(orderList);
      /*.from('all_orders_view')
          .select();*/
/*
          .eq('supplier_id', supplierId)
*/
/*
          .order('order_time', ascending: true);
*/
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: error.message));
    } catch (e) {
      print(e);
      return Left(DatabaseFailure(errorMessage: 'Error getting orders'));
    }
  }
}
