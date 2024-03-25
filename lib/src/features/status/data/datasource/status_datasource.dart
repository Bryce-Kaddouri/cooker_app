import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/exception/failure.dart';
import '../model/status_model.dart';

class StatusDataSource {
  final _client = Supabase.instance.client;

  Future<Either<DatabaseFailure, List<StatusModel>>> getAllStatus() async {
    try {
      List<Map<String, dynamic>> response = await _client.from('status').select().order('step', ascending: true);

      print('response');
      print(response);
/*
          .order('l_name', ascending: true);
*/
      if (response.isNotEmpty) {
        List<StatusModel> statusList = response.map((e) => StatusModel.fromJson(e, isFromTable: true)).toList();
        return Right(statusList);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting status'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: 'Error getting status'));
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Error getting status'));
    }
  }

  /*Future getCustomerInfosById(int customerId) async{

    return OrderDataSource().getOrdersBySupplierId(customerId);

   */ /* return Future.wait([
      getCustomerById(customerId),

      OrderDataSource().getOrdersBySupplierId(customerId),

    ]);*/ /*
  }*/
}
