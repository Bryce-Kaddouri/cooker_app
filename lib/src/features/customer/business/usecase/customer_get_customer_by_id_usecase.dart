import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:cooker_app/src/features/customer/business/repository/customer_repository.dart';
import 'package:cooker_app/src/features/customer/data/model/customer_model.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';

class CustomerGetCustomerByIdUseCase implements UseCase<CustomerModel, int> {
  final CustomerRepository customerRepository;

  const CustomerGetCustomerByIdUseCase({
    required this.customerRepository,
  });

  @override
  Future<Either<DatabaseFailure, CustomerModel>> call(int id) {
    return customerRepository.getCustomerById(id);
  }
}
