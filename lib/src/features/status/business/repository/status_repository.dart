import 'package:cooker_app/src/core/data/usecase/usecase.dart';
/*
import 'package:admin_dashboard/src/feature/category/business/param/category_add_param.dart';
*/
import 'package:dartz/dartz.dart';

import '../../../../core/data/exception/failure.dart';
import '../../data/model/status_model.dart';

/*
import '../../data/model/category_model.dart';
*/

abstract class StatusRepository {
  Future<Either<DatabaseFailure, List<StatusModel>>> getAllStatus(NoParams param);
}
