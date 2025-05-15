class Store {
  final String id;
  final String code;
  final String businessName;
  final String businessNameEn;
  final String contactPerson;
  final String whatsappPhone;
  final String storeType;
  final String entityType;
  final String? profileImageUrl; // يمكن أن يكون null
  final String notes;
  final String phone;
  final String physicalAddress;
  final bool isActive;
  final String slugDomain;
  final String vendorId;
  final String mainCategoryId;
  final String templateId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> currencies;
  final Map<String, String>? socialLinks; // يمكن أن يكون null

  Store({
    required this.id,
    required this.code,
    required this.businessName,
    required this.businessNameEn,
    required this.contactPerson,
    required this.whatsappPhone,
    required this.storeType,
    required this.entityType,
    this.profileImageUrl,
    required this.notes,
    required this.phone,
    required this.physicalAddress,
    required this.isActive,
    required this.slugDomain,
    required this.vendorId,
    required this.mainCategoryId,
    required this.templateId,
    required this.createdAt,
    required this.updatedAt,
    required this.currencies,
    this.socialLinks,
  });

  // دالة لتحويل JSON إلى كائن من نوع Store
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      businessName: json['businessName'] ?? 'غير متاح', // عرض قيمة افتراضية إذا كانت فارغة
      businessNameEn: json['businessNameEn'] ?? 'Not Available',
      contactPerson: json['contactPerson'] ?? 'غير محدد',
      whatsappPhone: json['whatsappPhone'] ?? '',
      storeType: json['storeType'] ?? 'غير محدد',
      entityType: json['entityType'] ?? 'غير محدد',
      profileImageUrl: json['profileImageUrl'],
      notes: json['notes'] ?? 'لا توجد ملاحظات',
      phone: json['phone'] ?? '',
      physicalAddress: json['physicalAddress'] ?? 'العنوان غير محدد',
      isActive: json['isActive'] ?? false,
      slugDomain: json['slugDomain'] ?? '',
      vendorId: json['vendorId'] ?? '',
      mainCategoryId: json['mainCategoryId'] ?? '',
      templateId: json['templateId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      currencies: List.from(json['currencies'] ?? []),
      socialLinks: json['socialLinks'] != null
          ? Map<String, String>.from(json['socialLinks'])
          : null,
    );
  }

  // دالة لتحويل الكائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'businessName': businessName,
      'businessNameEn': businessNameEn,
      'contactPerson': contactPerson,
      'whatsappPhone': whatsappPhone,
      'storeType': storeType,
      'entityType': entityType,
      'profileImageUrl': profileImageUrl,
      'notes': notes,
      'phone': phone,
      'physicalAddress': physicalAddress,
      'isActive': isActive,
      'slugDomain': slugDomain,
      'vendorId': vendorId,
      'mainCategoryId': mainCategoryId,
      'templateId': templateId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'currencies': currencies,
      'socialLinks': socialLinks,
    };
  }
}

