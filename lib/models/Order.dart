class Order {
  final String id;
  final String orderStatus;
  final double total;
  final DateTime date;
  final String paymentMethod;
  final String shippingAddress;

  Order({
    required this.id,
    required this.orderStatus,
    required this.total,
    required this.date,
    required this.paymentMethod,
    required this.shippingAddress,
  });

  // دالة ثابتة فارغة
  static Order empty() {
    return Order(
      id: '',
      orderStatus: '',
      total: 0.0,
      date: DateTime.now(),
      paymentMethod: '',
      shippingAddress: '',
    );
  }

  // دالة للتحقق من إذا كان الطلب فارغًا
  bool get isEmpty => id.isEmpty;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      total: json['total'] ?? 0.0,
      date: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      paymentMethod: json['paymentMethod'] ?? '',
      shippingAddress: json['streetAddress'] ?? '',
    );
  }
}
