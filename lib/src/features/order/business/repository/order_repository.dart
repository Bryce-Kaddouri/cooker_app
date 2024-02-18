import 'package:cooker_app/src/features/order/business/param/changeStatusOrderByIdParam.dart';
import 'package:cooker_app/src/features/order/business/param/getOrderByIdParam.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../param/changeIsDoneCartByIdParam.dart';
import '../param/getOrdersParam.dart';

abstract class OrderRepository {
  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      GetOrdersParam param);

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(
      int customerId);

  Future<Either<DatabaseFailure, OrderModel>> getOrderById(
      GetOrderByIdParam param);

  Future<Either<DatabaseFailure, bool>> changeOrderStatus(
      ChangeStatusOrderByIdParam param);
  Future<Either<DatabaseFailure, bool>> changeIsDoneCart(
      ChangeIsDoneCartByIdParam param);
}
