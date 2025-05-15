
class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String subtitle;
  final String bottomText;
  final int discountPercentage;

  BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.subtitle,
    required this.bottomText,
    required this.discountPercentage,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      subtitle: json['subtitle'] ?? '',
      bottomText: json['link'] ?? '',
      discountPercentage: json['discountPercentage'] ?? 0,
    );
  }
}