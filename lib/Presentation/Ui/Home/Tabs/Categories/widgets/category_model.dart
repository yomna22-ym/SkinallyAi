class CategoryModel {
  final int id;
  final String name;
  final String? title;
  final String? description;
  final List<String> imagesUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.title,
    this.description,
    required this.imagesUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? json['Id'] ?? 0,
      name: json['name'] ?? json['Name'] ?? '',
      title: json['title'] ?? json['Title'],
      description: json['description'] ?? json['Description'],
      imagesUrl: _parseImageUrls(json['images'] ?? json['Images'] ?? []), // Fixed: Parse 'images' array
    );
  }

  static List<String> _parseImageUrls(dynamic imagesArray) {
    if (imagesArray is List) {
      return imagesArray.map((imageObj) {
        // Handle the nested structure from API: images[{id, imageUrl}]
        if (imageObj is Map<String, dynamic>) {
          return imageObj['imageUrl']?.toString() ?? '';
        }
        return imageObj.toString();
      }).where((url) => url.isNotEmpty).toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'imagesUrl': imagesUrl,
    };
  }
}
