class AddressModel {
  final String id;
  final String customerId;
  final String addressName;
  final String streetAddress;
  final String city;
  final String district;
  final String country;
  final String? description;
  final Map<String, dynamic>? location;

  AddressModel({
    required this.id,
    required this.customerId,
    required this.addressName,
    required this.streetAddress,
    required this.city,
    required this.district,
    required this.country,
    this.description,
    this.location,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'],
      customerId: json['customerId'],
      addressName: json['addressName'],
      streetAddress: json['streetAddress'],
      city: json['city'],
      district: json['district'],
      country: json['country'],
      description: json['description'],
      location: json['location'],
    );
  }
}
