

class Review {
  final String id;
  final int rating;
  final String? comment;
  final String storeId;
  final String? customerStoreId;
  final DateTime createdAt;
  final String? customerName;

  Review({
    required this.id,
    required this.rating,
    this.comment,
    required this.storeId,
    this.customerStoreId,
    required this.createdAt,
    this.customerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      storeId: json['storeId'],
      customerStoreId: json['customerStoreId'],
      createdAt: DateTime.parse(json['createdAt']),
      customerName: json['customerStore']?['customer']?['firstName'] != null
          ? '${json['customerStore']?['customer']?['firstName']} '
          '${json['customerStore']?['customer']?['lastName']}'
          : 'مستخدم مجهول',
    );
  }
}
