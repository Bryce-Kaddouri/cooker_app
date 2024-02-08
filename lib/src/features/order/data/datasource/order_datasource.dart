import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../cart/model/cart_model.dart';
import '../model/order_model.dart';

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

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      DateTime date, SortType sortType, bool isAscending) async {
    try {
      var response = await _client
          .from('all_orders_view')
          .select()
          .eq('order_date', date.toIso8601String())
          .order(getSortTypeString(sortType), ascending: isAscending);

      print('response from getOrders');
      for(var res in response){
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
