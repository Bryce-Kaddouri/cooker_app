import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../cart/model/cart_model.dart';
import '../model/order_model.dart';

class OrderDataSource {
  final _client = Supabase.instance.client;



  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      DateTime date) async {
    try {
      var response = await _client
          .from('all_orders_view')
          .select()
          .eq('order_date', date.toIso8601String())
          .order('order_time', ascending: true);
      print('response from getOrders');
      print(response);

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
