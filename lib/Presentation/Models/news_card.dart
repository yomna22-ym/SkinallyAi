class Article {
  final int id;
  final String title;
  final String image;
  final List<ContentSection> content;

  Article({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      image: json['image'] as String? ?? '',
      content:
          (json['content'] as List?)
              ?.map((e) => ContentSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ContentSection {
  final String? heading;
  final String body;
  final String? image;

  ContentSection({this.heading, required this.body, this.image});

  factory ContentSection.fromJson(Map<String, dynamic> json) {
    return ContentSection(
      heading: json['heading'] as String?,
      body: json['body'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}
