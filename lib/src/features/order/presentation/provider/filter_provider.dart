import 'package:cooker_app/src/features/category/model/category_model.dart';
import 'package:flutter/material.dart';

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
}
