import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:cooker_app/src/features/order/data/model/order_model.dart';

import '../../../../core/data/exception/failure.dart';
import '../getOrdersParam.dart';

abstract class OrderRepository {
  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      GetOrdersParam param);

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(
      int customerId);

  Future<Either<DatabaseFailure, OrderModel>> getOrderById(int id);


}
