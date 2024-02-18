import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../param/changeIsDoneCartByIdParam.dart';
import '../repository/order_repository.dart';

class OrderChangeIsDoneCartByIdUseCase
    implements UseCase<bool, ChangeIsDoneCartByIdParam> {
  final OrderRepository orderRepository;

  const OrderChangeIsDoneCartByIdUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, bool>> call(ChangeIsDoneCartByIdParam param) {
    return orderRepository.changeIsDoneCart(param);
  }
}
