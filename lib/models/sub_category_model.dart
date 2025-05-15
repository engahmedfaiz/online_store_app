    // lib/models/sub_category_model.dart
    class SubCategoryModel {
      final String id;
      final String title;
      final String storeId;
      final String imageUrl;

      final String categoryId;
      final bool isActive;

      SubCategoryModel({
        required this.id,
        required this.title,
        required this.imageUrl,

        required this.storeId,
        required this.categoryId,
        required this.isActive,
      });

      factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
        return SubCategoryModel(
          id: json['id'] ?? '',
          title: json['title'] ?? 'بدون عنوان',
          imageUrl: json['imageUrl'] ?? 'بدون عنوان',

          storeId: json['storeId'] ?? '',
          categoryId: json['categoryId'] ?? '',
          isActive: json['isActive'] ?? false,
        );
      }
    }