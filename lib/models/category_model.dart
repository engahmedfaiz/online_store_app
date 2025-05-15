class CategoryModel {
  final String id;
  final String title;
  final String slug;
  final String? imageUrl;
  final String? description;
  final bool isActive;

  final String mainCategoryId;
  final String storeId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    this.imageUrl,
    this.description,
    required this.isActive,
    required this.mainCategoryId,
    required this.storeId,
    required this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // تأكيد استخراج الـ ID بشكل صحيح
    return CategoryModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'بدون عنوان',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      description: json['description']?.toString(),
      isActive: json['isActive'] ?? false,
      mainCategoryId: json['mainCategoryId']?.toString() ?? '',
      storeId: json['storeId']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}