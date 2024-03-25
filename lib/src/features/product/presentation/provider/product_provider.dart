import 'package:flutter/material.dart';

import '../../../../core/data/usecase/usecase.dart';
import '../../business/usecase/product_get_product_by_id_usecase.dart';
import '../../business/usecase/product_get_products_usecase.dart';
import '../../business/usecase/product_get_signed_url_usecase.dart';
import '../../data/model/product_model.dart';

class ProductProvider with ChangeNotifier {
  final ProductGetProductsUseCase productGetProductsUseCase;
  final ProductGetProductByIdUseCase productGetProductByIdUseCase;

  final ProductGetSignedUrlUseCase productGetSignedUrlUseCase;

  ProductProvider({
    required this.productGetProductsUseCase,
    required this.productGetProductByIdUseCase,
    required this.productGetSignedUrlUseCase,
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  ProductModel? _productModel;

  ProductModel? get productModel => _productModel;

  void setProductModel(ProductModel? value) {
    _productModel = value;
    notifyListeners();
  }

  int _nbItemPerPage = 10;

  int get nbItemPerPage => _nbItemPerPage;

  void setNbItemPerPage(int value) {
    _nbItemPerPage = value;
    notifyListeners();
  }

  String _searchText = '';

  String get searchText => _searchText;

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  int _selectedIndexCategory = 0;

  int get selectedIndexCategory => _selectedIndexCategory;

  void setSelectedIndexCategory(int value) {
    _selectedIndexCategory = value;
    notifyListeners();
  }

  TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  void setTextController(String value) {
    _searchController.text = value;
    notifyListeners();
  }

  Future<String?> getSignedUrl(String path) async {
    path = path.split('/').last;
    String? url;

    final result = await productGetSignedUrlUseCase.call(path);

    await result.fold((l) async {
      url = null;
    }, (r) async {
      print(r);
      url = r;
    });

    return url;
  }

  Future<ProductModel?> getProductById(int id) async {
    ProductModel? productModel;
    final result = await productGetProductByIdUseCase.call(id);

    await result.fold((l) async {}, (r) async {
      print(r.toJson());
      productModel = ProductModel.fromJson(r.toJson());
    });

    return productModel;
  }

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  void setProductList(List<ProductModel> value) {
    _productList = value;
    notifyListeners();
  }

  void initProductList() async {
    final result = await productGetProductsUseCase.call(NoParams());
    result.fold((l) {
      print(l.errorMessage);
    }, (r) {
      _productList = r;
      notifyListeners();
    });
  }

  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> productList = [];
    final result = await productGetProductsUseCase.call(NoParams());

    await result.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      print(r);
      productList = r;
    });

    return productList;
  }
}
