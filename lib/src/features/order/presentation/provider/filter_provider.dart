import 'package:flutter/material.dart';

import '../../../status/data/model/status_model.dart';
import '../../data/model/order_model.dart';

class FilterProvider with ChangeNotifier {
  int _selectedProductFilter = -1;
  int get selectedProductFilter => _selectedProductFilter;
  void setSelectedProductFilter(int value) {
    _selectedProductFilter = value;
    notifyListeners();
  }

  void resetSelectedProductFilter() {
    _selectedProductFilter = -1;
    notifyListeners();
  }

  int _selectedCategoryFilter = -1;
  int get selectedCategoryFilter => _selectedCategoryFilter;
  void setSelectedCategoryFilter(int value) {
    _selectedCategoryFilter = value;
    notifyListeners();
  }

  void resetSelectedCategoryFilter() {
    _selectedCategoryFilter = -1;
    notifyListeners();
  }

  MenuController _menuController = MenuController();
  MenuController get menuController => _menuController;
  void setMenuController(MenuController value) {
    _menuController = value;
    notifyListeners();
  }

  MenuController _menuControllerCategory = MenuController();
  MenuController get menuControllerCategory => _menuControllerCategory;
  void setMenuControllerCategory(MenuController value) {
    _menuControllerCategory = value;
    notifyListeners();
  }

  double _maxRangePrice = 100;
  double get maxRangePrice => _maxRangePrice;

  void setMaxRangePrice(double value) {
    _maxRangePrice = value;

    notifyListeners();
  }

  double _selectedMaxRangePrice = 1;
  double get selectedMaxRangePrice => _selectedMaxRangePrice;

  void setSelectedMaxRangePrice(double value) {
    _selectedMaxRangePrice = value;
    notifyListeners();
  }

  double _selectedMinRangePrice = 0;
  double get selectedMinRangePrice => _selectedMinRangePrice;

  void setSelectedMinRangePrice(double value) {
    _selectedMinRangePrice = value;
    notifyListeners();
  }

  bool _isFilteringByPrice = false;
  bool get isFilteringByPrice => _isFilteringByPrice;

  void setIsFilteringByPrice(bool value) {
    _isFilteringByPrice = value;
    notifyListeners();
  }

  TimeOfDay _selectedStartTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay get selectedStartTime => _selectedStartTime;

  void setSelectedStartTime(TimeOfDay value) {
    _selectedStartTime = value;
    notifyListeners();
  }

  TimeOfDay _selectedEndTime = TimeOfDay(hour: 23, minute: 59);
  TimeOfDay get selectedEndTime => _selectedEndTime;

  void setSelectedEndTime(TimeOfDay value) {
    _selectedEndTime = value;
    notifyListeners();
  }

  void resetAllFilter() {
    _selectedProductFilter = -1;
    _selectedCategoryFilter = -1;
    _maxRangePrice = 100;
    notifyListeners();
  }

  List<OrderModel> _filteredOrderList = [];
  List<OrderModel> get filteredOrderList => _filteredOrderList;
  void setFilteredOrderList(List<OrderModel> value) {
    _filteredOrderList = value;
    notifyListeners();
  }

  Status _selectedStatus = Status.all;
  Status get selectedStatus => _selectedStatus;

  void setSelectedStatus(Status value) {
    _selectedStatus = value;
    notifyListeners();
  }
/*
  bool _isFilteringByStatus = true;
  bool get isFilteringByStatus => _isFilteringByStatus;

  void setIsFilteringByStatus(bool value) {
    _isFilteringByStatus = value;
    notifyListeners();
  }*/

  /*bool _isFilteringByHour = false;
  bool get isFilteringByHour => _isFilteringByHour;

  void setIsFilteringByHour(bool value) {
    _isFilteringByHour = value;
    notifyListeners();
  }*/

  TimeOfDay? _selectedHour;
  TimeOfDay? get selectedHour => _selectedHour;

  void setSelectedHour(TimeOfDay? value) {
    _selectedHour = value;
    notifyListeners();
  }

  /* bool _isFilteringByCustomer = false;
  bool get isFilteringByCustomer => _isFilteringByCustomer;

  void setIsFilteringByCustomer(bool value) {
    _isFilteringByCustomer = value;
    notifyListeners();
  }*/

  int? _selectedCustomerId;
  int? get selectedCustomerId => _selectedCustomerId;

  void setSelectedCustomerId(int? value) {
    _selectedCustomerId = value;
    notifyListeners();
  }

  /*bool _isFilteringByProduct = false;
  bool get isFilteringByProduct => _isFilteringByProduct;

  void setIsFilteringByProduct(bool value) {
    _isFilteringByProduct = value;
    notifyListeners();
  }*/

  int? _selectedProductId;
  int? get selectedProductId => _selectedProductId;

  void setSelectedProductId(int? value) {
    _selectedProductId = value;
    notifyListeners();
  }

  /* bool _isFilteringByCategory = false;
  bool get isFilteringByCategory => _isFilteringByCategory;

  void setIsFilteringByCategory(bool value) {
    _isFilteringByCategory = value;
    notifyListeners();
  }*/

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  void setSelectedCategoryId(int? value) {
    _selectedCategoryId = value;
    notifyListeners();
  }

  FilterType _selectedFilterType = FilterType.status;
  FilterType get selectedFilterType => _selectedFilterType;

  void setSelectedFilterType(FilterType value) {
    _selectedFilterType = value;
    notifyListeners();
  }

  /*void toggleRadioFilterButton(FilterType filterType) {
    // only one filter can be active at a time
    switch (filterType) {
      case FilterType.status:
        setIsFilteringByStatus(true);
        setIsFilteringByHour(false);
        setIsFilteringByCustomer(false);
        setIsFilteringByProduct(false);
        setIsFilteringByCategory(false);
        break;
      case FilterType.hour:
        setIsFilteringByStatus(false);
        setIsFilteringByHour(true);
        setIsFilteringByCustomer(false);
        setIsFilteringByProduct(false);
        setIsFilteringByCategory(false);
        break;
      case FilterType.customer:
        setIsFilteringByStatus(false);
        setIsFilteringByHour(false);
        setIsFilteringByCustomer(true);
        setIsFilteringByProduct(false);
        setIsFilteringByCategory(false);
        break;

      case FilterType.product:
        setIsFilteringByStatus(false);
        setIsFilteringByHour(false);
        setIsFilteringByCustomer(false);
        setIsFilteringByProduct(true);
        setIsFilteringByCategory(false);
        break;
      case FilterType.category:
        setIsFilteringByStatus(false);
        setIsFilteringByHour(false);
        setIsFilteringByCustomer(false);
        setIsFilteringByCategory(true);
        setIsFilteringByProduct(false);
        break;
    }
  }*/
}

enum FilterType {
  status,
  hour,
  customer,
  category,
  product,
}
