import 'package:dartz/dartz.dart';
import 'package:cooker_app/src/features/order/business/repository/order_repository.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/order_model.dart';

class OrderGetOrdersByIdUseCase implements UseCase<OrderModel, int> {
  final OrderRepository orderRepository;

  const OrderGetOrdersByIdUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, OrderModel>> call(int id) {
    return orderRepository.getOrderById(id);
  }
}
