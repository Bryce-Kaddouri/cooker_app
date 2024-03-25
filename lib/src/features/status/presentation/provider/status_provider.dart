import 'package:cooker_app/src/features/status/business/usecase/status_get_all_status_usecase.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/status_model.dart';

class StatusProvider with ChangeNotifier {
  final StatusGetAllStatusUseCase statusGetAllStatusUseCase;

  StatusProvider({required this.statusGetAllStatusUseCase});

  List<StatusModel> _statusList = [];
  List<StatusModel> get statusList => _statusList;

  void getAllStatus() async {
    final result = await statusGetAllStatusUseCase(NoParams());
    result.fold(
      (failure) => print('Error: ${failure.errorMessage}'),
      (statusList) {
        _statusList = statusList;
        notifyListeners();
      },
    );
  }
}
