import 'package:cooker_app/src/core/data/exception/failure.dart';
import 'package:cooker_app/src/core/data/usecase/usecase.dart';
import 'package:cooker_app/src/features/status/business/repository/status_repository.dart';
import 'package:cooker_app/src/features/status/data/datasource/status_datasource.dart';
import 'package:cooker_app/src/features/status/data/model/status_model.dart';
import 'package:dartz/dartz.dart';

class StatusRepositoryImpl implements StatusRepository {
  final StatusDataSource dataSource;

  StatusRepositoryImpl({required this.dataSource});

  @override
  Future<Either<DatabaseFailure, List<StatusModel>>> getAllStatus(NoParams param) {
    return dataSource.getAllStatus();
  }

  /*@override
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
  }*/
}
