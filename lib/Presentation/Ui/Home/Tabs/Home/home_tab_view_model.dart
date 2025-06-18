import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../../Core/Base/base_view_model.dart';
import '../../../../../Core/Theme/theme.dart';
import '../../../../../Core/Utils/shared_preferences_utils.dart';
import '../../../../../Core/routes_manager/routes.dart';
import '../../../../Models/news_card.dart';
import 'home_tab_navigator.dart';

class HomeTabViewModel extends BaseViewModel<HomeTabNavigator> {
  HomeTabViewModel() {
    loadUserData();
  }

  static const String baseUrl = 'http://skinally.runasp.net/api';
  static const String getAllProductsUrl = '$baseUrl/product';
  static const String getCategoriesUrl =
      'https://skinally.runasp.net/api/categories';

  String _userName = '';
  String _userEmail = '';
  bool _isLoading = true;
  bool _isLoadingCategories = false;
  List<dynamic> _recommendedCategories = [];

  List<Article> _articles = [];
  bool _isLoadingArticles = false;

  List<Article> get articles => _articles;

  bool get isLoadingArticles => _isLoadingArticles;

  String get userName => _userName;

  String get userEmail => _userEmail;

  bool get isLoading => _isLoading;

  bool get isLoadingCategories => _isLoadingCategories;

  List<dynamic> get recommendedCategories => _recommendedCategories;

  Future<void> loadUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      _userName = await SharedPreferencesUtils.getUserName() ?? '';
      _userEmail = await SharedPreferencesUtils.getUserEmail() ?? '';

      if (_userName.isEmpty || _userEmail.isEmpty) {
        final userDataString = await SharedPreferencesUtils.getUserData();
        if (userDataString != null && userDataString.isNotEmpty) {
          try {
            final userData = json.decode(userDataString);
            if (userData is Map<String, dynamic>) {
              _userName = userData['name'] ?? userData['username'] ?? '';
              _userEmail = userData['email'] ?? '';
            }
          } catch (e) {
            print('Error parsing user data: $e');
          }
        }
      }

      if (_userName.isEmpty) {
        _userName = localProvider!.isEn() ? 'User' : 'مستخدم';
      }
      if (_userEmail.isEmpty) {
        _userEmail = 'user@example.com';
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
      _userName = localProvider!.isEn() ? 'User' : 'مستخدم';
      _userEmail = 'user@example.com';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadArticles({String langCode = 'en'}) async {
    _isLoadingArticles = true;
    notifyListeners();

    try {
      final filePath =
          langCode == 'ar'
              ? 'Assets/data/articles-ar.json'
              : 'Assets/data/articles.json';

      final jsonString = await rootBundle.loadString(filePath);
      final List<dynamic> jsonData = json.decode(jsonString);

      _articles =
          jsonData
              .map((e) => Article.fromJson(e as Map<String, dynamic>))
              .toList();
    } catch (e) {
      print('Failed to load articles: $e');
      _articles = [];
    } finally {
      _isLoadingArticles = false;
      notifyListeners();
    }
  }

  Future<void> loadRecommendedCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      final response = await http
          .get(
            Uri.parse(getCategoriesUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<dynamic> categories = [];
        if (jsonData is List) {
          categories = jsonData;
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          categories = jsonData['data'] as List? ?? [];
        }

        _recommendedCategories =
            categories
                .take(8)
                .map(
                  (category) =>
                      _processCategory(Map<String, dynamic>.from(category)),
                )
                .toList();
      } else {
        print('Failed to load categories: ${response.statusCode}');
        _loadLocalCategories();
      }
    } catch (e) {
      print('Error loading recommended categories: $e');
      _loadLocalCategories();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  void _loadLocalCategories() {
    _recommendedCategories = [
      {
        'id': 1,
        'name': localProvider!.isEn() ? 'Melanoma' : 'الميلانوما',
        'description':
            localProvider!.isEn()
                ? 'A serious form of skin cancer'
                : 'شكل خطير من سرطان الجلد',
        'image': 'Assets/categories/melanoma.jpg',
      },
      {
        'id': 2,
        'name': localProvider!.isEn() ? 'Melanocytic Nevus' : 'الوحمة الصبغية',
        'description':
            localProvider!.isEn()
                ? 'Common moles on skin'
                : 'الشامات الشائعة على الجلد',
        'image': 'Assets/categories/melanocytic_nevus.jpg',
      },
      {
        'id': 3,
        'name':
            localProvider!.isEn()
                ? 'Basal Cell Carcinoma'
                : 'سرطان الخلايا القاعدية',
        'description':
            localProvider!.isEn()
                ? 'Most common skin cancer'
                : 'أكثر أنواع سرطان الجلد شيوعاً',
        'image': 'Assets/categories/basel cell.jpg',
      },
      {
        'id': 4,
        'name':
            localProvider!.isEn() ? 'Dermatofibroma' : 'الورم الليفي الجلدي',
        'description':
            localProvider!.isEn() ? 'Benign skin growths' : 'نمو جلدي حميد',
        'image': 'Assets/categories/dermatofibroma.jpg',
      },
      {
        'id': 5,
        'name': localProvider!.isEn() ? 'Actinic Keratosis' : 'التقرن الشعاعي',
        'description':
            localProvider!.isEn()
                ? 'Pre-cancerous skin condition'
                : 'حالة جلدية ما قبل السرطان',
        'image': 'Assets/categories/actinic_keratosis.jpg', // Fixed name
      },
      {
        'id': 6,
        'name': localProvider!.isEn() ? 'Benign Keratosis' : 'التقرن الحميد',
        'description':
            localProvider!.isEn()
                ? 'Non-cancerous skin growths'
                : 'نمو جلدي غير سرطاني',
        'image': 'Assets/categories/benign_keratosis.jpg', // Fixed name
      },
      {
        'id': 7,
        'name':
            localProvider!.isEn() ? 'Vascular Lesions' : 'آفات الأوعية الدموية',
        'description':
            localProvider!.isEn()
                ? 'Blood vessel related lesions'
                : 'آفات متعلقة بالأوعية الدموية',
        'image': 'Assets/categories/vascular.jpg',
      },
      {
        'id': 8,
        'name':
            localProvider!.isEn()
                ? 'Squamous Cell Carcinoma'
                : 'سرطان الخلايا الحرشفية',
        'description':
            localProvider!.isEn()
                ? 'Second most common skin cancer'
                : 'ثاني أكثر أنواع سرطان الجلد شيوعاً',
        'image': 'Assets/categories/squamous_cell.jpg', // Fixed name
      },
    ];
  }

  Map<String, dynamic> _processCategory(Map<String, dynamic> category) {
    String? imagePath;

    if (category['imagesUrl'] != null && category['imagesUrl'] is List) {
      List<dynamic> images = category['imagesUrl'];
      if (images.isNotEmpty) {
        imagePath = images.first.toString();
      }
    } else if (category['image'] != null) {
      imagePath = category['image'].toString();
    }

    return {
      ...category,
      'image':
          imagePath ??
          _getDefaultCategoryImage(category['name']?.toString() ?? ''),
      'name':
          category['name']?.toString() ??
          (localProvider!.isEn() ? 'Unknown Category' : 'فئة غير معروفة'),
      'description': category['description']?.toString() ?? '',
    };
  }

  String _getDefaultCategoryImage(String categoryName) {
    final lowerName = categoryName.toLowerCase();

    if (lowerName.contains('melanoma')) {
      return 'Assets/categories/melanoma.jpg';
    } else if (lowerName.contains('melanocytic') || lowerName.contains('nevus')) {
      return 'Assets/categories/melanocytic.jpg';
    } else if (lowerName.contains('basal') || lowerName.contains('basel')) {
      return 'Assets/categories/basel cell.jpg';
    } else if (lowerName.contains('dermatofibroma')) {
      return 'Assets/categories/dermatofibroma.jpg';
    } else if (lowerName.contains('actinic')) {
      return 'Assets/categories/actinic keratosis.jpg';
    } else if (lowerName.contains('benign') && lowerName.contains('keratosis')) {
      return 'Assets/categories/bengin keratosis.jpg';
    } else if (lowerName.contains('vascular')) {
      return 'Assets/categories/vascular.jpg';
    } else if (lowerName.contains('squamous')) {
      return 'Assets/categories/squamous cell.jpg';
    }

    return 'Assets/categories/default.jpg';
  }


  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    final isEn = localProvider?.isEn() ?? true;

    if (isEn) {
      if (hour < 12) {
        return 'Good Morning';
      } else if (hour < 17) {
        return 'Good Afternoon';
      } else {
        return 'Good Evening';
      }
    } else {
      if (hour < 12) {
        return 'صباح الخير';
      } else if (hour < 17) {
        return 'مساء الخير';
      } else {
        return 'مساء الخير';
      }
    }
  }

  String getWelcomeMessage() {
    final isEn = localProvider?.isEn() ?? true;
    final name = _userName.isNotEmpty ? _userName : (isEn ? 'User' : 'مستخدم');

    if (isEn) {
      return 'Welcome back, $name!';
    } else {
      return 'مرحباً بعودتك، $name!';
    }
  }

  void navigateToAIConsultant(BuildContext context) {
    showAIConsultantAlert(context);
  }

  void showAIConsultantAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localProvider!.isEn() ? 'AI Consultant' : 'مستشار ذكي',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'You must Upload Your The Affected Part of skin',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                handleUploadButtonPressed(context);
              },
              child: Text(
                localProvider!.isEn() ? 'OK' : 'موافق',
                style: TextStyle(
                  color: MyTheme.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToUpload(BuildContext context) {
    handleUploadButtonPressed(context);
  }

  void handleUploadButtonPressed(BuildContext context) {
    final rootContext = context;

    showModalBottomSheet(
      context: rootContext,
      backgroundColor: themeProvider!.isDark() ? MyTheme.darkBlue : MyTheme.whiteBlue,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: MyTheme.lightBlue, size: 24),
                title: Text(
                  localProvider!.isEn() ? 'Choose From Gallery' : 'من المعرض',
                  style: Theme.of(rootContext).textTheme.displayMedium!.copyWith(
                    color: themeProvider!.isDark() ? MyTheme.offWhite : MyTheme.blue,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext); // Close sheet first
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _pickImageFromGallery(rootContext); // Use original context for navigation
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red, size: 24),
                title: Text(
                  localProvider!.isEn() ? 'Cancel' : 'إلغاء',
                  style: Theme.of(rootContext).textTheme.displayMedium!.copyWith(
                    color: themeProvider!.isDark() ? MyTheme.offWhite : MyTheme.blue,
                    fontSize: 16,
                  ),
                ),
                onTap: () => Navigator.pop(bottomSheetContext),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _pickImageFromGallery(BuildContext context) async {
    try {
      print('Starting image picker...');
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      print('Image picker result: ${pickedFile?.path}');

      if (pickedFile != null) {
        print('Navigating to upload tab with image: ${pickedFile.path}');
        if (context.mounted) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamed(Routes.uploadTabRoute, arguments: File(pickedFile.path));
        }
      } else {
        print('No image selected');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localProvider!.isEn()
                    ? 'No image selected'
                    : 'لم يتم اختيار صورة',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void navigateToPharmacyView() {
    navigator?.navigateToPharmacyView();
  }

  void navigateToCategoriesView() {
    navigator?.navigateToCategoriesView();
  }

  void navigateToCategoryDetails(dynamic category) {
    navigator?.navigateToCategoryDetails(category);
  }

  Future<void> refreshUserData() async {
    await loadUserData();
  }

  Future<void> refreshRecommendedCategories() async {
    await loadRecommendedCategories();
  }
}
