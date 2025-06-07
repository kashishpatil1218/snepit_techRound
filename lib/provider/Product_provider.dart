
import 'package:flutter/cupertino.dart';
import 'package:snepit_technical_test/api/api_helper.dart';

class ProductProvider extends ChangeNotifier {
  List<dynamic> _allProducts = [];
  List<dynamic> _products = [];

  bool _isLoading = false;

  List<dynamic> get Products => _products;
  bool get isLoading => _isLoading;

  final ApiHelper apiHelper = ApiHelper();
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    final response = await apiHelper.fetchData();

    _allProducts = response['products'] ?? [];
    print('Loaded products count: ${_allProducts.length}');  // Debug line

    _products = List.from(_allProducts);

    _isLoading = false;
    notifyListeners();
  }




  void searchProducts(String query) {
    if (query.isEmpty) {
      _products = List.from(_allProducts);
    } else {
      final lowerQuery = query.toLowerCase();

      _products = _allProducts.where((product) {
        final title = product['title'].toString().toLowerCase();
        final price = product['price'].toString();

        return title.contains(lowerQuery) || price.contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }
}
