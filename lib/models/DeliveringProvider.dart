class DeliveringProvider {
  final String id;
  final String name;
  final String? logoUrl;
  final bool isActive;
  final String? duration;
  final double? price;

  DeliveringProvider({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.isActive,
    this.duration,
    this.price,
  });

  factory DeliveringProvider.fromJson(Map<String, dynamic> json) {
    return DeliveringProvider(
      id: json['deliveringProvider']['id'] ?? '',
      name: json['deliveringProvider']['name'] ?? '',
      logoUrl: json['deliveringProvider']['logoUrl'],
      isActive: json['deliveringProvider']['isActive'] ?? false,
      duration: json['deliveringProvider']['duration'],
      price: json['deliveringProvider']['price'] != null
          ? double.tryParse(json['deliveringProvider']['price'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'isActive': isActive,
      'duration': duration,
      'price': price,
    };
  }
}
