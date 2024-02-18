import 'package:cooker_app/src/core/data/exception/failure.dart';
import 'package:cooker_app/src/features/order/business/param/changeIsDoneCartByIdParam.dart';
import 'package:cooker_app/src/features/order/business/param/changeStatusOrderByIdParam.dart';
import 'package:cooker_app/src/features/order/business/param/getOrderByIdParam.dart';
import 'package:cooker_app/src/features/order/business/param/getOrdersParam.dart';
import 'package:cooker_app/src/features/order/data/datasource/order_datasource.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:dartz/dartz.dart';

import '../../business/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource orderDataSource;

  OrderRepositoryImpl({
    required this.orderDataSource,
  });

  @override
  Future<Either<DatabaseFailure, OrderModel>> getOrderById(
      GetOrderByIdParam param) async {
    return await orderDataSource.getOrderById(param.date, param.id);
  }

  @override
  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(
      int customerId) async {
    return await orderDataSource.getOrdersByCustomerId(customerId);
  }

  @override
  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      GetOrdersParam param) async {
    return await orderDataSource.getOrdersByDate(
        param.date, param.sortType, param.isAscending);
  }

  @override
  Future<Either<DatabaseFailure, bool>> changeOrderStatus(
      ChangeStatusOrderByIdParam param) async {
    return await orderDataSource.changeOrderStatus(
        param.date, param.id, param.step);
  }

  @override
  Future<Either<DatabaseFailure, bool>> changeIsDoneCart(
      ChangeIsDoneCartByIdParam param) async {
    return await orderDataSource.changeIsDoneCart(
        param.date, param.orderId, param.cartId, param.productId, param.isDone);
  }
}
