import 'package:cooker_app/src/features/status/business/repository/status_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/status_model.dart';

class StatusGetAllStatusUseCase implements UseCase<List<StatusModel>, NoParams> {
  final StatusRepository statusRepository;

  const StatusGetAllStatusUseCase({
    required this.statusRepository,
  });

  @override
  Future<Either<DatabaseFailure, List<StatusModel>>> call(NoParams params) {
    return statusRepository.getAllStatus(params);
  }
}
