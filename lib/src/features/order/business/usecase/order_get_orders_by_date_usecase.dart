import 'package:cooker_app/src/features/order/business/getOrdersParam.dart';
import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:cooker_app/src/features/order/business/repository/order_repository.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/order_model.dart';

class OrderGetOrdersByDateUseCase
    implements UseCase<List<OrderModel>, GetOrdersParam> {
  final OrderRepository orderRepository;

  const OrderGetOrdersByDateUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, List<OrderModel>>> call(GetOrdersParam param) {
    return orderRepository.getOrdersByDate(param);
  }
}
