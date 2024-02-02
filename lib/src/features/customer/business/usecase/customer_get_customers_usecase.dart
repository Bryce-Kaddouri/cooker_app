import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:cooker_app/src/features/customer/business/repository/customer_repository.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/customer_model.dart';

class CustomerGetCustomersUseCase
    implements UseCase<List<CustomerModel>, NoParams> {
  final CustomerRepository customerRepository;

  const CustomerGetCustomersUseCase({
    required this.customerRepository,
  });

  @override
  Future<Either<DatabaseFailure, List<CustomerModel>>> call(NoParams params) {
    return customerRepository.getCustomers(params);
  }
}
