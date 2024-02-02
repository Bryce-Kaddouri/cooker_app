import 'package:dartz/dartz.dart';
import 'package:cooker_app/src/core/data/exception/failure.dart';
import 'package:cooker_app/src/core/data/usecase/usecase.dart';
import 'package:cooker_app/src/features/customer/business/repository/customer_repository.dart';
import 'package:cooker_app/src/features/customer/data/model/customer_model.dart';

import '../datasource/customer_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerDataSource dataSource;

  CustomerRepositoryImpl({required this.dataSource});

  @override
  Future<Either<DatabaseFailure, CustomerModel>> addCustomer(
      CustomerModel customerModel) async {
    return await dataSource.addCustomer(customerModel);
  }

  @override
  Future<Either<DatabaseFailure, CustomerModel>> getCustomerById(int id) async {
    return await dataSource.getCustomerById(id);
  }

  @override
  Future<Either<DatabaseFailure, List<CustomerModel>>> getCustomers(
      NoParams param) async {
    return await dataSource.getCustomers();
  }

  @override
  Future<Either<DatabaseFailure, CustomerModel>> updateCustomer(
      CustomerModel customerModel) async {
    return await dataSource.updateCustomer(customerModel);
  }
}
