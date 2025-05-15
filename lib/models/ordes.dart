class Order {
  final String id;
  final DateTime date;
  final String status;
  final double total;
  final String paymentMethod;
  final String shippingAddress;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double tax;

  const Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      total: json['total'].toDouble(),
      paymentMethod: json['paymentMethod'],
      shippingAddress: json['shippingAddress'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      shippingCost: json['shippingCost'].toDouble(),
      tax: json['tax'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status,
      'total': total,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'tax': tax,
    };
  }

  factory Order.empty() {
    return Order(
      id: '',
      date: DateTime.now(),
      status: '',
      total: 0.0,
      paymentMethod: '',
      shippingAddress: '',
      items: [],
      subtotal: 0.0,
      shippingCost: 0.0,
      tax: 0.0,
    );
  }

  bool get isEmpty => id.isEmpty;
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
    };
  }
}
