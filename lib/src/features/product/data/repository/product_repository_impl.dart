import 'dart:typed_data';

import 'package:cooker_app/src/core/data/exception/failure.dart';
import 'package:cooker_app/src/core/data/usecase/usecase.dart';

/*import 'package:take_order_app/src/feature/category/business/param/category_add_param.dart';*/

/*import 'package:take_order_app/src/feature/category/data/model/category_model.dart';
import 'package:take_order_app/src/feature/product/data/model/product_model.dart';*/

import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../business/param/product_add_param.dart';
import '../../business/repository/product_repository.dart';
import '../datasource/product_datasource.dart';
import '../model/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl({required this.dataSource});

  @override
  Future<Either<DatabaseFailure, List<ProductModel>>> getProducts(
      NoParams param) async {
    return await dataSource.getProducts();
  }

  @override
  Future<Either<DatabaseFailure, ProductModel>> getProductById(int id) async {
    return await dataSource.getProductById(id);
  }

  @override
  Future<Either<StorageFailure, String>> getSignedUrl(String path) async {
    return await dataSource.getSignedUrl(path);
  }
}
