import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/exception/failure.dart';
import '../model/product_model.dart';

class ProductDataSource {
  final _client = Supabase.instance.client;

  Future<Either<DatabaseFailure, List<ProductModel>>> getProducts() async {
    try {
      List<Map<String, dynamic>> response =
          await _client.from('products').select().order('id', ascending: true);
      print(response);
      if (response.isNotEmpty) {
        print('response is not empty');
        List<ProductModel> productList =
            response.map((e) => ProductModel.fromJsonTable(e)).toList();
        return Right(productList);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting products'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: 'Error getting products'));
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Error getting products'));
    }
  }

  Future<Either<DatabaseFailure, ProductModel>> getProductById(int id) async {
    try {
      List<Map<String, dynamic>> response = await _client
          .from('products')
          .select()
          .eq('id', id)
          .limit(1)
          .order('id', ascending: true);
      if (response.isNotEmpty) {
        ProductModel productModel = ProductModel.fromJson(response[0]);
        return Right(productModel);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting product'));
      }
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Error getting product'));
    }
  }

  Stream<List<Map<String, dynamic>>> getProductByIdStream() {
    /*return _client
        .from('products')
        .stream(primaryKey: ['id']).order('id', ascending: true);*/
    try {
      return _client
          .from('products')
          .stream(primaryKey: ['id']).order('id', ascending: true);
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Stream.empty();
    } catch (e) {
      print(e);
      return Stream.empty();
    }
  }

  Future<Either<StorageFailure, String>> getSignedUrl(String path) async {
    try {
      final response = await _client.storage.from('products').createSignedUrl(
            path,
            const Duration(days: 1).inSeconds,
          );
      if (response != null) {
        return Right(response);
      } else {
        return Left(StorageFailure(errorMessage: 'Error getting signed url'));
      }
    } on StorageException catch (error) {
      print('storage error');
      print(error);
      return Left(StorageFailure(errorMessage: 'Error getting signed url'));
    } catch (e) {
      return Left(StorageFailure(errorMessage: 'Error getting signed url'));
    }
  }
}
