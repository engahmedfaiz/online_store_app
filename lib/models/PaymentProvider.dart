class PaymentProvider {
  final String id;
  final String name;
  final String? imageUrl;
  final bool isActive;

  PaymentProvider({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.isActive,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl ?? "",
      'isActive': isActive,
    };
  }
}
