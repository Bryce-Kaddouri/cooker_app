import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/product_model.dart';
import '../repository/product_repository.dart';

class ProductGetSignedUrlUseCase implements UseCase<String, String> {
  final ProductRepository productRepository;

  const ProductGetSignedUrlUseCase({
    required this.productRepository,
  });

  @override
  Future<Either<StorageFailure, String>> call(String path) {
    return productRepository.getSignedUrl(path);
  }
}
