
class ProductModel {
  final String id;
  final String title;
  final String slug;
  final String? imageUrl;
  final List<String> productImages;
  final String descripti;
  final bool isActive;
  final bool isWholesale;
  final int totalSalesQty;

  final String sku;
  final String? barcode;
  final String productCode;
  final String unit;
  final double? oldPrice;
  final double productPrice;
  final double salePrice;
  final double? wholesalePrice;
  final int? wholesaleQty;
  final int productStock;
  final int qty;
  final List<String> tags;
  final String categoryId;
  final String? subCategoryId;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> orderItems;
  final List<dynamic> saleItems;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    this.imageUrl,
    required this.totalSalesQty,

    required this.productImages,
    required this.descripti,
    required this.isActive,
    required this.isWholesale,
    required this.sku,
    this.barcode,
    required this.productCode,
    required this.unit,
    this.oldPrice,
    required this.productPrice,
    required this.salePrice,
    this.wholesalePrice,
    this.wholesaleQty,
    required this.productStock,
    required this.qty,
    required this.tags,
    required this.categoryId,
    this.subCategoryId,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
    required this.saleItems,
  });

  // دالة التحويل إلى Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'imageUrl': imageUrl,
      'productImages': productImages,
      'descripti': descripti,
      'isActive': isActive,
      'totalSalesQty': totalSalesQty ,

      'isWholesale': isWholesale,
      'sku': sku,
      'barcode': barcode,
      'productCode': productCode,
      'unit': unit,
      'oldPrice': oldPrice,
      'productPrice': productPrice,
      'salePrice': salePrice,
      'wholesalePrice': wholesalePrice,
      'wholesaleQty': wholesaleQty,
      'productStock': productStock,
      'qty': qty,
      'tags': tags,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'storeId': storeId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'orderItems': orderItems,
      'saleItems': saleItems,
    };
  }

  // دالة الإنشاء من Map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      totalSalesQty: json['totalSalesQty'] ?? 0,

      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'بدون عنوان',
      slug: json['slug']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      productImages: _parseImages(json['productImages']),
      descripti: json['descripti']?.toString() ?? '',
      isActive: json['isActive'] ?? false,
      isWholesale: json['isWholesale'] ?? false,
      sku: json['sku']?.toString() ?? 'بدون SKU',
      barcode: json['barcode']?.toString(),
      productCode: json['productCode']?.toString() ?? '',
      unit: json['unit']?.toString() ?? 'حبة',
      oldPrice: _toDouble(json['oldPrice']),
      productPrice: _toDouble(json['productPrice']),
      salePrice: _toDouble(json['salePrice']),
      wholesalePrice: _toDouble(json['wholesalePrice']),
      wholesaleQty: _toInt(json['wholesaleQty']),
      productStock: _toInt(json['productStock']),
      qty: _toInt(json['qty']),
      tags: _parseTags(json['tags']),
      categoryId: json['categoryId']?.toString() ?? '',
      subCategoryId: json['subCategoryId']?.toString(),
      storeId: json['storeId']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      orderItems: json['orderItems'] is List ? json['orderItems'] : [],
      saleItems: json['saleItems'] is List ? json['saleItems'] : [],
    );
  }

  // دوال مساعدة
  static List<String> _parseImages(dynamic images) {
    if (images is List) return List<String>.from(images);
    if (images is String) return [images];
    return [];
  }

  static List<String> _parseTags(dynamic tags) {
    if (tags is List) return List<String>.from(tags);
    if (tags is String) return [tags];
    return [];
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  // دالة حساب الخصم
  int get discountPercentage {
    if (salePrice <= 0 || salePrice >= productPrice) return 0;
    return ((productPrice - salePrice) / productPrice * 100).round();
  }

  // دالة التحقق من التوفر
  bool get isAvailable => productStock > 0;

  // دالة الحصول على السعر المناسب
}