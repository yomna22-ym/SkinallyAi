import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../Core/Base/base_view_model.dart';
import 'widgets/category_model.dart';

class CategoriesViewModel extends BaseViewModel {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> get categories => _categories;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  static const String baseUrl = 'https://skinally.runasp.net/api/categories';

  Future<void> loadCategories() async {
    try {
      _setLoading(true);
      _errorMessage = null;

      final response = await http
          .get(
            Uri.parse(baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: 15)); // Increased timeout

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _categories =
            jsonData.map((json) => CategoryModel.fromJson(json)).toList();

        if (kDebugMode) {
          print('Loaded ${_categories.length} categories');
          if (_categories.isNotEmpty) {
            print('First category images: ${_categories.first.imagesUrl}');
          }
        }
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Failed to load categories: ${e.toString()}';
      if (kDebugMode) {
        print('Error: $e');
      }
      _loadLocalCategories();
    } finally {
      _setLoading(false);
    }
  }

  void _loadLocalCategories() {
    _categories = [
      CategoryModel(
        id: 1,
        name: 'Melanoma',
        description: 'A serious form of skin cancer',
        imagesUrl: ['Assets/categories/melanoma.jpg'],
      ),
      CategoryModel(
        id: 2,
        name: 'Melanocytic Nevus',
        description: 'Common moles on skin',
        imagesUrl: ['Assets/categories/melanocytic.jpg'],
      ),
      CategoryModel(
        id: 3,
        name: 'Basal Cell Carcinoma',
        description: 'Most common skin cancer',
        imagesUrl: ['Assets/categories/basel cell.jpg'],
      ),
      CategoryModel(
        id: 4,
        name: 'Dermatofibroma',
        description: 'Benign skin growths',
        imagesUrl: ['Assets/categories/dermatofibroma.jpg'],
      ),
      CategoryModel(
        id: 5,
        name: 'Actinic Keratosis',
        description: 'Pre-cancerous skin condition',
        imagesUrl: ['Assets/categories/actinic keratosis.jpg'],
      ),
      CategoryModel(
        id: 6,
        name: 'Benign Keratosis',
        description: 'Non-cancerous skin growths',
        imagesUrl: ['Assets/categories/bengin keratosis.jpg'],
      ),
      CategoryModel(
        id: 7,
        name: 'Vascular',
        description: 'Blood vessel related lesions',
        imagesUrl: ['Assets/categories/vascular.jpg'],
      ),
      CategoryModel(
        id: 8,
        name: 'Squamous Cell Carcinoma',
        description: 'Second most common skin cancer',
        imagesUrl: ['Assets/categories/squamous cell.jpg'],
      ),
    ];
  }

  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/search?name=$query'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      return _categories
          .where(
            (category) =>
                category.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CategoryModel.fromJson(jsonData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get category by ID: $e');
      }
    }

    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
