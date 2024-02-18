import 'package:cooker_app/src/features/order/business/param/getOrderByIdParam.dart';
import 'package:cooker_app/src/features/order/business/repository/order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/order_model.dart';

class OrderGetOrderByIdUseCase
    implements UseCase<OrderModel, GetOrderByIdParam> {
  final OrderRepository orderRepository;

  const OrderGetOrderByIdUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, OrderModel>> call(GetOrderByIdParam param) {
    return orderRepository.getOrderById(param);
  }
}
