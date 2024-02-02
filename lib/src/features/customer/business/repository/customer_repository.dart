import 'dart:typed_data';

import 'package:cooker_app/src/core/data/usecase/usecase.dart';
/*
import 'package:admin_dashboard/src/feature/category/business/param/category_add_param.dart';
*/
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cooker_app/src/features/customer/data/model/customer_model.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';

/*
import '../../data/model/category_model.dart';
*/

abstract class CustomerRepository {
  Future<Either<DatabaseFailure, List<CustomerModel>>> getCustomers(
      NoParams param);
  Future<Either<DatabaseFailure, CustomerModel>> addCustomer(
      CustomerModel customerModel);

  Future<Either<DatabaseFailure, CustomerModel>> updateCustomer(
      CustomerModel customerModel);

  Future<Either<DatabaseFailure, CustomerModel>> getCustomerById(int id);
}
