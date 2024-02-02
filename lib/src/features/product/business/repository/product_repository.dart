import 'dart:typed_data';

import 'package:cooker_app/src/core/data/usecase/usecase.dart';
/*
import 'package:admin_dashboard/src/feature/category/business/param/category_add_param.dart';
*/
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/product_model.dart';
import '../param/product_add_param.dart';
/*
import '../../data/model/category_model.dart';
*/

abstract class ProductRepository {
  Future<Either<DatabaseFailure, List<ProductModel>>> getProducts(
      NoParams param);

  Future<Either<DatabaseFailure, ProductModel>> getProductById(int id);

  Future<Either<StorageFailure, String>> getSignedUrl(String path);
}
