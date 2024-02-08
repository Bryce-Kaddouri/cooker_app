import 'package:cooker_app/src/features/order/presentation/provider/sort_provider.dart';

class GetOrdersParam {
  final DateTime date;
  final SortType sortType;
  final bool isAscending;

  GetOrdersParam({
    required this.date,
    required this.sortType,
    required this.isAscending,
  });
}