import 'package:flutter/material.dart';

import '../../../../core/data/usecase/usecase.dart';
import '../../business/usecase/customer_get_customer_by_id_usecase.dart';
import '../../business/usecase/customer_get_customers_usecase.dart';
import '../../data/model/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerGetCustomersUseCase customerGetCustomersUseCase;
  final CustomerGetCustomerByIdUseCase customerGetCustomersByIdUseCase;

  CustomerProvider({
    required this.customerGetCustomersUseCase,
    required this.customerGetCustomersByIdUseCase,
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<CustomerModel> _customerList = [];
  List<CustomerModel> get customerList => _customerList;

  void initCustomerList() async {
    customerGetCustomersUseCase.call(NoParams()).then((value) {
      value.fold((l) {
        print(l.errorMessage);
      }, (r) {
        _customerList = r;
        notifyListeners();
      });
    });
  }

  CustomerModel? _customerModel;

  CustomerModel? get customerModel => _customerModel;

  void setProductModel(CustomerModel? value) {
    _customerModel = value;
    notifyListeners();
  }

  String _searchText = '';

  String get searchText => _searchText;

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  void setTextController(String value) {
    _searchController.text = value;
    notifyListeners();
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    CustomerModel? customerModel;
    final result = await customerGetCustomersByIdUseCase.call(id);

    await result.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      print(r.toJson());
      customerModel = r;
    });

    return customerModel;
  }

  /*Future getCustomerInfoById(int customerId) async {
    var res = null;
    final result = await CustomerDataSource().getCustomerInfosById(customerId);
    await result.fold((l) async {
      print("error");
      print(l.errorMessage);
    }, (r) async {
      print("result");
      print(r);
      res = r;
    });

    return res;

  }*/

  Future<List<CustomerModel>?> getCustomers() async {
    List<CustomerModel>? customerModelList;
    final result = await customerGetCustomersUseCase.call(NoParams());

    await result.fold((l) async {}, (r) async {
      print('result');
      print(r);
      customerModelList = r;
    });

    return customerModelList;
  }
}
