class ShippingAddress {
  final String? id;
  final String customerId;
  final String addressName;
  final String streetAddress;
  final String city;
  final String district;
  final String country;
  final String? description;
  final Map<String, dynamic>? location;
  final String? addressType; // أضف هذا الحقل الجديد

  ShippingAddress({
    this.id,
    required this.customerId,
    required this.addressName,
    required this.streetAddress,
    required this.city,
    required this.district,
    required this.country,
    this.description,
    this.location,
    this.addressType, // أضفه هنا

  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id']?.toString(), // إضافة هذا السطر
      customerId: json['customerId']?.toString() ?? '',
      addressName: json['addressName']?.toString() ?? '',
      streetAddress: json['streetAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      description: json['description']?.toString(),
      location: json['location'] is Map ? Map<String, dynamic>.from(json['location']) : null,


    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'addressName': addressName,
      'streetAddress': streetAddress,
      'city': city,
      'district': district,
      'country': country,
      'addressType': addressType, // أضفه هنا

      'description': description,
    };
  }
}
