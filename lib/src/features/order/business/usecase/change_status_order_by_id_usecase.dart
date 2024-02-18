import 'package:cooker_app/src/features/order/business/param/changeStatusOrderByIdParam.dart';
import 'package:cooker_app/src/features/order/business/repository/order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';

class OrderChangeStatusOrderByIdUseCase
    implements UseCase<bool, ChangeStatusOrderByIdParam> {
  final OrderRepository orderRepository;

  const OrderChangeStatusOrderByIdUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, bool>> call(ChangeStatusOrderByIdParam param) {
    return orderRepository.changeOrderStatus(param);
  }
}
