// Fixed CategoryDetailsViewModel
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../Core/Base/base_view_model.dart';
import '../widgets/category_model.dart';

class CategoryDetailsViewModel extends BaseViewModel {
  CategoryModel? _categoryDetails;
  List<String> _categoryImages = [];
  bool _isLoading = false;
  String? _errorMessage;

  CategoryModel? get categoryDetails => _categoryDetails;
  List<String> get categoryImages => _categoryImages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const String baseUrl = 'https://skinally.runasp.net/api/categories'; // Fixed: Use HTTPS

  Future<void> loadCategoryDetails(int categoryId) async {
    try {
      _setLoading(true);
      _errorMessage = null;

      // Load category details (which should include images)
      await _loadCategoryById(categoryId);

    } catch (e) {
      _errorMessage = 'Failed to load category details: ${e.toString()}';
      if (kDebugMode) {
        print('Error loading category details: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadCategoryById(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _categoryDetails = CategoryModel.fromJson(jsonData);

        // Extract and process image URLs
        _categoryImages = _processImageUrls(_categoryDetails!.imagesUrl);

        // Update category details with processed image URLs
        _categoryDetails = CategoryModel(
          id: _categoryDetails!.id,
          name: _categoryDetails!.name,
          title: _categoryDetails!.title,
          description: _categoryDetails!.description,
          imagesUrl: _categoryImages,
        );

        if (kDebugMode) {
          print('Loaded category: ${_categoryDetails!.name}');
          print('Images found: ${_categoryImages.length}');
          print('Image URLs: $_categoryImages');
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load category by ID: $e');
      }
      rethrow;
    }
  }

  List<String> _processImageUrls(List<String> originalUrls) {
    return originalUrls.map((url) {
      // Convert localhost URLs to production URLs
      if (url.contains('localhost:7143')) {
        return url.replaceAll('https://localhost:7143', 'https://skinally.runasp.net');
      }
      return url;
    }).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}






