import 'package:flutter/material.dart';

class SortProvider with ChangeNotifier {
  SortType _sortType = SortType.time;

  SortType get sortType => _sortType;

  void setSortType(SortType sortType) {
    _sortType = sortType;
    notifyListeners();
  }

  bool _isAscending = true;
  bool get isAscending => _isAscending;

  void setAscending(bool value) {
    _isAscending = value;
    notifyListeners();
  }

}

enum SortType { orderId, customer, items,total, time }


