import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../Core/Base/base_view_model.dart';
import 'pharmacy_navigator.dart';

class PharmacyViewModel extends BaseViewModel<PharmacyNavigator> {

  static const String baseUrl = 'http://skinally.runasp.net/api';
  static const String getAllProductsUrl = '$baseUrl/product';
  static const String getProductByIdUrl = '$baseUrl/product';
  static const String searchProductsUrl = '$baseUrl/Product/search';
  static const String paginatedProductsUrl = '$baseUrl/Product/paginated';

  final TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isGridView = true;
  bool get isGridView => _isGridView;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _products = [];
  List<dynamic> get products => _products;

  List<dynamic> _allProducts = [];
  List<String> _categories = ['All'];
  List<String> get categories => _categories;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  // Pagination
  int _currentPage = 1;
  int _pageSize = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _fixImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';

    // Replace localhost with the correct domain
    if (imageUrl.contains('localhost:7143')) {
      return imageUrl.replaceAll('https://localhost:7143', 'https://skinally.runasp.net')
          .replaceAll('http://localhost:7143', 'https://skinally.runasp.net');
    }

    return imageUrl;
  }

  Map<String, dynamic> _processProduct(Map<String, dynamic> product) {
    return {
      ...product,
      'image': _fixImageUrl(product['image']?.toString()),
      'imageUrl': _fixImageUrl(product['image']?.toString()),
      'category': product['productTypeName']?.toString() ?? 'Unknown',
      'productType': product['productTypeName']?.toString() ?? 'Unknown',
      // Since there's no price in API, we'll generate a reasonable price based on product type
      'price': _generatePrice(product['productTypeName']?.toString() ?? 'Unknown'),
    };
  }

  double _generatePrice(String productType) {
    switch (productType.toLowerCase()) {
      case 'cleanser':
        return 15.99;
      case 'moisturizer':
        return 24.99;
      case 'sun protection':
        return 19.99;
      default:
        return 20.00;
    }
  }

  Future<void> loadProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _products.clear();
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await http.get(
        Uri.parse('$paginatedProductsUrl?pageNumber=$_currentPage&pageSize=$_pageSize'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<dynamic> newProducts = [];
        if (jsonData is Map && jsonData.containsKey('data')) {
          newProducts = (jsonData['data'] as List? ?? []).map((product) {
            return _processProduct(Map<String, dynamic>.from(product));
          }).toList();
        } else if (jsonData is List) {
          newProducts = jsonData.map((product) {
            return _processProduct(Map<String, dynamic>.from(product));
          }).toList();
        }

        if (isRefresh) {
          _products = newProducts;
          _allProducts = List.from(newProducts);
        } else {
          _products.addAll(newProducts);
          _allProducts.addAll(newProducts);
        }

        _hasMore = newProducts.length == _pageSize;
        _currentPage++;

        _extractCategories();

      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      _setError(_handleError(e));
      if (isRefresh) {
        navigator?.showErrorNotification(
            message: _errorMessage ?? local?.someThingWentWrong ?? 'Something went wrong'
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMoreProducts() async {
    if (!_hasMore || _isLoading) return;
    await loadProducts();
  }

  Future<void> refreshProducts() async {
    await loadProducts(isRefresh: true);
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      _products = List.from(_allProducts);
      _applyFilters();
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final encodedQuery = Uri.encodeComponent(query.trim());
      final response = await http.get(
        Uri.parse('$searchProductsUrl?name=$encodedQuery'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<dynamic> searchResults = [];
        if (jsonData is List) {
          searchResults = jsonData.map((product) {
            return _processProduct(Map<String, dynamic>.from(product));
          }).toList();
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          searchResults = (jsonData['data'] as List? ?? []).map((product) {
            return _processProduct(Map<String, dynamic>.from(product));
          }).toList();
        }

        _products = searchResults;
        _applyFilters();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      _setError(_handleError(e));
      navigator?.showErrorNotification(
          message: _errorMessage ?? local!.searchFailed
      );
    } finally {
      _setLoading(false);
    }
  }

  void clearSearch() {
    searchController.clear();
    _products = List.from(_allProducts);
    _applyFilters();
    notifyListeners();
  }

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_selectedCategory == 'All') {
      if (searchController.text.isEmpty) {
        _products = List.from(_allProducts);
      }
    } else {
      final baseProducts = searchController.text.isEmpty
          ? _allProducts
          : _products;

      _products = baseProducts.where((product) {
        final category = product['category']?.toString() ?? product['productTypeName']?.toString() ?? '';
        return category.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }
  }

  void _extractCategories() {
    final Set<String> categorySet = {'All'};

    for (var product in _allProducts) {
      final category = product['productTypeName']?.toString() ?? product['category']?.toString();
      if (category != null && category.isNotEmpty) {
        categorySet.add(category);
      }
    }

    _categories = categorySet.toList();
  }

  Future<dynamic> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$getProductByIdUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final product = json.decode(response.body);
        return _processProduct(Map<String, dynamic>.from(product));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      _setError(_handleError(e));
      return null;
    }
  }

  String _generatePurchaseUrl(dynamic product) {
    final productName = product['name']?.toString() ?? '';
    final encodedName = Uri.encodeComponent(productName);
    return 'https://www.amazon.com/s?k=$encodedName';
  }

  Future<void> openPurchaseUrl(dynamic product) async {
    try {
      final url = _generatePurchaseUrl(product);
      final uri = Uri.parse(url);

      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        navigator?.showErrorNotification(
          message: 'Could not open purchase link',
        );
      }
    } catch (e) {
      navigator?.showErrorNotification(
        message: 'Error opening purchase link: $e',
      );
    }
  }

  void selectProduct(dynamic product) {
    openPurchaseUrl(product);
  }

  void addToCart(dynamic product) {
    openPurchaseUrl(product);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  String _handleError(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return local?.checkYourInternetConnection ?? 'Check your internet connection';
    } else if (error.toString().contains('TimeoutException')) {
      return local?.operationTimedOut ?? 'Operation timed out';
    } else if (error.toString().contains('FormatException')) {
      return local?.invalidDataFormat ?? 'Invalid data format';
    } else {
      return local?.someThingWentWrong ?? 'Something went wrong';
    }
  }

  Future<void> loadAllProducts() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.get(
        Uri.parse(getAllProductsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<dynamic> processedProducts = [];
        if (jsonData is List) {
          processedProducts = jsonData.map((product) {
            return _processProduct(Map<String, dynamic>.from(product));
          }).toList();
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          processedProducts = (jsonData['data'] as List? ?? []).map((product) {
            return _processProduct(Map<String, dynamic>.from(product));
          }).toList();
        }

        _products = processedProducts;
        _allProducts = List.from(_products);
        _extractCategories();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      _setError(_handleError(e));
      navigator?.showErrorNotification(
          message: _errorMessage ?? local?.someThingWentWrong ?? 'Something went wrong'
      );
    } finally {
      _setLoading(false);
    }
  }
}